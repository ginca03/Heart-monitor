; interval_measurement.inc
; Time Interval Measurement between Peaks
; PIC18F87K22 Processor

#ifndef INTERVAL_MEASUREMENT_INC
#define INTERVAL_MEASUREMENT_INC

    UDATA
last_peak_time RES 2       ; Store last peak time (16-bit)
current_time   RES 2       ; Current timer value (16-bit)
interval_time  RES 2       ; Time between peaks (16-bit)
peak_count     RES 1       ; Number of peaks detected

; Interval Measurement Initialization
INTERVAL_INIT:
    ; Configure Timer0 for interval measurement
    MOVLW b'10000111'      ; 16-bit, internal clock, 1:256 prescaler
    MOVWF T0CON
    
    ; Enable Timer0 Interrupt
    BSF INTCON, TMR0IE
    
    ; Clear time-related variables
    CLRF last_peak_time
    CLRF last_peak_time+1
    CLRF current_time
    CLRF current_time+1
    CLRF interval_time
    CLRF interval_time+1
    RETURN

; Measure Interval Between Peaks
MEASURE_INTERVAL:
    ; Read current timer value
    MOVFF TMR0H, current_time+1
    MOVFF TMR0L, current_time

    ; Calculate interval from last peak
    SUBFWB last_peak_time+1, W
    MOVWF interval_time+1
    MOVF last_peak_time, W
    SUBFWB current_time, W
    MOVWF interval_time

    ; Update last peak time
    MOVFF current_time, last_peak_time
    MOVFF current_time+1, last_peak_time+1

    ; Optional: Convert interval to seconds 
    ; (Depends on timer configuration and clock speed)
    CALL CONVERT_TO_SECONDS

    RETURN

; Convert Timer Ticks to Seconds
CONVERT_TO_SECONDS:
    ; Implement conversion based on your timer configuration
    ; This is a placeholder - actual implementation depends on your specific setup
    RETURN

; Timer Interrupt Service Routine
INTERVAL_ISR:
    ; Handle Timer Overflow if needed
    BCF INTCON, TMR0IF     ; Clear interrupt flag
    RETURN

#endif


