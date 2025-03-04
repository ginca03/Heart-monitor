; peak_detection.inc
; Peak Detection Algorithm
; PIC18F87K22 Processor

#ifndef PEAK_DETECTION_INC
#define PEAK_DETECTION_INC

    UDATA
threshold      RES 1       ; Voltage threshold for peak detection
previous_value RES 2       ; Previous ADC reading
is_rising      RES 1       ; Flag to track signal direction

; Peak Detection Initialization
PEAK_DETECTION_INIT:
    ; Set initial threshold (adjust as needed)
    MOVLW d'128'
    MOVWF threshold
    
    ; Initialize previous value and direction
    CLRF previous_value
    CLRF previous_value+1
    SETF is_rising
    RETURN

; Detect Peak in Signal
DETECT_PEAK:
    ; Compare current value with previous
    MOVF adc_result+1, W
    SUBWF previous_value+1, W
    BN CHECK_RISING_EDGE
    BZ COMPARE_LOW_BYTE

    ; Falling Edge Detection
    CLRF is_rising
    BCF STATUS, C          ; No peak, clear carry
    RETURN

COMPARE_LOW_BYTE:
    MOVF adc_result, W
    SUBWF previous_value, W
    BN CHECK_RISING_EDGE
    
    ; No significant change
    BCF STATUS, C
    RETURN

CHECK_RISING_EDGE:
    ; Check if crossing threshold
    MOVF adc_result+1, W
    SUBWF threshold, W
    BN PEAK_FOUND

    ; Update previous value
    MOVFF adc_result, previous_value
    MOVFF adc_result+1, previous_value+1
    
    BCF STATUS, C          ; No peak detected
    RETURN

PEAK_FOUND:
    ; Peak detected
    BSF STATUS, C
    RETURN

#endif


