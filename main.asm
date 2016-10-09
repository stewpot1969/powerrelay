
;  file to control a relay

.nolist
.include "tn13def.inc"
.list

; VOLTAGE LEVELS
; ADC result = 50.8*voltage - 2.39
.define   V_HIGH            668     ; ~13.2V
.define   V_LOW             617     ; ~12.2V

; temp reg for things
.def  scratch = r23
; timer countdown for state changes etc
.def  count   = r24
.define   COUNT_PRE_ON      5   ; seconds of engine-on volts before bootup
.define   COUNT_PRE_OFF     60    ; seconds from shutdown relay on to power off
.define   COUNT_PRE_SHUT    240     ; secs of engine-off volts before shutdown

; prescaler for second counter
.def  count2  = r25
.define   COUNT2_PRESCALE   4

; state of the switch
.def  state   = r26
.define   STATE_IDLE        1   ; resting state
.define   STATE_PRE_ON      2   ; engine started
.define   STATE_ON          3   ; power on to Pi
.define   STATE_PRE_SHUT    4   ; engine turned off, Pi still running
.define   STATE_PRE_OFF     5   ; shutdown relay on, Pi shutting down
.define   STATE_MANUAL      6   ; button has been pressed

; state of the voltage input
.def  v_state = r27
.define   V_STATE_SICK      1     ; <12.2V - battery getting down
.define   V_STATE_OK        2     ; 12.2-13.2V  - engine off, battery OK
.define   V_STATE_HIGH      3     ; >13.2V - engine running


.macro    set_output
    in    r16,DDR@0
    ori   r16,1<<@1
    out   DDR@0,r16
.endm
.macro    set_pullup
    in    r16,PORT@0
    ori   r16,1<<@1
    out   PORT@0,r16
.endm
.macro    set_high
    in    r16,PORT@0
    ori   r16,1<<@1
    out   PORT@0,r16
.endm
.macro    set_low
    in    r16,PORT@0
    andi  r16,255-(1<<@1)
    out   PORT@0,r16
.endm

.dseg
.org  SRAM_START

; myval:    .byte 1

.cseg
.org          0x0000


reset:
    ldi     r16,low(RAMEND)
    out     SPL,r16

    ; setup I/O
    ; 1: _reset
    ; 2: PB3 - relay out
    ; 3: PB4 - 2nd relay?
    ; 4: GND
    ; 5: PB0 - button
    ; 6: PB1 - indicator LED
    ; 7: PB2 - ADC1 - sys V in
    ; 8: 5V
    set_output  B,1       ; PB1 LED out
    set_output  B,3       ; PB3 relay 1 out
    set_output  B,4       ; PB4 relay 2 out
    set_pullup  B,0       ; PB0 button pullup

    ; setup ADC (Vref=Vcc, /8 prescaler (125kHz))
    ; PB2 (ADC1), ADLAR=0
    
    ldi     r16,1     ; Vref=Vcc, ADLAR=0, MUX1=1 (ADC1 PB2)
    out     ADMUX,r16
    
    ldi     r16,(1<<ADEN)+3 ; enable ADC, /8
    out     ADCSRA,r16
    
    ; setup timer0
    ; compare output modes normal, WGM=CTC
    ldi     r16,0b00000010
    out     TCCR0A,r16
    ; WGM=CTC, clock prescaler = 1024
    ldi     r16,0b00000101
    out     TCCR0B,r16
    ; overflow every 250 cycles = 0.5 seconds
    ldi     r16,250
    out     OCR0A,r16

    ; prepare states and stuff for the loop
    ldi     count,-1
    ldi     state,STATE_IDLE

loop:
    ; step 1: wait for the interrupt flag to be set
    in    r16,TIFR0
    sbrs  r16,OCF0A
    rjmp  loop
    
    ; step 2: clear interrupt flag
    ldi   r16,1<<OCF0A
    out   TIFR0,r16

    ; step 3 - read ADC
    ldi     r16,(1<<ADEN)+(1<<ADSC)+1   ; start conversion
    out     ADCSRA,r16
wfadc:
    in      r16,ADCSRA
    andi    r16,(1<<ADIF)     ; check if ADIF is set (ADC complete)
    breq    wfadc

    ; step 4 - look at the voltage
    in      r16,ADCL
    in      r17,ADCH
    ldi     r18,low(V_HIGH)
    ldi     r19,high(V_HIGH)
    cp      r16,r18     ; subtract V_HIGH from ADC
    cpc     r17,r19
    brcs    s4_1    ; branch if ADC < V_HIGH
    ldi     v_state,V_STATE_HIGH
    rjmp    s5
