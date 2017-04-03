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

/* FIFO，用于缓存指令 */


/*
状态
32bit
32bit

32bitL1	32bitH
32bitL	16bit

32bit
16bit 16bit
*/

module kamikaze_fetch_fifo(
	input clk_i,
	input rst_i,
	
	/* 输出地址，输入数据 */
	output reg [31:0]	pc_mem_o,
	input  [31:0]	ir_i,
	input		memory_ready_i, /* 存储器准备好信号 */
	
	/* 输出地址，输出数据 */
	output reg [31:0]	ir_o,
	output reg [31:0]	pc_o,
	input		fetch_ready_i,
	output 	reg	ready_o,
	
	/* 控制信号 */
	
	input clear_i, /* 清空FIFO */
	input [31:0]	pc_set_i /* 输入跳转地址 */
	
	);
	
	reg [2:0] fifo_data_cnt;
	
	reg [31:0] fifo_memory [3:0];
	
	wire [31:0] dbg_memory0 = fifo_memory[0];
	wire [31:0] dbg_memory1 = fifo_memory[1];
	wire [31:0] dbg_memory2 = fifo_memory[2];
	wire [31:0] dbg_memory3 = fifo_memory[3];
	
	reg [2:0] read_pointer;
	reg [1:0] write_pointer;
	wire [1:0] fifo_read_pointer = read_pointer[2:1];
	
	wire fifo_empty = (write_pointer - fifo_read_pointer) == 0;
	wire fifo_halffull = (write_pointer - fifo_read_pointer) == 2;
	wire fifo_full = (write_pointer - fifo_read_pointer) == 3;
	
	/*wire fifo_empty = fifo_remains_data == 0;
	wire fifo_full = fifo_remains_data == 3;
	wire fifo_halffull = fifo_remains_data == 2;*/

	
	reg fetch_start;
	reg [2:0] pc_add;
	
	reg [31:0] dbg_ro;
	
	reg compressed_out;
	
	reg [31:0] pc_mem;
	reg [31:0] pc_prev;
	
	//wire comb_compressed = dbg_ro[1:0] != 2'b11;
	
	always @*
	begin
		if(fifo_halffull)
			pc_mem_o <= pc_prev;
		else
			pc_mem_o <= pc_mem;
		
	end
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			pc_mem <= pc_set_i;
			fifo_memory[0] <= 0;
			fifo_memory[1] <= 0;
			fifo_memory[2] <= 0;
			fifo_memory[3] <= 0;
			write_pointer <= 0;
			compressed_out <= 0;
			ready_o <= 0;
			fetch_start <= 0;
		end
		else
		begin

			if(fetch_start == 0)
			begin
				fetch_start <= 1;
				pc_mem <= pc_mem + 16'h4;
			end
			else
			begin
				if(memory_ready_i && !fifo_halffull)
				begin
					pc_prev <= pc_mem;
					fifo_memory[write_pointer] <= ir_i;
					pc_mem <= pc_mem_o + 16'h4;
				
					write_pointer <= write_pointer + 1'b1;
				end
			end
		end
	end
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			pc_o <= pc_set_i;
			pc_add <= 0;
			
			read_pointer <= 0;
			
		end
		else
			ready_o <= 0;
			if(fetch_ready_i && !fifo_empty)
			begin /* 对齐 */	
				if(read_pointer[0] == 1'b0)
				begin
					if(fifo_memory[fifo_read_pointer][1:0] == 2'b11)
					begin
						read_pointer <= read_pointer + 2;
						compressed_out <= 0;
						dbg_ro <= fifo_memory[fifo_read_pointer];
						pc_add <= 4;
					end
					else
					begin
						read_pointer <= read_pointer + 1;
						compressed_out <= 1;
						dbg_ro <= fifo_memory[fifo_read_pointer][15:0];
						pc_add <= 2;
					end
				end
				else /* 非对齐 */
				begin
					if(fifo_memory[fifo_read_pointer][17:16] == 2'b11)
					begin
						read_pointer <= read_pointer + 2;
						compressed_out <= 0;
						dbg_ro <= {fifo_memory[fifo_read_pointer + 1][15:0], fifo_memory[fifo_read_pointer][31:16]};
						pc_add <= 4;
					end
					else
					begin
						read_pointer <= read_pointer + 1;
						compressed_out <= 1;
						dbg_ro <= fifo_memory[fifo_read_pointer][31:16];
						pc_add <= 2;
					end
											
				end
				pc_o <= pc_o + pc_add;					
				ready_o <= 1;
			end
		end
endmodule
