
`timescale 1ns/1ps

module top;

   localparam mem_size=16384;   
   localparam mem_addr_bits = 16;
  
   reg clk_i = 0;
   reg rst_i = 0;
   reg [7:0]io_o;
 
      reg [31:0]  mem[0:mem_size- 1];

   
   wire [31:0] 	  im_addr;
   reg [31:0] 	  im_data;
   reg 		  im_valid;
   

   wire [31:0] 	  dm_addr;
   wire [31:0] 	  dm_data_s;
   reg [31:0] 	  dm_data_l;
   wire [3:0] 	  dm_data_select;
   wire 	  dm_write;
   reg 		  dm_valid_l = 1;
   reg 		  dm_ready = 1;
   initial
   begin
   	#0  rst_i = 1;
   	#22.5 rst_i = 0;
   	#200000 $stop;
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

   wire mem_sel = !io_sel;
   wire io_sel =  (dm_addr == 32'h1000_0000);
   
	
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

	dm_data_l <= mem [dm_addr[mem_addr_bits-1:2]];
	
	
     end // always@ (posedge clk)

   always@(posedge clk_i)
     if(dm_write && io_sel)
     begin
       io_o <= dm_data_s[7:0];
       $write("%c", io_o);
       if(io_o == 8'hFF)
       	$finish;
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
      .dm_load_o(),
      .dm_store_done_i(1'b1),
      .dm_load_done_i(1'b1),
      .dm_ready_i(dm_ready)
      );

   

endmodule
  
