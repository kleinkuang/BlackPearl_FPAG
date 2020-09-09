// File:    i2c.c
// Author:  Lei Kuang
// Date:    2019.11.18
// @ Imperial College London

#include "i2c.h"

#define IIC_BASE_ADDRESS 0x40800000

uint8_t txBuffer[3];
uint8_t rxBuffer[3];

uint8_t DEVICE_ADDR = 0x4C;		// 0x74: Clock Generator: Si5340A
								// 0x4C: DAC: DAC7678SPW
								// 0x48: ADC: ADS7924IRTER

uint32_t Read_I2C_1_Int 	(uint8_t, uint8_t);
uint32_t Write_I2C_1_Int	(uint8_t, uint8_t, uint8_t);

// ----------------------------------------------------------------
// General I2C
// ----------------------------------------------------------------
uint32_t Get_I2C_Device()
{
    return DEVICE_ADDR;
}

void Set_I2C_Device(uint8_t addr)
{
	DEVICE_ADDR = addr;
}

uint32_t Read_I2C_1_Int(uint8_t device, uint8_t address)
{
	uint32_t cnt;
	// Write address
	txBuffer[0] = address;
	cnt = XIic_Send(IIC_BASE_ADDRESS, device, txBuffer, 1, XIIC_REPEATED_START);
	if(cnt==0)
		return 0xFFFFFFFF;
	// Read data
	cnt = XIic_Recv(IIC_BASE_ADDRESS, device, rxBuffer, 1, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : rxBuffer[0];
}

uint32_t Write_I2C_1_Int(uint8_t device, uint8_t address, uint8_t data)
{
	uint32_t cnt;
	// Write address & data
	txBuffer[0] = address;
	txBuffer[1] = data;
	cnt = XIic_Send(IIC_BASE_ADDRESS, device, txBuffer, 2, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : 0;
}

uint32_t Read_I2C_1(uint8_t address)
{
	uint32_t cnt;
	// Write address
	txBuffer[0] = address;
	cnt = XIic_Send(IIC_BASE_ADDRESS, DEVICE_ADDR, txBuffer, 1, XIIC_REPEATED_START);
	if(cnt==0)
		return 0xFFFFFFFF;
	// Read data
	cnt = XIic_Recv(IIC_BASE_ADDRESS, DEVICE_ADDR, rxBuffer, 1, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : rxBuffer[0];
}

uint32_t Read_I2C_2(uint8_t address)
{
	uint32_t cnt;
	// Write address
	txBuffer[0] = address;
	cnt = XIic_Send(IIC_BASE_ADDRESS, DEVICE_ADDR, txBuffer, 1, XIIC_REPEATED_START);
	if(cnt==0)
		return 0xFFFFFFFF;
	// Read data
	cnt = XIic_Recv(IIC_BASE_ADDRESS, DEVICE_ADDR, rxBuffer, 2, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : (((uint32_t)rxBuffer[1] << 8) | (uint32_t)rxBuffer[0]);
}

uint32_t Write_I2C_1(uint8_t address, uint8_t data)
{
	uint32_t cnt;
	// Write address & data
	txBuffer[0] = address;
	txBuffer[1] = data;
	cnt = XIic_Send(IIC_BASE_ADDRESS, DEVICE_ADDR, txBuffer, 2, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : 0;
}

uint32_t Write_I2C_2(uint8_t address, uint16_t data)
{
	uint32_t cnt;
	// Write address & data
	txBuffer[0] = address;
	txBuffer[1] = data & 0xFF;
	txBuffer[2] = data >> 8;
	cnt = XIic_Send(IIC_BASE_ADDRESS, DEVICE_ADDR, txBuffer, 3, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : 0;
}

// ----------------------------------------------------------------
// I2C for Si5340 (16-bit address with page)
// ----------------------------------------------------------------
uint8_t si_page = 0x00;

uint32_t Read_SI(uint16_t address)
{
	// Check if page changes
	uint8_t page = address >> 8;
	if(si_page != page)
	{
		si_page = page;
		Write_I2C_1_Int(0x74, 0x01, si_page);
	}
	// Read data
	return Read_I2C_1_Int(0x74, address & 0xFF);
}

uint32_t Write_SI(uint16_t address, uint8_t data)
{
	// Check if page changes
	uint8_t page = address >> 8;
	if(si_page != page)
	{
		si_page = page;
		Write_I2C_1_Int(0x74, 0x01, si_page);
	}
	// Write
	return Write_I2C_1_Int(0x74, address & 0xFF, data);
}

// ----------------------------------------------------------------
// I2C for DAC7678
// ----------------------------------------------------------------
uint32_t Write_DAC(uint8_t address, uint32_t data)
{
	uint32_t cnt;
	// Write address & data
	txBuffer[0] = address;
	txBuffer[1] = (data >> 8)  & 0xFF;
	txBuffer[2] = (data)       & 0xFF;
	cnt = XIic_Send(IIC_BASE_ADDRESS, 0x4C, txBuffer, 3, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : 0;
}

uint32_t Read_DAC(uint8_t address)
{
	uint32_t cnt;
	// Write address
	txBuffer[0] = address;
	cnt = XIic_Send(IIC_BASE_ADDRESS, 0x4C, txBuffer, 1, XIIC_REPEATED_START);
	if(cnt==0)
		return 0xFFFFFFFF;
	// Read data
	cnt = XIic_Recv(IIC_BASE_ADDRESS, 0x4C, rxBuffer, 2, XIIC_STOP);
	return cnt==0 ? 0xFFFFFFFF : (((uint32_t)rxBuffer[0] << 8) | (uint32_t)rxBuffer[1]);
}
