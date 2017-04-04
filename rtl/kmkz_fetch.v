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
	output [31:0]		HADDR,
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
	
	output  	   f_valid_o,
	output		f_ir_valid_o,
	output  	f_is_compressed_o,
	output  [31:0] f_ir_o,
	output  [31:0] f_pc_o,
  
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
	
	wire prefetcher_ready;
	
	reg f_kill;
	
	assign f_valid_o = prefetcher_ready && !f_kill;
	
	wire [31:0] ir;
	
	kamikaze_fetch_fifo prefetcher
	(
	.clk_i(clk_i),
	.rst_i(rst_i),
	
	.pc_mem_o(HADDR),
	.ir_i(HRDATA),
	.memory_ready_i(HREADY),
	
	.ir_o(f_ir_o),
	.pc_o(f_pc_o),
	.ready_o(prefetcher_ready),
	.fetch_ready_i(!f_stall_i),
	.ir_comp_o(f_is_compressed_o),
	
	.branch_i(x_bra_i),
	.pc_set_i(x_pc_bra_i),
	.pc_reset_i(STARTUP_BASE)
	);
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			f_kill <= 0;
		end
		else
		begin
			if(!f_stall_i)
			begin
				f_kill <= f_kill_i;
			end
		end
	end
endmodule // kamikaze_fetch 

 
  
