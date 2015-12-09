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

`timescale 1ns/1ps

`include "urv_defs.v"

`ifdef URV_PLATFORM_SPARTAN6

module urv_iram
  #(
    parameter g_size = 65536,
    parameter g_init_file = "",
    parameter g_simulation = 0
    ) 
   (
    input 	  clk_i,

    input 	  ena_i,
    input 	  wea_i,
    input [31:0]  aa_i,
    input [3:0]   bwea_i,
    input [31:0]  da_i,
    output [31:0] qa_o, 
    input 	  enb_i,
    input 	  web_i,
    input [31:0]  ab_i,
    input [3:0]   bweb_i,
    input [31:0]  db_i,
    output [31:0] qb_o
    );

   genvar 	     i;

   // synthesis translate_off
   reg [31:0] 	     mem[0:g_size/4-1];
   reg [31:0] 	     qa_int, qb_int;
  
   // synthesis translate_on


		  
   
`define RAM_INST(id, entity, range_a, range_d, range_bw) \
	 entity RV_IRAM_BLK_``id \
	    ( \
	     .CLKA(clk_i), \
	     .CLKB(clk_i), \
	     .ADDRA(aa_i[range_a]), \
	     .ADDRB(ab_i[range_a]), \
	     .DOA(qa_o[range_d]), \
	     .DOB(qb_o[range_d]), \
	     .DIA(da_i[range_d]), \
	     .DIB(db_i[range_d]), \
	     .SSRA(1'b0), \
	     .SSRB(1'b0), \
	     .ENA(ena_i), \
	     .ENB(enb_i), \
	     .WEA(wea_i & bwea_i[range_bw]), \
	     .WEB(web_i & bweb_i[range_bw]) \
	    );

