#include "LPC17xx.h"
#include "led/led.h"

/* Exercise 01 */

void LED4and11_On(void){
	LPC_GPIO2->FIOSET |= 0x00000081;
}

/* Exercise 02 */

void LED4_off(void)
{
	LPC_GPIO2->FIOCLR |= 0x00000080;
}

/* Exercise 03 */

void ledEvenOn_OddOff(void){
	LPC_GPIO2->FIOCLR |= 0x00000001;
	LPC_GPIO2->FIOPIN |= 0x000000AA;
}



/* Exercise 04 */ 

	void LED_On(unsigned int num)
{
	LPC_GPIO2->FIOCLR |= 0x000000AA;
	switch (num) 
		{
		case 0:
				LPC_GPIO2->FIOPIN |= 0x00000080;
				break;
		case 1:
				LPC_GPIO2->FIOPIN |= 0x00000040;
				break;
		case 2:
				LPC_GPIO2->FIOPIN |= 0x00000020;
				break;
		case 3:
				LPC_GPIO2->FIOPIN |= 0x00000010;
				break;
		case 4:
				LPC_GPIO2->FIOPIN |= 0x00000008;
				break;
		case 5:
				LPC_GPIO2->FIOPIN |= 0x00000004;
				break;
		case 6:
				LPC_GPIO2->FIOPIN |= 0x00000002;
				break;
		case 7:
				LPC_GPIO2->FIOPIN |= 0x00000001;
				break;
	}

}

/* Exercise 05 */

void LED_Off(unsigned int num)
{
	switch (num) 
		{
		case 0:
				LPC_GPIO2->FIOCLR |= 0x00000080;
				break;
		case 1:
				LPC_GPIO2->FIOCLR |= 0x00000040;
				break;
		case 2:
				LPC_GPIO2->FIOCLR |= 0x00000020;
				break;
		case 3:
				LPC_GPIO2->FIOCLR |= 0x00000010;
				break;
		case 4:
				LPC_GPIO2->FIOCLR |= 0x00000008;
				break;
		case 5:
				LPC_GPIO2->FIOCLR |= 0x00000004;
				break;
		case 6:
				LPC_GPIO2->FIOCLR |= 0x00000002;
				break;
		case 7:
				LPC_GPIO2->FIOCLR |= 0x00000001;
				break;
	}
}




