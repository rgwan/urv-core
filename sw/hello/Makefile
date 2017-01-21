# and don't touch the rest unless you know what you're doing.
WINDOWS ?=

CROSS_COMPILE ?= /opt/riscv32i/bin/riscv32-unknown-elf-

ifdef WINE
CC =	wine	$(CROSS_COMPILE)gcc$(WINDOWS)
LD =	wine	$(CROSS_COMPILE)ld$(WINDOWS)
OBJDUMP =wine	$(CROSS_COMPILE)objdump$(WINDOWS)
OBJCOPY =wine	$(CROSS_COMPILE)objcopy$(WINDOWS)
SIZE =	wine	$(CROSS_COMPILE)size$(WINDOWS)
else
CC =            $(CROSS_COMPILE)gcc$(WINDOWS)
LD =            $(CROSS_COMPILE)ld$(WINDOWS)
OBJDUMP =       $(CROSS_COMPILE)objdump$(WINDOWS)
OBJCOPY =       $(CROSS_COMPILE)objcopy$(WINDOWS)
SIZE =          $(CROSS_COMPILE)size$(WINDOWS)

endif

ARCH = RV32I

CFLAGS = -g  -m32  -O2  -msoft-float -march=$(ARCH)  -I. -I../common -ffunction-sections -fdata-sections 
OBJS = crt0.o main.o
LDS = ram.ld
OUTPUT=hello


$(OUTPUT): $(LDS) $(OBJS)
	${CC} -m32 -flto -Wl,--gc-sections -g  -msoft-float  -march=$(ARCH) -o $(OUTPUT).elf -nostartfiles $(OBJS)  -lm -T $(LDS) -lc
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	../genraminit $(OUTPUT).bin 16384 > $(OUTPUT).ram

	$(SIZE) $(OUTPUT).elf

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

%.o:	%.S
	${CC} -c -m32 -march=$(ARCH) $^ -o $@
