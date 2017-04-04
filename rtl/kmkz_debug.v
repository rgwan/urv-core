/*

 Kamikaze-uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 CERN
 Author: Tomasz Włostowski <tomasz.wlostowski@cern.ch>
 
 Copyright (c) 2017 Anlogic Technology
 Author: Zhiyuan Wan <h@iloli.bid>

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 3.0 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this library.
 
 
 
*/

`timescale 1ns/1ps

`include "kmkz_defs.v"

module urv_debug
	(
		input clk_i,
		input rst_i,
		
		output halt_req_o, /* 停机请求 */
		
		/* 到寄存器文件 */
		output [4:0]	rf_addr_o,
		output 		rf_write_o,
		input [31:0]	rf_rd_o,
		output [31:0]	rf_wd_o,
		
		/* 到CSR */
		output [11:0]	csr_addr_o,
		output		csr_write_o,
		output [31:0]	csr_
		
		/* AHB slave */
		/* 地址 0x8000_0000 */
		input [31:0]	HADDR, 
		input [2:0]	HBURST,
		input		HMASTLOCK,
		input [3:0]	HPROT,
		input [2:0]	HSIZE,
		input [1:0]	HTRANS,
		input [31:0]	HWDATA,
		input		HWRITE,
		input		HREADY,
		
		output [31:0]	HRDATA,
		output [31:0]	HREADYOUT,
		output [31:0]	HRESP
	);
	
endmodule
   
