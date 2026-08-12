#ifndef PWM_H
#define PWM_H

#include <stdint.h>

#ifndef F_CPU
#define F_CPU 16000000UL
#endif

/**
 * @brief Initialize the Timer 1 peripheral in phase correct mode
 * Configure Pin 11 (OC1A) and Pin 12 (OC1B) as outputs
 * TODO: Rewrite code to have any pin used for switching purpose for the Type-D chopper
 */
void PWM_Init(void); 
/**
 * @brief Set the duty cycle for the alpha test, for the 1st and 4th quadrants
 * @param duty_percent is the duty cycle in percentage, if 30% pins will be HIGH for 30% of the duty cycle
 */
void PWM_SetDutyCycle(uint8_t duty_percent);

#endif