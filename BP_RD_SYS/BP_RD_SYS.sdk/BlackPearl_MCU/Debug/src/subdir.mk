################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/dac_adc.c \
../src/gpio.c \
../src/i2c.c \
../src/main.c \
../src/platform.c \
../src/si5340.c 

OBJS += \
./src/dac_adc.o \
./src/gpio.o \
./src/i2c.o \
./src/main.o \
./src/platform.o \
./src/si5340.o 

C_DEPS += \
./src/dac_adc.d \
./src/gpio.d \
./src/i2c.d \
./src/main.d \
./src/platform.d \
./src/si5340.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../BlackPearl_MCU_bsp/mcu_box_microblaze_0/include -mlittle-endian -mcpu=v11.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


