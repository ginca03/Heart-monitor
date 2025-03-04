	#include <xc.inc>
; main.asm
; Main program control for Heartbeat Interval Measurement
; PIC18F87K22 Processor

#include <p18f87k22.inc>
#include "config.inc"
#include "adc_routines.inc"
#include "peak_detection.inc"
#include "interval_measurement.inc"

; Global Variables
    UDATA
peak_count     RES 1       ; Counter for peaks

; Reset Vector
    ORG 0x0000
    GOTO MAIN

; Interrupt Vector
    ORG 0x0018
    GOTO INTERRUPT_HANDLER

; Main Program
MAIN:
    ; Initialize Subsystems
    CALL ADC_INIT
    CALL INTERVAL_INIT
    CALL PEAK_DETECTION_INIT

    ; Global Interrupt Enable
    BSF INTCON, GIE

; Main Measurement Loop
MEASURE_LOOP:
    ; Read Analog Input
    CALL ADC_READ

    ; Check for Peak
    CALL DETECT_PEAK
    BNC MEASURE_LOOP       ; No peak detected, continue loop

    ; Peak Detected - Measure Interval
    CALL MEASURE_INTERVAL

    ; Optional: Process or Log Peak Data
    INCF peak_count, F

    GOTO MEASURE_LOOP

; Interrupt Handler
INTERRUPT_HANDLER:
    ; Dispatch to appropriate interrupt service routines
    CALL ADC_ISR
    CALL INTERVAL_ISR

    RETFIE
    
    END