/*

 Kamikaze-uRV - a tiny and dumb RISC-V core

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


module kamikaze_fetch_fifo(
	input clk_i,
	input rst_i,
	
	/* 输出地址，输入数据 */
	output reg [31:0]	pc_mem_o,
	input  [31:0]	ir_i,
	input		memory_ready_i, /* 存储器准备好信号 */
	
	/* 输出地址，输出数据 */
	output reg [31:0]	ir_o,
	output reg [31:0]	ir_orig_o,
	output reg [31:0]	pc_o,
	input		fetch_ready_i,
	output 	reg	ready_o,
	output	reg	ir_comp_o,
	
	
	/* 控制信号 */
	
	input branch_i, /* 清空FIFO */
	input [31:0]	pc_set_i, /* 输入跳转地址 */
	input [31:0]	pc_reset_i
	
	);
	
	reg [15:0] fifo_buffer [0:7];
	reg [2:0]	write_pointer;
	reg [2:0]	read_pointer;
	reg [2:0]	read_pointer_1;
	reg [3:0]	remains_data;
	
	wire [15:0] buf1=fifo_buffer[0];
	wire [15:0] buf2=fifo_buffer[1];
	wire [15:0] buf3=fifo_buffer[2];
	wire [15:0] buf4=fifo_buffer[3];
	wire [15:0] buf5=fifo_buffer[4];
	wire [15:0] buf6=fifo_buffer[5];
	wire [15:0] buf7=fifo_buffer[6];
	wire [15:0] buf8=fifo_buffer[7];
	
	
	reg [2:0] pc_add;
	
	reg fetch_start;
	
	wire fifo_full = remains_data == 8;// || remains_data == 7;
	wire fifo_empty = remains_data == 0 || remains_data == 1;
	
	reg compressed;
	
	reg [31:0] pc_prev;
	reg [31:0] pc_mem;
	
	wire [31:0] ir_t = {fifo_buffer[read_pointer_1], fifo_buffer[read_pointer]};
	wire [31:0] expanded_ir;
	
	wire illegal_instr;
	
	always @*
	begin
		read_pointer_1 <= read_pointer + 1;
		compressed = (fifo_buffer[read_pointer][1:0] == 2'b11)? 0: 1;
		
		pc_mem_o <= fifo_full? pc_prev: pc_mem;

	end
	
	reg align_wait;
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			fifo_buffer[0] <= 2'b00;
			fifo_buffer[1] <= 2'b00;
			fifo_buffer[2] <= 2'b00;
			fifo_buffer[3] <= 2'b00;
			fifo_buffer[4] <= 2'b00;
			fifo_buffer[5] <= 2'b00;
			fifo_buffer[6] <= 2'b00;
			fifo_buffer[7] <= 2'b00;
			
			write_pointer <= 0;
			read_pointer <= 0;
			fetch_start <= 0;
			
			remains_data <= 0;
			
			pc_mem <= pc_reset_i;
			pc_o <= pc_reset_i;
			pc_add <= 0;
			
			ir_o <= 2'b11;
			
			ir_comp_o <= 0;
			
			ready_o <= 0;
			
			align_wait <= pc_reset_i[1];
		end
		else if(branch_i)
		begin
			fifo_buffer[0] <= 2'b00;
			fifo_buffer[1] <= 2'b00;
			fifo_buffer[2] <= 2'b00;
			fifo_buffer[3] <= 2'b00;
			fifo_buffer[4] <= 2'b00;
			fifo_buffer[5] <= 2'b00;
			fifo_buffer[6] <= 2'b00;
			fifo_buffer[7] <= 2'b00;
			
			write_pointer <= 0;
			read_pointer <= pc_set_i[1];
			fetch_start <= 0;
			
			remains_data <= 0;
			
			pc_mem <= pc_set_i;
			pc_o <= pc_set_i;
			pc_add <= 0;
			
			ir_o <= 2'b11;
			
			ir_comp_o <= 0;
			
			ready_o <= 0;	
			align_wait <= pc_set_i[1];
		end
		else
		begin
			if(fetch_start == 0)
			begin
				fetch_start <= 1;
				pc_mem <= pc_mem + 4;
			end
			else
			begin
				if(memory_ready_i && !fifo_full)
				begin
				
					{fifo_buffer[write_pointer + 1], fifo_buffer[write_pointer]} <= ir_i;
					
					write_pointer = write_pointer + 2;
					
					pc_mem <= pc_mem + 4;
					
					pc_prev <= pc_mem;
					
				end
				if((memory_ready_i && !fifo_full) && !(fetch_ready_i && !fifo_empty))
				begin
					remains_data <= remains_data + 2 - align_wait;
					align_wait <= 0;
				end
				else if(!(memory_ready_i && !fifo_full) && (fetch_ready_i && !fifo_empty))
				begin
					remains_data <= remains_data - (compressed? 1: 2);
				end
				else if((memory_ready_i && !fifo_full) && (fetch_ready_i && !fifo_empty))
				begin
					remains_data <= remains_data + compressed;
				end
				
				if(!fifo_empty)
				begin
					ready_o <= 1;
				end
				else
				begin
					ready_o <= 0;
				end
				if(fetch_ready_i && !fifo_empty)
				begin
					if(fifo_buffer[read_pointer][1:0] == 2'b11)
					begin
						read_pointer <= read_pointer + 2;
						pc_add <= 4;
						ir_comp_o <= 0;
					end
					else
					begin
						read_pointer <= read_pointer + 1;
						pc_add <= 2;
						ir_comp_o <= 1;
					end
					
					ir_orig_o <= ir_t; /* Just for test */
					ir_o <= expanded_ir;
					pc_o <= pc_o + pc_add;
					
				end
			end
		end
		
	end
	
	kamikaze_compress_decoder decoder(
		.instr_i(ir_t),
		.instr_o(expanded_ir),
		.illegal_instr_o(illegal_instr));
	
endmodule
