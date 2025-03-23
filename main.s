; main.s - Heartbeat detection main program (optimized)
#include <xc.inc>

; External references
extrn  ADC_Setup, ADC_Read, adc_result
extrn  PEAK_DETECTION_INIT, DETECT_SIGNAL_STATE
extrn  INTERVAL_SETUP, INTERVAL_PROCESS_PEAK, TIMER1_ISR

; Reserve data space in uninitialized data section
psect  udata
delay_count:    ds 1    ; reserve one byte for counter in the delay routine
prev_state:     ds 1    ; reserve one byte for previous signal state (0=above, 1=below)

; Main code section
psect  code, abs    
rst:   org 0x0
       goto  setup
; High priority interrupt vector
org    0x0008              ; High priority interrupt vector location
goto   high_isr            ; Jump to interrupt service routine

; Interrupt Service Routine
high_isr:
       call   TIMER1_ISR   ; Call Timer1 interrupt handler
       retfie              ; Return from interrupt and reenable interrupts

; Setup routine
setup:  
    ; Configure PORTD as output for heartbeat indicator
    clrf   PORTD, A         ; Clear PORTD
    movlw  0x00
    movwf  TRISD, A         ; Set all PORTD pins as output

    ; Initialize delay counter
    movlw  10               ; Set delay value to 10
    movwf  delay_count, A   ; Initialize delay counter

    ; Initialize previous state (assume starting above threshold)
    clrf   prev_state, A    ; Set to 0 (above threshold)

    call   ADC_Setup        ; setup ADC
    call   PEAK_DETECTION_INIT ; initialize peak detection
    call   INTERVAL_SETUP   ; initialize interval measurement

    goto   main_loop

; Main program loop
main_loop:
    ; Read ADC value
    call   ADC_Read         ; Read analog value

    ; Check signal state
    call   DETECT_SIGNAL_STATE ; Detect if signal is below threshold

    ; After DETECT_SIGNAL_STATE, carry flag is set if signal is below threshold
    ; If carry is set, current state = 1 (below), else current state = 0 (above)

    ; Check if signal is below threshold (carry set)
    bnc    signal_above     ; Branch if signal is above threshold

    ; Signal below threshold - set output LED
    movlw  0x01             ; Set bit 0 to 1
    movwf  PORTD, A         ; Turn on LED

    ; Update previous state to 1 (below threshold)
    movlw  0x01
    movwf  prev_state, A

    bra    main_loop_end    ; Continue to next iteration

signal_above:
    ; Signal above threshold - turn off LED
    clrf   PORTD, A         ; Turn off LED

    ; Check if this is a transition from below to above (end of peak)
    movf   prev_state, W, A ; Get previous state
    bz     no_transition    ; Skip if previous state was 0 (already above)

    ; This is a transition from below to above - process the peak
    call   INTERVAL_PROCESS_PEAK ; Process peak and output interval to PORTC

no_transition:
    ; Update previous state to 0 (above threshold)
    clrf   prev_state, A
main_loop_end:
    bra    main_loop        ; Continue the main loop
end    ; End of program