s4_1:
    ldi     r18,low(V_LOW)
    ldi     r19,high(V_LOW)
    cp      r16,r18   ; subtract V_LOW from ADC
    cpc     r17,r19
    brcs    s4_2      ; branch if ADC < V_LOW
    ldi     v_state,V_STATE_OK
    rjmp    s5
s4_2:
    ldi     v_state,V_STATE_SICK

    ; step 4.1 - chooch the LED based on v_state
s5:
    cpi     v_state,V_STATE_SICK
    brne    s5_1
    set_low   B,1     ; LED off
    rjmp    loop
s5_1:
    cpi     v_state,V_STATE_HIGH
    brne    s5_2
    set_high  B,1   ; LED on
    rjmp    loop
s5_2:
    in    r16,PORTB   ; invert LED
    ldi   r17,1<<1
    eor   r16,r17
    out   PORTB,r16
    rjmp  loop
    
    ; step 5  - decrement timer prescaler and timer
;s5:
    dec   count2
    brne  s6
    ldi   count2,COUNT2_PRESCALE    ; reload prescaler
    cpi   count,-1      ; count=-1 means counter not being used
    breq  s6
    dec   count

    ; step 6 - split out based on state
s6:
    cpi   state,STATE_IDLE
    brne  s6_2    ; branch if not idle
      cpi   v_state,V_STATE_HIGH
      brne  s6_2
        ldi   state,STATE_PRE_ON    ; state=idle, v=high
        ldi   count,COUNT_PRE_ON
        rjmp  s7
s6_2:
    cpi   state,STATE_PRE_ON
    brne  s6_3    ; branch if not pre_on
      cpi   v_state,V_STATE_SICK
      brne  s6_2a
        ldi   state,STATE_IDLE
        ldi   count,-1
        rjmp  s7
s6_2a:
      cpi   v_state,V_STATE_OK
      brne  s6_2b
        ldi   state,STATE_IDLE
        ldi   count,-1
        rjmp  s7
s6_2b:
      tst   count
      breq  s6_2c
        rjmp  s7
s6_2c:
        ldi   state,STATE_ON    ; state=ON
        ldi   count,-1    ; timer off
        set_high  B,4     ; power relay on
        set_high  B,1     ; LED on
        rjmp  s7
s6_3:
    cpi   state,STATE_ON
    brne  s6_4
      cpi   v_state,V_STATE_SICK
      brne  s6_3a
        set_low B,4   ; power relay off
        set_low B,1   ; LED off
        ldi   state,STATE_IDLE
        rjmp  s7
s6_3a:
      cpi   v_state,V_STATE_OK
      brne  s6_4
        ldi   state,STATE_PRE_SHUT
        ldi   count,COUNT_PRE_SHUT
s6_4:
    cpi   state,STATE_PRE_SHUT
    brne  s6_5
      cpi   v_state,V_STATE_SICK
      brne  s6_4a
        ldi   state,STATE_IDLE
        set_low   B,4   ; LED and relay off
        set_low   B,1
        rjmp    s7
s6_4a:
      cpi   v_state,V_STATE_HIGH
      brne  s6_4b
        ldi   state,STATE_ON
        ldi   count,-1
        rjmp    s7
s6_4b:
      tst   count
      brne    s7
        ldi   state,STATE_PRE_OFF
        set_high  B,3     ; shutdown relay on
        ldi   count,COUNT_PRE_OFF
        rjmp  s7
s6_5:
    cpi   state,STATE_PRE_OFF
    brne  s7      ; should never branch
      cpi   v_state,V_STATE_SICK
      brne  s6_5a
        ldi   state,STATE_IDLE
        set_low   B,4     ; power relay off
        set_low   B,1     ; LED off
        rjmp    s7
s6_5a:
      tst   count
      brne  s7
        ldi   state,STATE_IDLE
        set_low   B,3   ; shutdown relay off
        set_low   B,1   ; LED off
        set_low   B,4   ; power relay off
        ldi   count,-1

   ; step 7: do it all again
s7:
    rjmp  loop
    

;################################################################

