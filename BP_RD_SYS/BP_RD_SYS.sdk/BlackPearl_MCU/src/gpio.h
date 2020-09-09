// File:    gpio.c
// Author:  Lei Kuang
// Date:    13th April 2020
// @ Imperial College London

#include "xparameters.h"
#include "xgpio.h"

void 		GPIO_init		();

uint8_t 	Get_GPIO		();
void 		Set_GPIO		(uint8_t);

uint8_t 	Get_GPIO_Bit	(uint8_t);
void 		Set_GPIO_Bit	(uint8_t, uint8_t);

uint8_t     Get_Delay       ();
void		Set_Delay		(uint8_t);
