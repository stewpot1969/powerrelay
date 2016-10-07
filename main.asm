
;  file to control a relay

.include "tn13def.inc"

.def    myreg       = r20

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
    ; enable Compare A interrupt
    ;ldi     r16,1<<OCIE0A
    ;out     TIMSK0,r16
    ; #### Don't enable any interrupts -
    ; poll the interrupt flag instead


loop:
    ; step 1 - read ADC
    ldi     r16,(1<<ADEN)+(1<<ADSC)+1   ; start conversion
    out     ADCSRA,r16
wfadc:
    in      r16,ADCSRA
    andi    r16,(1<<ADIF)     ; check if ADIF is set (ADC complete)
    breq    wfadc
    ; flash first two bits
    in      r18,ADCH
    lsl     r18
    lsl     r18
    lsl     r18
    lsl     r18
    lsl     r18
    lsl     r18
    rcall   flash1
    rcall   flash1
    in      r18,ADCL
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   flash1
    rcall   wait_long    
    rcall   wait_long    
    rjmp    loop

flash1:       ; short or long flash based on MSB of r18
    set_high  B,1
    rcall   wait_short
    lsl     r18
    brcc    flash12
    rcall   wait_long
flash12:
    set_low   B,1
    rcall   wait_long
    ret

wait_short:
    ldi   r21,250     ; ~250 x 760 cycles ~ 0.2 sec
wait_short_1:
    ldi   r22,255
wait_short_2:
    dec   r22
    brne  wait_short_2
    dec   r21
    brne  wait_short_1
    ret
wait_long:
    rcall wait_short
    rcall wait_short
    rcall wait_short
    rcall wait_short
    rcall wait_short
    rcall wait_short
    ret



    ; step 1: wait for the interrupt flag to be set
    in    r16,TIFR0
    sbrs  r16,OCF0A
    rjmp  loop
    
    ; step 2: clear interrupt flag
    ldi   r16,1<<OCF0A
    out   TIFR0,r16
    
    ; step 3: invert LED
    in    r16,PORTB
    ldi   r17,0b00000010
    eor   r16,r17
    out   PORTB,r16
    
   ; step 4: do it all again
    rjmp  loop
    
nowhere:
    rjmp    nowhere

;################################################################

    
ext_int0:
pc_int0:
tim0_ovf:
ee_rdy:
ana_comp:
tim0_compa:
tim0_compb:
watchdog:
adc_complete:
;    reti