`define RAM_INST_MUXED(id, entity, range_a, range_d, range_bw, qa_def, qb_def, ena, enb) \
	 entity RV_IRAM_BLK_``id \
	    ( \
	     .CLKA(clk_i), \
	     .CLKB(clk_i), \
	     .ADDRA(aa_i[range_a]), \
	     .ADDRB(ab_i[range_a]), \
	     .DOA(qa_def[range_d]), \
	     .DOB(qb_def[range_d]), \
	     .DIA(da_i[range_d]), \
	     .DIB(db_i[range_d]), \
	     .SSRA(1'b0), \
	     .SSRB(1'b0), \
	     .ENA((ena) & ena_i), \
	     .ENB((enb) & enb_i), \
	     .WEA((ena) & wea_i & bwea_i[range_bw]), \
	     .WEB((enb) & web_i & bweb_i[range_bw]) \
	    );

   
   
   generate 
      if (!g_simulation) begin
	 if (g_size == 65536) begin
	    `RAM_INST(64K_0, RAMB16_S1_S1, 15:2, 0, 0)
	    `RAM_INST(64K_1, RAMB16_S1_S1, 15:2, 1, 0)
	    `RAM_INST(64K_2, RAMB16_S1_S1, 15:2, 2, 0)
	    `RAM_INST(64K_3, RAMB16_S1_S1, 15:2, 3, 0)
	    `RAM_INST(64K_4, RAMB16_S1_S1, 15:2, 4, 0)
	    `RAM_INST(64K_5, RAMB16_S1_S1, 15:2, 5, 0)
	    `RAM_INST(64K_6, RAMB16_S1_S1, 15:2, 6, 0)
	    `RAM_INST(64K_7, RAMB16_S1_S1, 15:2, 7, 0)
	    `RAM_INST(64K_8, RAMB16_S1_S1, 15:2, 8, 1)
	    `RAM_INST(64K_9, RAMB16_S1_S1, 15:2, 9, 1)
	    `RAM_INST(64K_10, RAMB16_S1_S1, 15:2, 10, 1)
	    `RAM_INST(64K_11, RAMB16_S1_S1, 15:2, 11, 1)
	    `RAM_INST(64K_12, RAMB16_S1_S1, 15:2, 12, 1)
	    `RAM_INST(64K_13, RAMB16_S1_S1, 15:2, 13, 1)
	    `RAM_INST(64K_14, RAMB16_S1_S1, 15:2, 14, 1)
	    `RAM_INST(64K_15, RAMB16_S1_S1, 15:2, 15, 1)
	    `RAM_INST(64K_16, RAMB16_S1_S1, 15:2, 16, 2)
	    `RAM_INST(64K_17, RAMB16_S1_S1, 15:2, 17, 2)
	    `RAM_INST(64K_18, RAMB16_S1_S1, 15:2, 18, 2)
	    `RAM_INST(64K_19, RAMB16_S1_S1, 15:2, 19, 2)
	    `RAM_INST(64K_20, RAMB16_S1_S1, 15:2, 20, 2)
	    `RAM_INST(64K_21, RAMB16_S1_S1, 15:2, 21, 2)
	    `RAM_INST(64K_22, RAMB16_S1_S1, 15:2, 22, 2)
	    `RAM_INST(64K_23, RAMB16_S1_S1, 15:2, 23, 2)
	    `RAM_INST(64K_24, RAMB16_S1_S1, 15:2, 24, 3)
	    `RAM_INST(64K_25, RAMB16_S1_S1, 15:2, 25, 3)
	    `RAM_INST(64K_26, RAMB16_S1_S1, 15:2, 26, 3)
	    `RAM_INST(64K_27, RAMB16_S1_S1, 15:2, 27, 3)
	    `RAM_INST(64K_28, RAMB16_S1_S1, 15:2, 28, 3)
	    `RAM_INST(64K_29, RAMB16_S1_S1, 15:2, 29, 3)
	    `RAM_INST(64K_30, RAMB16_S1_S1, 15:2, 30, 3)
	    `RAM_INST(64K_31, RAMB16_S1_S1, 15:2, 31, 3)
	 end // if (g_size == 65536)
	 else if(g_size == 32768) begin
	    wire[31:0] qa_h, qb_h, qa_l, qb_l;
	    reg        a14a_d, a14b_d;
	    
	    `RAM_INST_MUXED(32K_H0, RAMB16_S4_S4, 13:2, 3:0, 0, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H1, RAMB16_S4_S4, 13:2, 7:4, 0, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H2, RAMB16_S4_S4, 13:2, 11:8, 1, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H3, RAMB16_S4_S4, 13:2, 15:12, 1, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H4, RAMB16_S4_S4, 13:2, 19:16, 2, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H5, RAMB16_S4_S4, 13:2, 23:20, 2, qa_h, qb_h, aa_i[14], ab_i[14])
 	    `RAM_INST_MUXED(32K_H6, RAMB16_S4_S4, 13:2, 27:24, 3, qa_h, qb_h, aa_i[14], ab_i[14])
	    `RAM_INST_MUXED(32K_H7, RAMB16_S4_S4, 13:2, 31:28, 3, qa_h, qb_h, aa_i[14], ab_i[14])
	 
	    `RAM_INST_MUXED(32K_L0, RAMB16_S4_S4, 13:2, 3:0, 0, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L1, RAMB16_S4_S4, 13:2, 7:4, 0, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L2, RAMB16_S4_S4, 13:2, 11:8, 1, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L3, RAMB16_S4_S4, 13:2, 15:12, 1, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L4, RAMB16_S4_S4, 13:2, 19:16, 2, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L5, RAMB16_S4_S4, 13:2, 23:20, 2, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
 	    `RAM_INST_MUXED(32K_L6, RAMB16_S4_S4, 13:2, 27:24, 3, qa_l, qb_l, ~aa_i[14], ~ab_i[14])
	    `RAM_INST_MUXED(32K_L7, RAMB16_S4_S4, 13:2, 31:28, 3, qa_l, qb_l, ~aa_i[14], ~ab_i[14])

	    always@(posedge clk_i)
	      begin
		   a14a_d <= aa_i[14];
		   a14b_d <= ab_i[14];
	      end

	    assign qa_o = a14a_d ? qa_h : qa_l;
	    assign qb_o = a14b_d ? qb_h : qb_l;
	    
	 end else if(g_size == 16384) begin
	    `RAM_INST(16K_0, RAMB16_S4_S4, 13:2, 3:0, 0)
	    `RAM_INST(16K_1, RAMB16_S4_S4, 13:2, 7:4, 0)
	    `RAM_INST(16K_2, RAMB16_S4_S4, 13:2, 11:8, 1)
	    `RAM_INST(16K_3, RAMB16_S4_S4, 13:2, 15:12, 1)	
	    `RAM_INST(16K_4, RAMB16_S4_S4, 13:2, 19:16, 2)
	    `RAM_INST(16K_5, RAMB16_S4_S4, 13:2, 23:20, 2)
 	    `RAM_INST(16K_6, RAMB16_S4_S4, 13:2, 27:24, 3)
	    `RAM_INST(16K_7, RAMB16_S4_S4, 13:2, 31:28, 3)
	 end else begin
	    initial begin
	       $error("Unsupported Spartan-6 IRAM size: %d", g_size);
	       $stop;
	    end
	    
	    
	 end // else: !if(g_size == 16384)
	 
	 
	 
      end else begin // if (!g_simulation)

// synthesis translate_off
	 always@(posedge clk_i)
	   begin
 	   

	      if(ena_i)
		begin
 		   qa_int <= mem[(aa_i / 4) % g_size];

		   if(wea_i && bwea_i[0])
		     mem [(aa_i / 4) % g_size][7:0] <= da_i[7:0];
		   if(wea_i && bwea_i[1])
		     mem [(aa_i / 4) % g_size][15:8] <= da_i[15:8];
		   if(wea_i && bwea_i[2])
		     mem [(aa_i / 4) % g_size][23:16] <= da_i[23:16];
		   if(wea_i && bwea_i[3])
		     mem [(aa_i / 4) % g_size][31:24] <= da_i[31:24];

		end
	      if(enb_i)
		begin
 		   qb_int <= mem[(ab_i / 4) % g_size];

		   if(web_i && bweb_i[0])
		     mem [(ab_i / 4) % g_size][7:0] <= db_i[7:0];
		   if(web_i && bweb_i[1])
		     mem [(ab_i / 4) % g_size][15:8] <= db_i[15:8];
		   if(web_i && bweb_i[2])
		     mem [(ab_i / 4) % g_size][23:16] <= db_i[23:16];
		   if(web_i && bweb_i[3])
		     mem [(ab_i / 4) % g_size][31:24] <= db_i[31:24];

		end
	      
		     
	   end // always@ (posedge clk_i)
	 
	 assign qa_o = qa_int;
	 
	   assign qb_o = qb_int;
	 
	// synthesis translate_on

      end // else: !if(!g_simulation)


   endgenerate

   // synthesis translate_off
  


   
   
   integer 		     f, addr;
   reg[31:0] data;
   reg [8*20-1:0]	     cmd;
   
   
   
   initial begin
      if(g_simulation && g_init_file != "") begin : init_ram_contents
	 $display("Initializing RAM contents from %s", g_init_file);
	 
	 f = $fopen(g_init_file,"r");


	 
	 if( f == 0)
	   begin
	      $error("can't open: %s", g_init_file);
	      $stop;
	   end
      
	 

	 while(!$feof(f))
           begin
           
              
              $fscanf(f,"%s %08x %08x", cmd,addr,data);
              if(cmd == "write")
		begin
                   mem[addr % g_size][7:0] = data[31:24];
                   mem[addr % g_size][15:8] = data[23:16];
                   mem[addr % g_size][23:16] = data[15:8];
                   mem[addr % g_size][31:24] = data[7:0];
		end
           end
      end // if (g_simulation && g_init_file != "")
   end
   
   
   // synthesis translate_on
   

endmodule // urv_iram

`endif //  `ifdef URV_PLATFORM_SPARTAN6


