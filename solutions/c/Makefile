# https://makefiletutorial.com/#makefile-cookbook

TARGET_EXE := aoc

BUILD_DIR := bin
SRC_DIRS := src

SRCS := $(shell find $(SRC_DIRS) -name '*.c')
OBJS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CC := gcc
CFLAGS := $(INC_FLAGS) -MMD -MP
DEFINES := -D INPUTS_DIR=\"$(shell pwd)/../../inputs/\"

# The final build step.
$(BUILD_DIR)/$(TARGET_EXE): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(DEFINES) -c $< -o $@

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

-include $(DEPS)
