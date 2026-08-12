
#include "pwm.h"
#include <util/delay.h>

int main(){
    PWM_Init();
    while(1){
        PWM_SetDutyCycle(25);
        
    }

    return 0;
}