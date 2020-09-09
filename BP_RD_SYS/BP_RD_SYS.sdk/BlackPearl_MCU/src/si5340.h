// File:    si5340.h
// Author:  Lei Kuang
// Date:    2019.11.18
// @ Imperial College London

#include "i2c.h"

void     Set_Freq_Index(uint8_t index);
uint8_t  Get_Freq_Index();

uint32_t Si5340_1MHz_Init();
uint32_t Si5340_10MHz_Init();
uint32_t Si5340_50MHz_Init();
uint32_t Si5340_100MHz_Init();
uint32_t Si5340_200MHz_Init();
uint32_t Si5340_250MHz_Init();
