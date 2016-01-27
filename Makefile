#
# Simple template of Makefile for AVRs by Malcom
#
# Used in AVR project template for Visual Studio IDE
# http://github.com/malcom/AVR-Project
#
# Copyright (C) 2016 Marcin 'Malcom' Malich <me@malcom.pl>
#
# Released under the MIT License.
#

TARGET	= $safeprojectname$
EEPROM	= eeprom

MCU		= atmega8
CLK		= 16000000

C_SRC	=
CXX_SRC	= main.cpp
ASM_SRC	=

DEFS	=
LIBS	=

INC_PATH	=
LIB_PATH	=

OBJ_DIR		= obj
OUT_DIR		= out

DUDE_PROG	= usbasp
DUDE_PORT	= usb


C_FLAGS		= \
	-std=c11 \
	-Os \
	-Wstrict-prototypes

CXX_FLAGS	= \
	-std=c++14 \
	-Os \
	-fno-rtti \
	-fno-exceptions

ASM_FLAGS	=
LD_FLAGS	=

DUDE_FLAGS	= \
	-U flash:w:$(OUT_DIR)/$(TARGET).hex \
	-U eeprom:w:$(OUT_DIR)/$(EEPROM).hex



CC		= avr-gcc
CXX		= avr-g++
ASM		= avr-gcc -x assembler-with-cpp
LD		= avr-gcc
OBJCOPY	= avr-objcopy
OBJDUMP	= avr-objdump
OBJSIZE	= avr-size
DUDE	= avrdude

$(shell mkdir -p $(OBJ_DIR))
$(shell mkdir -p $(OUT_DIR))

OBJ = $(C_SRC:%.c=$(OBJ_DIR)/%.o) $(CXX_SRC:%.cpp=$(OBJ_DIR)/%.o) $(ASM_SRC:%.S=$(OBJ_DIR)/%.o) 

STD_OPT = -Wall -Wpedantic -Wundef -funsigned-char -funsigned-bitfields -fshort-enums -fpack-struct

DEFS_OPT = $(patsubst %,-D%,$(DEFS))
LIBS_OPT = $(patsubst %,-l%,$(LIBS))

INC_PATH_OPT = $(patsubst %,-I%,$(INC_PATH))
LIB_PATH_OPT = $(patsubst %,-L%,$(LIB_PATH))

CFLAGS		= -mmcu=$(MCU) -DF_CPU=$(CLK)UL $(DEFS_OPT) -I. $(INC_PATH_OPT) $(STD_OPT) $(C_FLAGS)   -c
CXXFLAGS	= -mmcu=$(MCU) -DF_CPU=$(CLK)UL $(DEFS_OPT) -I. $(INC_PATH_OPT) $(STD_OPT) $(CXX_FLAGS) -c
ASMFLAGS	= -mmcu=$(MCU) -DF_CPU=$(CLK)   $(DEFS_OPT) -I. $(INC_PATH_OPT) $(ASM_FLAGS)
LDFLAGS		= -mmcu=$(MCU) $(LIB_PATH_OPT) $(LIBS_OPT) $(LD_FLAGS)
DUDEFLAGS	= -p $(MCU) -c $(DUDE_PROG) -P $(DUDE_PORT) $(DUDE_FLAGS)

OBJ_TARGET_FLAGS = -R .eeprom -R .fuse -R .lock -R .signature
OBJ_EEPROM_FLAGS = -j .eeprom --set-section-flags=.eeprom="alloc,load" --change-section-lma .eeprom=0



all: elf hex bin size 

elf: $(TARGET).elf
hex: $(OUT_DIR)/$(TARGET).hex $(OUT_DIR)/$(EEPROM).hex
bin: $(OUT_DIR)/$(TARGET).bin $(OUT_DIR)/$(EEPROM).bin

target: $(OUT_DIR)/$(TARGET).hex $(OUT_DIR)/$(TARGET).bin
eeprom: $(OUT_DIR)/$(EEPROM).hex $(OUT_DIR)/$(EEPROM).bin

size: $(TARGET).elf
	$(OBJSIZE) --mcu=$(MCU) --format=avr $(TARGET).elf

program: all install

$(OUT_DIR)/$(TARGET).hex: $(TARGET).elf
	@echo Creating: $@
	$(OBJCOPY) $(OBJ_TARGET_FLAGS) -O ihex $< $@

$(OUT_DIR)/$(TARGET).bin: $(TARGET).elf
	@echo Creating: $@
	$(OBJCOPY) $(OBJ_TARGET_FLAGS) -O binary $< $@


$(OUT_DIR)/$(EEPROM).hex: $(TARGET).elf
	@echo Creating: $@
	$(OBJCOPY) $(OBJ_EEPROM_FLAGS) -O ihex $< $@

$(OUT_DIR)/$(EEPROM).bin: $(TARGET).elf
	@echo Creating: $@
	$(OBJCOPY) $(OBJ_EEPROM_FLAGS) -O binary $< $@


$(TARGET).elf: $(OBJ)
	@echo Linking: $@
	$(LD) $(LDFLAGS) $^ -o $@


$(OBJ_DIR)/%.o : %.c
	@echo Compiling C: $<
	$(CC) -c $(CFLAGS) $< -o $@ 

$(OBJ_DIR)/%.o : %.cpp
	@echo Compiling C++: $<
	$(CXX) -c $(CXXFLAGS) $< -o $@ 

$(OBJ_DIR)/%.o : %.S
	@echo Assembling: $<
	$(ASM) -c $(ASMFLAGS) $< -o $@


%.s : %.c
	@echo Generate assembly: $<
	$(CC) -S $(CFLAGS) $< -o $@

%.s : %.cpp
	@echo Generate assembly: $<
	$(CXX) -S $(CXXFLAGS) $< -o $@


install:
	@echo Programming:
	$(DUDE) $(DUDEFLAGS)


clean:
	@echo
	@echo Cleaning:
	rm -f $(OUT_DIR)/$(TARGET).elf
	rm -f $(OUT_DIR)/$(TARGET).hex
	rm -f $(OUT_DIR)/$(TARGET).bin
	rm -f $(OUT_DIR)/$(EEPROM).hex
	rm -f $(OUT_DIR)/$(EEPROM).bin
	rm -f $(C_SRC:%.c=$(OBJ_DIR)/%.o)
	rm -f $(CXX_SRC:%.cpp=$(OBJ_DIR)/%.o)
	rm -f $(ASM_SRC:%.S=$(OBJ_DIR)/%.o)
	rm -f $(C_SRC:%.c=%.s)
	rm -f $(CXX_SRC:%.cpp=%.s)


.PHONY: program install clean
