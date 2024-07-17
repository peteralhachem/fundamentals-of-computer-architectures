/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through EINT buttons
 * Note(s):
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2019 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"


/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) 
{
	LED_init();			/* LED Initialization                 */
	LED4and11_On();
	LED4_off();
	ledEvenOn_OddOff();
	LED_On(0);
	LED_Off(0);
	OddLEDOn_EvenLEDOff();
	while (1);			/* Loop forever                       */	
}
