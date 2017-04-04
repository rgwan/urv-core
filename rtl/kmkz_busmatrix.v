/* 

	Kamikaze-uRV: a tiny RISC-V RV32IMC core
	
	Copyright (c) 2017 Anlogic Technology
	Author: Zhiyuan Wan <h@iloli.bid>
	
	This file realizes a bus matrix which provides following port:
	
	uRV Instruction Port (S, simple bus),
	uRV Data Port (S, simple bus),
	
	uRV Debug and private peripheral port (M, simplebus),
	uRV Debugger entry port(S, simplebus)
	
	Kamikaze I-Port (M, AHB-Lite),
	Kamikaze D-Port (M, AHB-Lite),
*/
