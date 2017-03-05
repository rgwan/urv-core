/*
 
 uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 CERN
 Author: Tomasz Włostowski <tomasz.wlostowski@cern.ch>

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

`include "urv_defs.v"

`timescale 1ns/1ps
/*
module urv_regmem
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     en1_i,
   input [4:0] 	     a1_i,
   output [31:0] q1_o,

   input [4:0] 	     a2_i,
   input [31:0]      d2_i,
   input 	     we2_i
   );

bregmem regmem ( 
	.doa(q1_o), 
	.dia(32'h0), 
	.addra(a1_i), .cea(en1_i), .clka(clk_i), .wea(1'b0), .rsta(~rst_i), .ocea(1'b1), 
	.dob(), .dib(d2_i), .addrb(a2_i), .ceb(1'b1), .clkb(clk_i), .web(a2_i != 5'b0 && we2_i), .rstb(~rst_i), .oceb(1'b0)
	);
   
endmodule
*/

module urv_regmem
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     en1_i,
   input [4:0] 	     a1_i,
   output reg [31:0] q1_o,

   input [4:0] 	     a2_i,
   input [31:0]      d2_i,
   input 	     we2_i
   );
   
   wire [31:0]do;
   regfile_dp_m ram(	.di(d2_i),
   			.waddr(a2_i),
   			.wclk(clk_i),
   			.we(we2_i),
   			
   			.raddr(a1_i),
   			.do(do));
   			

   
   always@(posedge clk_i)
     if(en1_i)
       q1_o <= a1_i? do: 32'h0;
   
endmodule

/*module urv_regmem
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     en1_i,
   input [4:0] 	     a1_i,
   output reg [31:0] q1_o,

   input [4:0] 	     a2_i,
   input [31:0]      d2_i,
   input 	     we2_i
   );

   reg [31:0] 	     ram [0:31];
  	wire [31:0]cpureg_1 = ram[1];
	wire [31:0]cpureg_2 = ram[2];
	wire [31:0]cpureg_3 = ram[3];
	wire [31:0]cpureg_4 = ram[4];
	wire [31:0]cpureg_5 = ram[5];
	wire [31:0]cpureg_6 = ram[6];
	wire [31:0]cpureg_7 = ram[7];
	wire [31:0]cpureg_8 = ram[8];
	wire [31:0]cpureg_9 = ram[9];
	wire [31:0]cpureg_10 = ram[10];
	wire [31:0]cpureg_11 = ram[11];
	wire [31:0]cpureg_12 = ram[12];
	wire [31:0]cpureg_13 = ram[13];
	wire [31:0]cpureg_14 = ram[14];
	wire [31:0]cpureg_15 = ram[15];
	wire [31:0]cpureg_16 = ram[16];
	wire [31:0]cpureg_17 = ram[17];
	wire [31:0]cpureg_18 = ram[18];
	wire [31:0]cpureg_19 = ram[19];
	wire [31:0]cpureg_20 = ram[20];
	wire [31:0]cpureg_21 = ram[21];
	wire [31:0]cpureg_22 = ram[22];
	wire [31:0]cpureg_23 = ram[23];
	wire [31:0]cpureg_24 = ram[24];
	wire [31:0]cpureg_25 = ram[25];
	wire [31:0]cpureg_26 = ram[26];
	wire [31:0]cpureg_27 = ram[27];
	wire [31:0]cpureg_28 = ram[28];
	wire [31:0]cpureg_29 = ram[29];
	wire [31:0]cpureg_30 = ram[30];
	wire [31:0]cpureg_31 = ram[31];
   
   always@(posedge clk_i)
     if(en1_i)
       q1_o <= ram[a1_i];

   always@(posedge clk_i)
     if(we2_i)
       ram[a2_i] <= d2_i;

   // synthesis translate_off
   initial begin : ram_init
      integer i;

      for(i=0;i<32; i=i+1) begin
	 ram[i] = 0;
      end
   end
   // synthesis translate_on
   
endmodule
*/

module urv_regfile
(
 input 	       clk_i,
 input 	       rst_i,

 input 	       d_stall_i,

 input [4:0]   rf_rs1_i,
 input [4:0]   rf_rs2_i,

 input [4:0]   d_rs1_i,
 input [4:0]   d_rs2_i,

 output reg [31:0] x_rs1_value_o,
 output reg [31:0] x_rs2_value_o,

 input [4:0]   w_rd_i,
 input [31:0]  w_rd_value_i,
 input 	       w_rd_store_i,

 input 	       w_bypass_rd_write_i,
 input [31:0]  w_bypass_rd_value_i
 
 );


   wire [31:0] rs1_regfile;
   wire [31:0] rs2_regfile;
   wire        write  = (w_rd_store_i && (w_rd_i != 0));

   urv_regmem bank0 
     (
      .clk_i(clk_i),
      .rst_i (rst_i ),
      .en1_i(!d_stall_i),
      .a1_i(rf_rs1_i),
      .q1_o(rs1_regfile),

      .a2_i(w_rd_i),
      .d2_i(w_rd_value_i),
      .we2_i (write));
   
   
   urv_regmem bank1
     (
      .clk_i(clk_i),
      .rst_i (rst_i ),
      .en1_i(!d_stall_i),
      .a1_i(rf_rs2_i),
      .q1_o(rs2_regfile),

      .a2_i (w_rd_i),
      .d2_i (w_rd_value_i),
      .we2_i (write)
      );
   
   wire        rs1_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs1_i) && (w_rd_i != 0);
   wire        rs2_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs2_i) && (w_rd_i != 0);

   reg 	       rs1_bypass_w, rs2_bypass_w;
   
   always@(posedge clk_i or negedge rst_i)
     if(!rst_i)
       begin
          rs1_bypass_w <= 0;
	  rs2_bypass_w <= 0;
       end else if(!d_stall_i) begin
	  rs1_bypass_w <= write && (rf_rs1_i == w_rd_i);
	  rs2_bypass_w <= write && (rf_rs2_i == w_rd_i);
       end
   
   reg [31:0] 	  bypass_w;

   always@(posedge clk_i)
     if(write)
       bypass_w <= w_rd_value_i;

   always@*
     begin
	case ( {rs1_bypass_x, rs1_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs1_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs1_value_o <= bypass_w;
	  default:
	    x_rs1_value_o <= rs1_regfile;
	endcase // case ( {rs1_bypass_x, rs1_bypass_w } )

	case ( {rs2_bypass_x, rs2_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs2_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs2_value_o <= bypass_w;
	  default:
	    x_rs2_value_o <= rs2_regfile;	 
	endcase // case ( {rs2_bypass_x, rs2_bypass_w } )
     end // always@ *

endmodule // urv_regfile