`ifdef URV_PLATFORM_GENERIC
module urv_iram
  #(
    parameter g_size = 65536,
    parameter g_init_file = "",
    parameter g_simulation = 0
    ) 
   (
    input 	  clk_i,

    input 	  ena_i,
    input 	  wea_i,
    input [31:0]  aa_i,
    input [3:0]   bwea_i,
    input [31:0]  da_i,
    output [31:0] qa_o, 
    input 	  enb_i,
    input 	  web_i,
    input [31:0]  ab_i,
    input [3:0]   bweb_i,
    input [31:0]  db_i,
    output [31:0] qb_o
    );

   genvar 	     i;

   reg [31:0] 	     mem[0:g_size/4-1];
   reg [31:0] 	     qa_int, qb_int;
  

	 always@(posedge clk_i)
	   begin
 	   

	      if(ena_i)
		begin
 		   qa_int <= mem[(aa_i / 4)];

		   if(wea_i && bwea_i[0])
		     mem [(aa_i / 4)][7:0] <= da_i[7:0];
		   if(wea_i && bwea_i[1])
		     mem [(aa_i / 4)][15:8] <= da_i[15:8];
		   if(wea_i && bwea_i[2])
		     mem [(aa_i / 4)][23:16] <= da_i[23:16];
		   if(wea_i && bwea_i[3])
		     mem [(aa_i / 4)][31:24] <= da_i[31:24];

		end
	      if(enb_i)
		begin
 		   qb_int <= mem[(ab_i / 4) % g_size];

		   if(web_i && bweb_i[0])
		     mem [(ab_i / 4)][7:0] <= db_i[7:0];
		   if(web_i && bweb_i[1])
		     mem [(ab_i / 4)][15:8] <= db_i[15:8];
		   if(web_i && bweb_i[2])
		     mem [(ab_i / 4)][23:16] <= db_i[23:16];
		   if(web_i && bweb_i[3])
		     mem [(ab_i / 4)][31:24] <= db_i[31:24];

		end
	      
		     
	   end // always@ (posedge clk_i)
	 
	 assign qa_o = qa_int;
	 
	   assign qb_o = qb_int;
	 
	// synthesis translate_on

      end // else: !if(!g_simulation)
   
`endif

