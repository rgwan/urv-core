
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

  
   reg clk_i = 0;
   reg rst_i = 0;
   reg rst;
   reg [7:0]io_o;
 
  
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
   	#8000000 $stop;
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

   always @(posedge clk_i or negedge rst)
   begin
   	rst_i <= rst;
   end

   
	reg HWRITE_prev;
	reg [31:0] HADDR_prev;
	wire trap;
	always@(posedge clk_i)
	begin
		if(HWRITE_prev && HADDR_prev == 32'h1000_0000)
		begin
			io_o <= HWDATA_D[7:0];
			$write("%c", io_o);
			$fflush;
      			if(io_o == 8'hFF)
       				$finish;
       		end
       		HWRITE_prev <= HWRITE_D;
       		HADDR_prev <= HADDR_D;
		if(trap)
		begin
			$write("\nTRAPPED!\n");
			$fflush;
			$finish;
		end
	end


	wire [31:0]	HADDR_I;
	wire [2:0] 	HBURST_I;
	wire 		HMASTLOCK_I;
	wire [3:0] 	HPROT_I;
	wire [2:0] 	HSIZE_I;
	wire [1:0] 	HTRANS_I;
	wire [31:0]	HWDATA_I;
	wire 		HWRITE_I;
	
	wire [31:0] 	HRDATA_I;
	wire 		HREADY_I;
	wire 		HRESP_I;


	//assign HREADY_I = 1'b1;
	//assign HRDATA_I = hrdata;
	cmsdk_ahb_ram_beh i_ram
	(
	.HCLK(clk_i),    // Clock
	.HRESETn(rst_i), // Reset
	.HSEL(1'b1),    // Device select
	.HADDR(HADDR_I),   // Address
	.HTRANS(HTRANS_I),  // Transfer control
	.HSIZE(HSIZE_I),   // Transfer size
	.HWRITE(HWRITE_I),  // Write control
	.HWDATA(HWDATA_I),  // Write data
	.HREADY(HREADY_I),  // Transfer phase done
	.HREADYOUT(HREADY_I), // Device ready
	.HRDATA(HRDATA_I),  // Read data output
	.HRESP(HRESP_I)
	); 

	wire [31:0]	HADDR_D;
	wire [2:0] 	HBURST_D;
	wire 		HMASTLOCK_D;
	wire [3:0] 	HPROT_D;
	wire [2:0] 	HSIZE_D;
	wire [1:0] 	HTRANS_D;
	wire [31:0]	HWDATA_D;
	wire 		HWRITE_D;
	
	wire [31:0] 	HRDATA_D;
	wire 		HREADY_D;
	wire 		HRESP_D;
	
	wire		d_ram_HSEL = (HADDR_D != 32'h1000_0000);
	
	cmsdk_ahb_ram_beh d_ram
	(
	.HCLK(clk_i),    // Clock
	.HRESETn(rst_i), // Reset
	.HSEL(d_ram_HSEL),    // Device select
	.HADDR(HADDR_D),   // Address
	.HTRANS(HTRANS_D),  // Transfer control
	.HSIZE(HSIZE_D),   // Transfer size
	.HWRITE(HWRITE_D),  // Write control
	.HWDATA(HWDATA_D),  // Write data
	.HREADY(HREADY_D),  // Transfer phase done
	.HREADYOUT(HREADY_D), // Device ready
	.HRDATA(HRDATA_D),  // Read data output
	.HRESP(HRESP_D)
	); 

   urv_cpu DUT
     (
      .CLK(clk_i),
      .nRST(rst_i),

	/* AHB Lite 指令 总线 */

	.HADDR_I(HADDR_I),
	.HBURST_I(HBURST_I),
	.HMASTLOCK_I(HMASTLOCK_I),
	.HPROT_I(HPROT_I),
	.HSIZE_I(HSIZE_I),
	.HTRANS_I(HTRANS_I),
	.HWDATA_I(HWDATA_I),
	.HWRITE_I(HWRITE_I),
	
	.HRDATA_I(HRDATA_I),
	.HREADY_I(HREADY_I),
	.HRESP_I(HRESP_I),
	
	.STARTUP_BASE(32'h0),
	.TRAP(trap),
	
	/* AHB-Lite 数据总线 */
	.HADDR_D(HADDR_D),
	.HBURST_D(HBURST_D),
	.HMASTLOCK_D(HMASTLOCK_D),
	.HPROT_D(HPROT_D),
	.HSIZE_D(HSIZE_D),
	.HTRANS_D(HTRANS_D),
	.HWDATA_D(HWDATA_D),
	.HWRITE_D(HWRITE_D),
	
	.HRDATA_D(HRDATA_D),
	.HREADY_D(HREADY_D),
	.HRESP_D(HRESP_D)
      	
      );

   

endmodule
  
