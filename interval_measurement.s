; interval_measurement.s - Measures intervals between heartbeat peaks using Timer1
; PIC18F87K22 Processor
#include <xc.inc>
    
; Export public functions
global  INTERVAL_SETUP, INTERVAL_PROCESS_PEAK, TIMER1_ISR, interval_count
    
; Reserve data space in uninitialized data section
psect  udata
interval_count:    ds 1    ; Counter for hundredths of seconds
    
psect interval_code, class=CODE

; INTERVAL_SETUP - Initialize timer and PORTC for interval measurement
; Sets up Timer1 to generate an interrupt every 10ms (1/100th of a second)
; Configures PORTC as output for displaying interval values
INTERVAL_SETUP:
    ; Configure PORTC as output
    clrf    PORTC, A        ; Clear PORTC
    movlw   0x00
    movwf   TRISC, A        ; Set all PORTC pins as output
    movwf   TRISJ, A        ; Set all PORTJ pins as output (displays interval_count)
    
    ; Clear interval counter
    clrf    interval_count, A
    
    ; Configure Timer1:
    movlw   0x33            ; T1CON: 16-bit mode, 1:8 prescaler, internal clock, Timer1 on
    movwf   T1CON, A
    
    ; Load preload value (0xEC78 = 60536)
    movlw   high 0xB1E0     ; High byte
    movwf   TMR1H, A
    movlw   low 0xB1E0      ; Low byte
    movwf   TMR1L, A
    
    ; Enable Timer1 interrupt
    bsf     TMR1IE  ; Enable Timer1 overflow interrupt (TMR1IE = bit 0 of PIE1)
    bsf     PEIE    ; Enable peripheral interrupts (PEIE = bit 6 of INTCON)
    bsf     GIE     ; Enable global interrupts (GIE = bit 7 of INTCON)
    
    return                  ; Return from subroutine

; TIMER1_ISR - Timer1 Interrupt Service Routine
; Called every 10ms when Timer1 overflows
; Increments the interval counter and reloads Timer1
TIMER1_ISR:
    btfsc   TMR1IF      ; Check if Timer1 interrupt flag (TMR1IF) is set
    goto    TIMER1_HANDLER  ; If set, handle the interrupt
    return                  ; Return if not Timer1 interrupt
    
TIMER1_HANDLER:
    ; Reload Timer1 preload value (0xEC78 = 60536)
    movlw   high 0xB1E0     ; High byte
    movwf   TMR1H, A
    movlw   low 0xB1E0      ; Low byte
    movwf   TMR1L, A
    
    ; Clear interrupt flag
    bcf     TMR1IF      ; Clear TMR1IF (bit 0 of PIR1)
    
    ; Increment interval counter (capped at 255)
    incf    interval_count, F, A  ; Increment counter 
    movf    interval_count, W, A    ; Copy counter to W
    movwf   PORTJ, A              ; Output counter to PORTJ
    movlw   0xFF                  ; Check if counter = 255
    cpfseq  interval_count, A     ; Skip if counter = 255
    return                        ; Return if counter < 255
    
    return                  ; Return from ISR

; INTERVAL_PROCESS_PEAK - Process a detected heartbeat peak
; Reads the current interval count (representing hundredths of seconds)
; Outputs this value to PORTC and resets the counter
; Call this function when a heartbeat peak is detected
INTERVAL_PROCESS_PEAK:
    movf    interval_count, W, A  ; Get interval count into W
    movwf   PORTC, A              ; Write interval value to PORTC
    clrf    interval_count, A     ; Reset interval counter
    return                        ; Return from subroutine
end