`ifdef URV_PLATFORM_ALTERA
module urv_iram
  #(
    parameter g_size = 65536,
    parameter g_init_file = "",
    parameter g_simulation = 0
    ) 
   (
    input 	  clk_i,

    input 	  ena_i,
    input 	  wea_i,
    input [31:0]  aa_i,
    input [3:0]   bwea_i,
    input [31:0]  da_i,
    output [31:0] qa_o, 
    input 	  enb_i,
    input 	  web_i,
    input [31:0]  ab_i,
    input [3:0]   bweb_i,
    input [31:0]  db_i,
    output [31:0] qb_o
    );

   localparam g_addr_width = (g_size==65536?14:0);
      
   	altsyncram
	  ram (
				.address_a (aa_i[g_addr_width+1:2]),
				.address_b (aa_i[g_addr_width+1:2]),
				.byteena_a (bwea_i),
				.byteena_b (bweb_i),
				.clock0 (clk_i),
				.data_a (da_i),
				.data_b (db_i),
				.wren_a (wea_i),
				.wren_b (web_i),
				.q_a (qa_o),
				.q_b (qb_o),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.eccstatus (),
				.rden_a (1'b1),
				.rden_b (1'b1));
	defparam
		ram.address_reg_b = "CLOCK0",
		ram.byteena_reg_b = "CLOCK0",
		ram.byte_size = 8,
		ram.clock_enable_input_a = "BYPASS",
		ram.clock_enable_input_b = "BYPASS",
		ram.clock_enable_output_a = "BYPASS",
		ram.clock_enable_output_b = "BYPASS",
		ram.indata_reg_b = "CLOCK0",
		ram.init_file = g_init_file,
		ram.intended_device_family = "Cyclone IV E",
		ram.lpm_type = "altsyncram",
		ram.numwords_a = 16384,
		ram.numwords_b = 16384,
		ram.operation_mode = "BIDIR_DUAL_PORT",
		ram.outdata_aclr_a = "NONE",
		ram.outdata_aclr_b = "NONE",
		ram.outdata_reg_a = "UNREGISTERED",
		ram.outdata_reg_b = "UNREGISTERED",
		ram.power_up_uninitialized = "FALSE",
		ram.ram_block_type = "M9K",
		ram.read_during_write_mode_mixed_ports = "DONT_CARE",
		ram.read_during_write_mode_port_a = "NEW_DATA_WITH_NBE_READ",
		ram.read_during_write_mode_port_b = "NEW_DATA_WITH_NBE_READ",
		ram.widthad_a = 14,
		ram.widthad_b = 14,
		ram.width_a = 32,
		ram.width_b = 32,
		ram.width_byteena_a = 4,
		ram.width_byteena_b = 4,
		ram.wrcontrol_wraddress_reg_b = "CLOCK0";




endmodule // urv_iram


`endif //  `ifdef URV_PLATFORM_ALTERA
   
