# Microcontroller / Target Configuration
MCU          = atmega2560
F_CPU        = 16000000UL
TARGET       = firmware

# Programmer / Flashing Configuration
PROGRAMMER   = wiring
PORT         = COM9
BAUD         = 115200

# Compiler Tools
CC           = avr-gcc
OBJCOPY      = avr-objcopy
OBJDUMP      = avr-objdump
SIZE         = avr-size
AVRDUDE      = avrdude

# Directories
SRC_DIR      = src
BUILD_DIR    = build

# Source Files and Includes
SRCS         = src/main.c src/drivers/pwm.c
OBJS         = $(BUILD_DIR)/main.o $(BUILD_DIR)/drivers/pwm.o
INC_FLAGS    = -Isrc -Isrc/drivers

# Compiler Flags
CFLAGS       = -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INC_FLAGS) -Os -Wall -Wextra -std=gnu99
LDFLAGS      = -mmcu=$(MCU)

# OS-specific directory creation and clean commands
ifeq ($(OS),Windows_NT)
    MKDIR_P  = if not exist "$(subst /,\,$1)" mkdir "$(subst /,\,$1)"
    RM       = rmdir /s /q
else
    MKDIR_P  = mkdir -p $1
    RM       = rm -rf
endif

# Default Rule
all: $(BUILD_DIR)/$(TARGET).hex

# Link Objects into ELF File
$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	@echo --- Memory Usage ---
	$(SIZE) --format=avr --mcu=$(MCU) $@

# Convert ELF to HEX File
$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Compile main.c
$(BUILD_DIR)/main.o: src/main.c
	$(call MKDIR_P,$(BUILD_DIR))
	$(CC) $(CFLAGS) -c $< -o $@

# Compile pwm.c
$(BUILD_DIR)/drivers/pwm.o: src/drivers/pwm.c
	$(call MKDIR_P,$(BUILD_DIR)/drivers)
	$(CC) $(CFLAGS) -c $< -o $@

# Target: Upload/Flash to ATmega2560
flash: $(BUILD_DIR)/$(TARGET).hex
	$(AVRDUDE) -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -D -U flash:w:$<:i

# Clean Build Output
clean:
	$(RM) $(BUILD_DIR)

.PHONY: all flash clean