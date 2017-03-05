
`timescale 1ns/1ps
module regfile_dp_m(di, waddr, we, wclk, do, raddr);
	input [31:0] di;
	input [4:0] waddr;
	input [4:0] raddr;
	input we;
	input wclk;
	output [31:0] do;
	
	reg [31:0]ram[0:31];
	
	always @(posedge wclk)
		if(we)
			ram[waddr] <= di;
	assign do = ram[raddr];
	wire [31:0]cpureg_zero = ram[0];
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
endmodule

module top;

   localparam mem_size=16384;   
   localparam mem_addr_bits = 16;
  
   reg clk_i = 0;
   reg rst_i = 0;
   reg rst;
   reg [7:0]io_o;
 
      reg [31:0]  mem[0:mem_size- 1];

   
   wire [31:0] 	  im_addr;
   reg [31:0] 	  im_data;
   reg 		  im_valid;
   

   wire [31:0] 	  dm_addr;
   wire [31:0] 	  dm_data_s;
   wire [31:0] 	  dm_data_l;
   wire [3:0] 	  dm_data_select;
   wire 	  dm_write;
   reg 		  dm_valid_l = 1;
   reg 		  dm_ready = 1;
   
   wire txd;
   reg rxd = 1;
   
   initial
   begin
   	#0  rst = 0;
   	#22.5 rst = 1;
   	#200000 $stop;
   end
   initial begin
   	#6605 rxd = 0;
   	#1600 rxd = 1;
   end

   initial begin
       	$dumpfile("urv.vcd");
   	$dumpvars(0, top);
   end
   
   always #5 clk_i = !clk_i;
   
   initial begin
   	 $readmemh("firmware.hex", mem);
   end
   
   always@(posedge clk_i)
     begin
	im_data <= mem[im_addr[mem_addr_bits-1:2] ];
	im_valid <= 1;
     end
     
   always @(posedge clk_i or negedge rst)
   begin
   	rst_i <= rst;
   end
   wire mem_sel = !io_sel;
   wire io_sel =  (dm_addr == 32'h1000_0000);
   
   reg [31:0]mem_data_l;
	
   always@(posedge clk_i)
     begin

	if(dm_write && dm_data_select[0] && mem_sel)
	  mem [dm_addr[mem_addr_bits-1:2]][7:0] <= dm_data_s[7:0];
	if(dm_write && dm_data_select[1] && mem_sel)
	  mem [dm_addr[mem_addr_bits-1:2]][15:8] <= dm_data_s[15:8];
	if(dm_write && dm_data_select[2] && mem_sel)
	  mem [dm_addr[mem_addr_bits-1:2]][23:16] <= dm_data_s[23:16];
	if(dm_write && dm_data_select[3] && mem_sel)
	  mem [dm_addr[mem_addr_bits-1:2]][31:24] <= dm_data_s[31:24];

	mem_data_l <= mem [dm_addr[mem_addr_bits-1:2]];
	
	
     end // always@ (posedge clk)

   always@(posedge clk_i)
     if(dm_write && io_sel)
     begin
       io_o <= dm_data_s[7:0];
       $write("%c", io_o);
       if(io_o == 8'hFF)
       	$finish;
     end
    
	wire [31:0] uart_data_o;
   	wire uart_sel;
   	wire dm_load;
   	
   	assign uart_sel = (dm_addr[31:16] == 16'h1001 && (dm_load || dm_write));
	
   simple_uart uart(.rst_i(rst),
   	.txd_o(txd),
   	.rxd_i(rxd),
   	.clk_i(clk_i),
   	.sel_i(uart_sel),
   	.addr_i(dm_addr[3:2]),
   	.data_i(dm_data_s),
   	.data_o(uart_data_o),
   	.we_i(dm_write));
   	
	reg uart_sel_d;
	assign dm_data_l = uart_sel_d? uart_data_o: mem_data_l;

	always @(posedge clk_i)
	begin
		uart_sel_d <= uart_sel;
	end

   urv_cpu DUT
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      // instruction mem I/F
      .im_addr_o(im_addr),
      .im_data_i(im_data),
      .im_valid_i(im_valid),

      // data mem I/F
      .dm_addr_o(dm_addr),
      .dm_data_s_o(dm_data_s),
      .dm_data_l_i(dm_data_l),
      .dm_data_select_o(dm_data_select),
      .dm_store_o(dm_write),
      .dm_load_o(dm_load),
      .dm_store_done_i(1'b1),
      .dm_load_done_i(1'b1),
      .dm_ready_i(dm_ready)
      );

   

endmodule
  
