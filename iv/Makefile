SRCs = ../rtl/ ../rtl/kmkz_csr.v     ../rtl/kmkz_divide.v      ../rtl/kmkz_timer.v \
../rtl/kmkz_exceptions.v  ../rtl/kmkz_multiply.v  ../rtl/kmkz_writeback.v \
../rtl/kmkz_config.v  ../rtl/kmkz_decode.v  ../rtl/kmkz_exec.v        ../rtl/kmkz_regfile.v  ../rtl/kmkz_fifo.v \
../rtl/kmkz_cpu.v     ../rtl/kmkz_defs.v    ../rtl/kmkz_fetch.v       ../rtl/kmkz_shifter.v uart.v ../rtl/kmkz_compd.v ahb_ram.v
	

TOOLCHAIN_PREFIX ?= riscv32-anlogic-elf-

run: core_test
	vvp -n core_test.run
core_test:$(SRCs)  rv_top_test.v firmware.hex
	iverilog -o core_test.run rv_top_test.v $(SRCs) -I ../rtl
clean:
	rm -f core_test
	rm -f core_test.run
	rm -f firmware.elf
	rm -f *.mif
	rm -f firmware.bin firmware.hex


firmware.hex: firmware.S firmware.c firmware.lds isatest.c Makefile
	$(TOOLCHAIN_PREFIX)gcc -Os -march=rv32imc -ffreestanding -nostdlib -o firmware.elf firmware.S isatest.c\
		 --std=gnu99 -Wl,-Bstatic,-T,firmware.lds,-Map,firmware.map,--strip-debug -lgcc
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin
	$(TOOLCHAIN_PREFIX)objdump -d firmware.elf > disasm.S
	python3 makehex.py firmware.bin 1024 > firmware.hex


