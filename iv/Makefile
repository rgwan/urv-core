SRCs = ../rtl/ ../rtl/urv_csr.v     ../rtl/urv_divide.v      ../rtl/urv_iram.v    ../rtl/urv_timer.v \
../rtl/urv_exceptions.v  ../rtl/urv_multiply.v  ../rtl/urv_writeback.v \
../rtl/urv_config.v  ../rtl/urv_decode.v  ../rtl/urv_exec.v        ../rtl/urv_regfile.v  \
../rtl/urv_cpu.v     ../rtl/urv_defs.v    ../rtl/urv_fetch.v       ../rtl/urv_shifter.v
	

TOOLCHAIN_PREFIX = /opt/riscv32i/bin/riscv32-unknown-elf-

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


firmware.hex: firmware.S firmware.c firmware.lds
	$(TOOLCHAIN_PREFIX)gcc -Os -m32 -march=RV32I -ffreestanding -nostdlib -o firmware.elf firmware.S \
		 --std=gnu99 -Wl,-Bstatic,-T,firmware.lds,-Map,firmware.map,--strip-debug -lgcc
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin
	$(TOOLCHAIN_PREFIX)objdump -d firmware.elf > disasm.S
	python3 makehex.py firmware.bin 1024 > firmware.hex


