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
	output reg [31:0]	HADDR,
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
	reg [31:0] prev_ir; /* 以前的指令 */
	wire [31:0] expand_ir;
	reg [31:0] instr_t;
	
	reg [31:0] instr_t_p;
		
	reg [31:0] pc_4, pc, pc_4_prev;
	reg [2:0] pc_add, pc_add_prev;
	
	wire stall_fetching;
	reg align_wait;
	reg is_compressed_instr;
	reg fetch_start;
	
	reg f_branch;
	
	assign stall_fetching = (pc_add_prev == 2) && (pc[1:0] == 2'b00); /* 16位对齐等待，防止冲数据 */
	
	
	
	always @*
	begin
		if(x_bra_i)
		begin
			HADDR <= {x_pc_bra_i[31:2], 2'b00};
		end
		else if(f_stall_i)
		begin
			HADDR <= {pc_4_prev[31:2], 2'b00};
		end
		else
		begin
			HADDR <= {pc_4[31:2], 2'b00};
		end
		
	end
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			pc_4 <= {STARTUP_BASE[31:2], 2'b00};
			pc <= {STARTUP_BASE[31:2], 2'b00};
			fetch_start = 1'b0;
			pc_add_prev <= 4;
			prev_ir <= 32'h0;
			f_valid_o <= 0;
			f_is_compressed_o <= 0;
			align_wait <= 0;
			f_branch <= 0;
		end
		else
		begin
			if(!f_stall_i)
			begin	
				if(fetch_start == 1'b0)
				begin
					fetch_start <= 1'b1; /* 取 0 指令 */
					pc_4 <= pc + 16'h4;
					
				end
				else
				begin
				
					if(align_wait)
						align_wait <= 0;
					
					f_branch <= x_bra_i;
					if(HREADY)
					begin
						if(x_bra_i)
						begin
							pc_4 <= {x_pc_bra_i[31:2], 2'b00} + 16'h4;
							pc <= x_pc_bra_i;
							
							if(x_pc_bra_i[1:0] == 2'b10)
								align_wait <= 1;

						end
						else
						begin
							if(pc[1:0] == 2'b00 || pc_add == 16'h4 || f_branch)
							begin /* 当pc增4或对齐的时候请求读取 */
								pc_4 <= pc_4 + 16'h4;
							end
							if(!align_wait)
							begin
								pc <= pc + pc_add;
							end
						end
						
						
					end
					
					f_valid_o <= !f_kill_i & !illegal_instr_c && !align_wait && HREADY;
				
					if(!stall_fetching || f_branch)
						prev_ir <= HRDATA;
					
					pc_add_prev <= pc_add;
					
					f_pc_o <= pc;
					f_ir_o <= expand_ir;
					
					instr_t_p <= instr_t;
					
					f_is_compressed_o <= is_compressed_instr;
					
					pc_4_prev <= pc_4;
					
				end
			end
		end
	end
	
	always @*
	begin	
		instr_t = 32'bx;	
		if(pc[1:0] == 2'b00)
		begin
			if(stall_fetching && f_branch == 0)
			begin
				if(prev_ir[1:0] != 2'b11) /* 对齐的压缩指令 */
				begin
					is_compressed_instr <= 1;
					instr_t = prev_ir[15:0];
				end
				else
				begin
					is_compressed_instr <= 0;
					instr_t = prev_ir[31:0];
				end
			end
			else
			begin
				if(HRDATA[1:0] != 2'b11) /* 对齐的压缩指令 */
				begin
					is_compressed_instr <= 1;
					instr_t = HRDATA[15:0];
				end
				else
				begin
					is_compressed_instr <= 0;
					instr_t = HRDATA[31:0];
				end
			end
		end
		else
		begin //pc[1:0] == 10
			begin
				if(prev_ir[17:16] != 2'b11) /* 不对齐的压缩指令 */
				begin
					is_compressed_instr <= 1;
					instr_t = prev_ir[31:16];
				end
				else			/* 不对齐的非压缩指令 */
				begin
					is_compressed_instr <= 0;
					instr_t = {HRDATA[15:0], prev_ir[31:16]};
				end
			end
		end
		
		if(!rst_i)	
			pc_add <= 4;
		else
			pc_add = is_compressed_instr? 2: 4;
	end
	
	kamikaze_compress_decoder c_dec(.instr_i(instr_t), .instr_o(expand_ir), .illegal_instr_o(illegal_instr_c));


endmodule // kamikaze_fetch 

 
  
