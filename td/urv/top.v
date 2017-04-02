module top(rst_i, clk_i, io_out, tap, io_sel, txd, rxd, uart_sel);
   input rst_i;
   input clk_i;
   output reg [7:0]io_out;

   
   wire [31:0] 	  im_addr;
   wire [31:0] 	  im_data;
   reg 		  im_valid;
   input rxd;
   output txd;
   wire [31:0] 	  dm_addr;
   wire [31:0] 	  dm_data_s;
   wire [31:0] 	  dm_data_l;
   output uart_sel;
   wire [3:0] 	  dm_data_select; 
   reg [4:0] counter;
   output tap;
   assign tap = counter[4];
   reg [1:0] rstcounter = 0;
	wire 	  dm_write;
	output io_sel; 
   reg 		  dm_valid_l = 1;
   reg 		  dm_ready = 1;
   
   wire rst = rst_i && rstcounter[1]; 
   
   always @(posedge clk_i)
   begin
		if(!rstcounter[1])
			rstcounter <= rstcounter + 1;
   end
   always@(posedge clk_i or negedge rst)
     begin
     	if(!rst)
     	begin
			counter <= 0;
			im_valid <= 0;
     	end
     	else
     	begin
			im_valid <= 1;	     	
			counter <= counter + 1'b1;
     	end

     end
     


   mem_lo sysmem_lo(.doa(im_data[7:0]),
   .addra(im_addr[11:2]),
    .clka(clk_i),
   .cea(1'b1),
   .ocea(1'b1),
   .wea(1'b0),
   .rsta(!rst));
      mem_ml sysmem_ml(.doa(im_data[15:8]),
   .addra(im_addr[11:2]),
    .clka(clk_i),
   .cea(1'b1),
   .ocea(1'b1),
   .wea(1'b0),
   .rsta(!rst));
      mem_mh sysmem_mh(.doa(im_data[23:16]),
   .addra(im_addr[11:2]),
    .clka(clk_i),
   .cea(1'b1),
   .ocea(1'b1),
   .wea(1'b0),
   .rsta(!rst));
      mem_hi sysmem_hi(.doa(im_data[31:24]),
   .addra(im_addr[11:2]),
    .clka(clk_i),
   .cea(1'b1),
   .ocea(1'b1),
   .wea(1'b0),
   .rsta(!rst));
   
    assign io_sel =  (dm_addr == 32'h1000_0000);  
    
    assign uart_sel = (dm_addr[31:16] ==16'h1001);  
    
    wire memory_sel = (dm_addr[31:16] == 16'h0000);
    
    wire [31:0] memory_do;
      mem_lo sysmem_lo_d(.doa(memory_do[7:0]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[7:0]),
    .clka(clk_i),
   .cea(memory_sel),
   .ocea(1'b1),
   .wea(dm_data_select[0] && dm_write && memory_sel),
   .rsta(!rst));
      mem_ml sysmem_ml_d(.doa(memory_do[15:8]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[15:8]),
    .clka(clk_i),
   .cea(memory_sel),
   .ocea(1'b1),
   .wea(dm_data_select[1]  && dm_write && memory_sel),
   .rsta(!rst));
      mem_mh sysmem_mh_d(.doa(memory_do[23:16]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[23:16]),
    .clka(clk_i),
   .cea(memory_sel),
   .ocea(1'b1),
   .wea(dm_data_select[2] && dm_write && memory_sel),
   .rsta(!rst));
      mem_hi sysmem_hi_d(.doa(memory_do[31:24]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[31:24]),
    .clka(clk_i),
   .cea(memory_sel),
   .ocea(1'b1),
   .wea(dm_data_select[3] && dm_write && memory_sel),
   .rsta(!rst));
   
   wire [31:0] uart_data_o;
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
	assign dm_data_l = uart_sel_d? uart_data_o: memory_do;

   always @(posedge clk_i)
   begin
	uart_sel_d <= uart_sel;
   end
   always@(posedge clk_i)
     if(dm_write && io_sel)
     begin
       io_out <= dm_data_s[7:0];
     end
   
   urv_cpu DUT
     (
      .clk_i(clk_i),
      .rst_i(rst),

      // instruction mem I/F
	.HADDR_I(im_addr),
	.HBURST_I(),
	.HMASTLOCK_I(),
	.HPROT_I(),
	.HSIZE_I(),
	.HTRANS_I(),
	.HWDATA_I(),
	.HWRITE_I(),
	
	.HRDATA_I(im_data),
	.HREADY_I(1'b1),
	.HRESP_I(1'b1),

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
  