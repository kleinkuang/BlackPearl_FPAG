// File:    dac_adc.h
// Author:  Lei Kuang
// Date:    13th April 2020
// @ Imperial College London

#include "i2c.h"

void DAC_Init();
void DAC_ON();
void DAC_OFF();

uint16_t 	Get_DAC_RST		(void);
uint16_t 	Get_DAC_Y		(void);
uint16_t 	Get_DAC_IV		(void);
uint16_t 	Get_DAC_OTA		(void);
uint16_t 	Get_DAC_INT		(void);

void 		Set_DAC_RST		(uint16_t);
void 		Set_DAC_Y		(uint16_t);
void 		Set_DAC_IV		(uint16_t);
void 		Set_DAC_OTA		(uint16_t);
void 		Set_DAC_INT		(uint16_t);

uint16_t 	DAC_Vol_to_Val	(uint16_t);
uint16_t 	DAC_Val_to_Vol	(uint16_t);
