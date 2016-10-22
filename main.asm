
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
.define   COUNT_PRE_ON      10   ; seconds of engine-on volts before bootup
.define   COUNT_PRE_OFF     20    ; seconds from shutdown relay on to power off
.define   COUNT_PRE_SHUT    180     ; secs of engine-off volts before shutdown

; prescaler for second counter
.def  count2  = r25
.define   COUNT2_PRESCALE   4

; state of the switch
.def  state   = r26
.define   STATE_IDLE        1   ; resting state
.define   STATE_PRE_ON      2   ; engine started
.define   STATE_ON          4   ; power on to Pi
.define   STATE_PRE_SHUT    8   ; engine turned off, Pi still running
.define   STATE_PRE_OFF     16  ; shutdown relay on, Pi shutting down
.define   STATE_MANUAL      32  ; button has been pressed

; state of the voltage input
.def  v_state = r27
.define   V_STATE_SICK      1     ; <12.2V - battery getting down
.define   V_STATE_OK        2     ; 12.2-13.2V  - engine off, battery OK
.define   V_STATE_HIGH      4     ; >13.2V - engine running
.define   V_STATE_BUTTON    8     ; button pushed


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
    ldi   r16,(1<<1)|(1<<3)|(1<<4)
    out   DDRB,r16
    ;set_output  B,1       ; PB1 LED out
    ;set_output  B,3       ; PB3 relay 1 out
    ;set_output  B,4       ; PB4 relay 2 out
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
    ldi     count,-1        ; timer off
    ldi     state,STATE_IDLE    ; state=IDLE
    ldi     count2,COUNT2_PRESCALE  ; load prescaler

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
    
    ; step 5  - check button, decrement timer prescaler and timer
s5:
    in    r16,PINB
    andi  r16,1     ; check bit 0
    brne  s5_1      ; PINB.0=1 = no button
    ori   v_state,V_STATE_BUTTON
s5_1:
    dec   count2
    brne  loop      ; no prescale zero? All done for this time
    ldi   count2,COUNT2_PRESCALE    ; reload prescaler
    cpi   count,-1      ; count=-1 means counter not being used
    breq  s6
    dec   count


    ; step 6 - split out based on state
s6:
    ldi   ZL,low(calltable*2)
    ldi   ZH,high(calltable*2)
s6_1:
    lpm   r16,Z+    ; r16=V_STATE mask
    tst   r16
    breq  loop      ; table ends in zero
    lpm   r17,Z+    ; r17=STATE mask
    lpm   YL,Z+     ; save subroutine address in Y
    lpm   YH,Z+
    and   r16,v_state   ; and v_state with v_state mask
    breq  s6_1      ; no overlap? go to next entry in calltable
    and   r17,state     ; now check state mask
    breq  s6_1        ; no overlap? next entry
    mov   ZH,YH       ; move Y to Z
    mov   ZL,YL
    icall           ; call subroutine pointed to by Z
    rjmp  loop    

;========================================================
; SUBROUTINES POINTED TO BY CALLTABLE:

idleoff:    ; go into idle mode
  ldi   state,STATE_IDLE
  ldi   count,-1
  in    r16,PORTB
  andi  r16,0b11100101  ; 1,3,4 off = power,shutdown,LED
  out   PORTB,r16
  ret  
  
preshut:    ; sets state=PRE_SHUT
  ldi   state,STATE_PRE_SHUT
  ldi   count,COUNT_PRE_SHUT
  ret
  
preoff:   ;state=PRE_SHUT,Vok
  tst   count     ; timer before setting shutdown relay
  brne  preoff_2
  ldi   state,STATE_PRE_OFF
  ldi   count,COUNT_PRE_OFF
  set_high  B,3   ; shutdown relay on
preoff_2:
  ret

timer_idle:     ; state=PRE_OFF,Vok
  tst   count     ; wait for timer to run out before going idle
  brne  timer_idle_2
  rcall idleoff
timer_idle_2:
  ret

preon:      ; state=IDLE, Vhigh
  ldi   state,STATE_PRE_ON
  ldi   count,COUNT_PRE_ON
  ret
  
pi_on:    ; turn the Pi on
  tst   count   ; do nothing until timer runs out
  brne  pi_on_2
  ldi   state,STATE_ON
  ldi   count,-1
  set_high  B,1   ; LED on
  set_high  B,4   ; Pi power on
pi_on_2:
  ret

cancel_shut:    ; goes from state preshut to state on i.e. engine restarts
  ldi   state,STATE_ON
  ldi   count,-1
  ret

manual_on:
  set_high  B,1   ; LED ON
  set_high  B,4   ; Pi power on
  ldi   state,STATE_MANUAL
  ldi   count,5
  ret

manual_off:
  cpi   count,-1
  brne  eomanualoff
  ldi   count,0
  rcall preoff
eomanualoff:
  ret

calltable:
  .db   V_STATE_BUTTON,STATE_IDLE
    .dw manual_on
  .db   V_STATE_BUTTON,STATE_MANUAL
    .dw manual_off
  .db   V_STATE_SICK,STATE_PRE_ON|STATE_ON|STATE_PRE_SHUT|STATE_PRE_OFF
    .dw idleoff
  .db   V_STATE_OK,STATE_PRE_ON
    .dw idleoff
  .db   V_STATE_OK,STATE_ON
    .dw preshut
  .db   V_STATE_OK,STATE_PRE_SHUT
    .dw preoff    
  .db   V_STATE_OK,STATE_PRE_OFF
    .dw timer_idle    
  .db   V_STATE_HIGH,STATE_IDLE
    .dw preon
  .db   V_STATE_HIGH,STATE_PRE_ON
    .dw pi_on
  .db   V_STATE_HIGH,STATE_PRE_SHUT
    .dw cancel_shut
  .db   0,0
;################################################################

