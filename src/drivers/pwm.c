#include "pwm.h"

#include <avr/io.h>

#define PWM_TOP 1000U //the milliseconds for 1 duty cycle

void PWM_Init(void) {

    /* Set Pin 11 (PB5 / OC1A) and Pin 12 (PB6 / OC1B) as outputs*/
    DDRB |= (1 << DDB5) | (1 << DDB6); 
 
    /**
     * Configure Timer 1 for Phase Correct PWM with ICR1 as TOP
     * TCCR1A:
     *  COM1A1:0 = 10 -> Non-inverting PWM on OC1A (Pin 11)
     *  COM1B1:0 = 10 -> Non-inverting on OC1B (Pin 12)
     *  WGM11:0  = 00
     */
    TCCR1A = (1 << COM1A1) | (1 << COM1B1);

    /**
     * TCCR1B:
     *  WGM13:2  = 10 -> Mode 8 (PWM, Phase Correct, TOP = ICR1)
     *  CS12:0   = 010 -> Prescaler = 8
     */
    TCCR1B = (1 << WGM13) | (1 << CS11);

    
    ICR1 = PWM_TOP;// Set TOP count for 1 kHz frequency

    PWM_SetDutyCycle(0);
}

void PWM_SetDutyCycle(uint8_t duty_percent) {
    
    if (duty_percent > 100) {
        duty_percent = 100;
    }// Clamp duty cycle to 100% maximum

    /*Calculate duty cycle compare value based on ICR1 (TOP)*/
    uint16_t compare_value = (uint32_t)(duty_percent * PWM_TOP) / 100;

    /*Update Output Compare Registers for both channels*/
    OCR1A = compare_value;
    OCR1B = compare_value;
}