; adc_routines.inc
; Analog-to-Digital Conversion Routines
; PIC18F87K22 Processor

#ifndef ADC_ROUTINES_INC
#define ADC_ROUTINES_INC

    UDATA
adc_result     RES 2       ; 16-bit ADC result storage

; ADC Initialization
ADC_INIT:
    ; Configure ADC
    MOVLW b'00000001'      ; Right justified, Fosc/2
    MOVWF ADCON2
    
    MOVLW b'00000001'      ; Select AN0 channel
    MOVWF ADCON0
    
    MOVLW b'00001110'      ; Configure voltage references
    MOVWF ADCON1
    
    ; Enable ADC
    BSF ADCON0, ADON
    RETURN

; Read ADC Value
ADC_READ:
    ; Start Conversion
    BSF ADCON0, GO

    ; Wait for Conversion
WAIT_ADC:
    BTFSC ADCON0, GO
    GOTO WAIT_ADC

    ; Store Result
    MOVFF ADRESH, adc_result+1
    MOVFF ADRESL, adc_result

    RETURN

; ADC Interrupt Service Routine
ADC_ISR:
    ; Check and handle ADC-specific interrupts if needed
    RETURN

#endif


