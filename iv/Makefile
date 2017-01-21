SRCs = ../rtl/ ../rtl/urv_csr.v     ../rtl/urv_divide.v      ../rtl/urv_iram.v    ../rtl/urv_timer.v \
../rtl/urv_exceptions.v  ../rtl/urv_multiply.v  ../rtl/urv_writeback.v \
../rtl/urv_config.v  ../rtl/urv_decode.v  ../rtl/urv_exec.v        ../rtl/urv_regfile.v  \
../rtl/urv_cpu.v     ../rtl/urv_defs.v    ../rtl/urv_fetch.v       ../rtl/urv_shifter.v

run: core_test
	vvp -n core_test.run
core_test:$(SRCs)  rv_top_test.v hello.ram
	iverilog -o core_test.run rv_top_test.v $(SRCs) -I ../rtl
clean:
	rm -f core_test
