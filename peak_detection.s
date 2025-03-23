; peak_detection.s
; Heart Signal State negative peaks detection algorithm 
; Simplified for 1.024V threshold with 4.096V reference
; PIC18F87K22 Processor
#include <xc.inc>

; Export public functions
global  PEAK_DETECTION_INIT, DETECT_SIGNAL_STATE

; Import ADC result
extrn  adc_result
psect   udata_acs
threshold:  ds 1  ; Reserve 1 byte for the high byte of the trshold of 1.024 V
psect peak_code, class=CODE
; Peak Detection Initialization
PEAK_DETECTION_INIT:
    movlw 0x04 ; corresponds to 00000100 0000000 which is 1.024V
    movwf threshold, A ; saves value in the treshold variable
    return                  ; Return from subroutine
; Detect Signal State
; Returns: Carry flag set if signal is below threshold, clear otherwise
DETECT_SIGNAL_STATE:

    ; We only need to compare the high byte
    movf   adc_result+1, W, A   ; Get high byte of ADC result

    cpfsgt threshold, A ; Compare threshold to W register
    goto SIGNAL_ABOVE ; if w > threshold
    goto SIGNAL_BELOW ; if w < threshold

SIGNAL_BELOW:
    bsf    STATUS, 0, A     ; Set carry flag (signal below threshold)
    return                  ; Return from subroutine

SIGNAL_ABOVE:
    ; Signal is above threshold
    bcf    STATUS, 0, A     ; Clear carry flag (signal above threshold)
    return                  ; Return from subroutine
end
