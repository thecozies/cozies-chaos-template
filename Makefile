NRM_TARGET := mm_cozies_chaos_template.nrm

BUILD_DIR := build

MOD_TOML := mod.toml

BASH_LIKE := 0

ifdef MINGW_PREFIX
	BASH_LIKE := 1
endif

# Allow the user to specify the compiler and linker on macOS
# as Apple Clang does not support MIPS architecture
ifeq ($(OS),Windows_NT)
    CC      := clang
    LD      := ld.lld
	NRM_COPY_DEST := ~/AppData/Local/Zelda64Recompiled/mods/
	RECOMP_MOD_TOOL := RecompModTool.exe
else ifneq ($(shell uname),Darwin)
    CC      := clang
    LD      := ld.lld
	NRM_COPY_DEST := ~/.config/Zelda64Recompiled/mods/
	RECOMP_MOD_TOOL := RecompModTool
	BASH_LIKE := 1
else
    CC      ?= clang
    LD      ?= ld.lld
	NRM_COPY_DEST := ~/.config/Zelda64Recompiled/mods/
	RECOMP_MOD_TOOL := RecompModTool
	BASH_LIKE := 1
endif

ifeq ($(BASH_LIKE),1)
	COPY_CMD := cp
else
	COPY_CMD := copy /Y
endif


TARGET  := $(BUILD_DIR)/mod.elf

LDSCRIPT := mod.ld
CFLAGS   := -target mips -mips2 -mabi=32 -O2 -G0 -mno-abicalls -mno-odd-spreg -mno-check-zero-division \
			-fomit-frame-pointer -ffast-math -fno-unsafe-math-optimizations -fno-builtin-memset \
			-Wall -Wextra -Wno-incompatible-library-redeclaration -Wno-unused-parameter -Wno-unknown-pragmas -Wno-unused-variable \
			-Wno-missing-braces -Wno-unsupported-floating-point-opt -Werror=section
CPPFLAGS := -nostdinc -D_LANGUAGE_C -DMIPS -DF3DEX_GBI_2 -DF3DEX_GBI_PL -DGBI_DOWHILE -I include -I include/dummy_headers \
			-I mm-decomp/include -I mm-decomp/src -I mm-decomp/extracted/n64-us -I mm-decomp/include/libc
LDFLAGS  := -nostdlib -T $(LDSCRIPT) -Map $(BUILD_DIR)/mod.map --unresolved-symbols=ignore-all --emit-relocs -e 0 --no-nmagic

C_SRCS := $(wildcard src/*.c)
C_OBJS := $(addprefix $(BUILD_DIR)/, $(C_SRCS:.c=.o))
C_DEPS := $(addprefix $(BUILD_DIR)/, $(C_SRCS:.c=.d))

all: $(TARGET) $(NRM_TARGET)

$(TARGET): $(C_OBJS) $(LDSCRIPT) | $(BUILD_DIR)
	$(LD) $(C_OBJS) $(LDFLAGS) -o $@

$(NRM_TARGET): $(TARGET) $(MOD_TOML)
	$(RECOMP_MOD_TOOL) $(MOD_TOML) .

$(BUILD_DIR) $(BUILD_DIR)/src:
ifeq ($(BASH_LIKE),1)
	mkdir -p $@
else
	mkdir $(subst /,\,$@)
endif

$(C_OBJS): $(BUILD_DIR)/%.o : %.c | $(BUILD_DIR) $(BUILD_DIR)/src
	$(CC) $(CFLAGS) $(CPPFLAGS) $< -MMD -MF $(@:.o=.d) -c -o $@

copy: $(NRM_TARGET)
	$(COPY_CMD) $(NRM_TARGET) $(NRM_COPY_DEST)

clean:
ifeq ($(BASH_LIKE),1)
	rm -rf $(BUILD_DIR)
else
	rmdir /S /Q $(BUILD_DIR)
endif

-include $(C_DEPS)

.PHONY: clean all copy
