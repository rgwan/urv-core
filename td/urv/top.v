module top(rst_i, clk_i, io_out, tap, io_sel);
   input rst_i;
   input clk_i;
   output reg [7:0]io_out;

   
   wire [31:0] 	  im_addr;
   wire [31:0] 	  im_data;
   reg 		  im_valid;
   

   wire [31:0] 	  dm_addr;
   wire [31:0] 	  dm_data_s;
   wire [31:0] 	  dm_data_l;
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
     
   assign io_sel =  (dm_addr == 32'h1000_0000);

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
   
      mem_lo sysmem_lo_d(.doa(dm_data_l[7:0]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[7:0]),
    .clka(clk_i),
   .cea(!io_sel),
   .ocea(1'b1),
   .wea(dm_data_select[0] && !io_sel && dm_write),
   .rsta(!rst));
      mem_ml sysmem_ml_d(.doa(dm_data_l[15:8]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[15:8]),
    .clka(clk_i),
   .cea(!io_sel),
   .ocea(1'b1),
   .wea(dm_data_select[1] && !io_sel && dm_write),
   .rsta(!rst));
      mem_mh sysmem_mh_d(.doa(dm_data_l[23:16]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[23:16]),
    .clka(clk_i),
   .cea(!io_sel),
   .ocea(1'b1),
   .wea(dm_data_select[2] && !io_sel && dm_write),
   .rsta(!rst));
      mem_hi sysmem_hi_d(.doa(dm_data_l[31:24]),
   .addra(dm_addr[11:2]),
   .dia(dm_data_s[31:24]),
    .clka(clk_i),
   .cea(!io_sel),
   .ocea(1'b1),
   .wea(dm_data_select[3] && !io_sel && dm_write),
   .rsta(!rst));

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
  