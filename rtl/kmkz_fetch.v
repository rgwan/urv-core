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

module kamikaze_fetch 
(
	input 		   clk_i,
	input 		   rst_i,

	input 		   f_stall_i, /* 暂停 */
	input 		   f_kill_i, /* 清除 */

					/* AHB_LITE 总线 */
	output [31:0]	HADDR,
	output [2:0] 		HBURST,
	output 			HMASTLOCK,
	output [3:0] 		HPROT,
	output [2:0] 		HSIZE,
	output [1:0] 		HTRANS,
	output [31:0]		HWDATA,
	output 			HWRITE,

	input [31:0] 		HRDATA,
	input 			HREADY,
	input 			HRESP,
	
	input [31:0] STARTUP_BASE,
	
	/* 指令输出 */
	
	output  reg	   f_valid_o,
	output		f_ir_valid_o,
	output  reg	f_is_compressed_o,
	output reg [31:0] f_ir_o,
	output reg [31:0] f_pc_o,
  
	input [31:0] 	   x_pc_bra_i,
	input 		   x_bra_i
);
	assign HWDATA = 32'b0;
	assign HWRITE = 1'b0;
	assign HBURST = 1'b0;
	assign HMASTLOCK = 1'b0;
	
	assign HTRANS = 2'b10; /* 非顺序传输 */
	assign HPROT = 4'b0000; /* 指令传输 */
	
	assign HSIZE = 3'b010; /* 32bit 访问 */
	
	wire [31:0]ir;
	
	kamikaze_fetch_fifo prefetcher
	(
	.clk_i(clk_i),
	.rst_i(rst_i),
	
	.pc_mem_o(HADDR),
	.ir_i(HRDATA),
	.memory_ready_i(HREADY),
	
	.ir_o(ir),
	.fetch_ready_i(1'b1),
	.pc_set_i(32'b0)
	);

endmodule // kamikaze_fetch 

 
  
