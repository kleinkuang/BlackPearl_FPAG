// File:    i2c.h
// Author:  Lei Kuang
// Date:    13th April 2020
// @ Imperial College London

#include "xparameters.h"
#include "xiic_l.h"

uint32_t 	Get_I2C_Device	(void);
void 		Set_I2C_Device	(uint8_t);

uint32_t 	Read_I2C_1		(uint8_t);
uint32_t 	Read_I2C_2		(uint8_t);
uint32_t 	Write_I2C_1		(uint8_t, uint8_t);
uint32_t 	Write_I2C_2		(uint8_t, uint16_t);

uint32_t 	Read_SI			(uint16_t);
uint32_t 	Write_SI		(uint16_t, uint8_t);

uint32_t 	Write_DAC		(uint8_t, uint32_t);
uint32_t 	Read_DAC		(uint8_t);
