/* 

	Kamikaze-uRV: a tiny RISC-V RV32IMC core
	
	Copyright (c) 2017 Anlogic Technology
	Author: Zhiyuan Wan <h@iloli.bid>
	
	This file realizes a bus matrix which provides following port:
	
	uRV Data Port (S, AHB-Lite),
	
	uRV Debug and private peripheral port (M, AHB-Lite),
	uRV Debugger entry port(S, AHB-Lite)
	
	Kamikaze D-Port (M, AHB-Lite),
	
	可选的端口：
	uRV Instruction Port => 对内指令端口
	Kamikaze Instruction Port => 对外指令端口
*/
module kmkz_busmatrix(
	input	clk_i,
	input	rst_i,
	
	/* M1口-对外数据端口 */
 
	output reg [31:0]	HADDR_DI,
	output reg [2:0] 	HBURST_DI,
	output reg 		HMASTLOCK_DI,
	output reg [3:0]	HPROT_DI,
	output reg [2:0] 	HSIZE_DI,
	output reg [1:0] 	HTRANS_DI,
	output reg [31:0]	HWDATA_DI,
	output reg		HWRITE_DI,

	input [31:0]	HRDATA_DI,
	input		HREADY_DI,
	input		HRESP_DI,
	
	/* M2口-对Debug数据端口 */
	output reg [31:0]	HADDR_DBG,
	output reg [2:0] 	HBURST_DBG,
	output reg 		HMASTLOCK_DBG,
	output reg [3:0]	HPROT_DBG,
	output reg [2:0] 	HSIZE_DBG,
	output reg [1:0] 	HTRANS_DBG,
	output reg [31:0]	HWDATA_DBG,
	output reg		HWRITE_DBG,

	input [31:0]	HRDATA_DBG,
	input		HREADY_DBG,
	input		HRESP_DBG,
	
	/* S1口-对CPU数据端口 */
	input [31:0]	HADDR_DO,
	input [2:0] 	HBURST_DO,
	input 		HMASTLOCK_DO,
	input [3:0]	HPROT_DO,
	input [2:0] 	HSIZE_DO,
	input [1:0] 	HTRANS_DO,
	input [31:0]	HWDATA_DO,
	input		HWRITE_DO,

	output reg [31:0]	HRDATA_DO,
	output 			HREADY_DO,
	output reg		HRESP_DO,
	
	/* S2口-对调试接口端口 */
	input [31:0]	HADDR_TI,
	input [2:0] 	HBURST_TI,
	input 		HMASTLOCK_TI,
	input [3:0]	HPROT_TI,
	input [2:0] 	HSIZE_TI,
	input [1:0] 	HTRANS_TI,
	input [31:0]	HWDATA_TI,
	input		HWRITE_TI,

	output reg [31:0]	HRDATA_TI,
	output 		HREADY_TI,
	output reg	HRESP_TI); 
	/* 地址分配：0x8000 0000 ~ 0x8000_ffff -> 调试端口
		其他 -> 数据端口 */
	reg s1_req_debug;/* CPU数据端口请求Debug端口 */
	reg s1_req_dbus; 
	
	reg s2_req_debug;/* 调试器请求Debug端口 */
	reg s2_req_dbus; 
	
	always @* /* 总线地址解码器 */
	begin
		s1_req_debug <= 0;
		s1_req_dbus <= 0;
		if(HTRANS_DO != 2'b00)
		begin
			if(HADDR_DO == 32'h8000_xxxx)
				s1_req_debug <= 1;
			else
				s1_req_dbus <= 1;
		end
		
		s2_req_debug <= 0;
		s2_req_dbus <= 0;
		
		if(HTRANS_TI != 2'b00)
		begin
			if(HADDR_DO == 32'h8000_xxxx)
				s2_req_debug <= 1;
			else
				s2_req_dbus <= 1;
		end
	end
	
	reg s1_gnt_debug; /* 得到总线 */
	reg s1_gnt_dbus;
	reg s1_gnt_debug_seq;
	reg s1_gnt_dbus_seq;
	
	reg s2_gnt_debug;
	reg s2_gnt_dbus;
	reg s2_gnt_debug_seq;
	reg s2_gnt_dbus_seq;
	
	reg s1_ready;
	reg s2_ready;
	
	reg bus_hazard_req;
	reg bus_hazard;
	
	wire [31:0]	HADDR_DUMMY;
	wire [2:0] 	HBURST_DUMMY;
	wire 		HMASTLOCK_DUMMY;
	wire [3:0]	HPROT_DUMMY;
	wire [2:0] 	HSIZE_DUMMY;
	wire [1:0] 	HTRANS_DUMMY;
	wire [31:0]	HWDATA_DUMMY;
	wire		HWRITE_DUMMY;
	
	wire [31:0]	HRDATA_DUMMY;
	wire		HREADY_DUMMY;
	wire		HRESP_DUMMY;
	
	kmkz_dummymaster dummy(
	.HADDR(HADDR_DUMMY),
	.HBURST(HBURST_DUMMY),
	.HMASTLOCK(HMASTLOCK_DUMMY),
	.HPROT(HPROT_DUMMY),
	.HSIZE(HSIZE_DUMMY),
	.HTRANS(HTRANS_DUMMY),
	.HWDATA(HWDATA_DUMMY),
	.HWRITE(HWRITE_DUMMY),
	
	.HRDATA(HRDATA_DUMMY),
	.HREADY(HREADY_DUMMY),
	.HRESP	(HRESP_DUMMY)
	);	
	/* 总线 MUX */
	always @* /* 总线仲裁 */
	begin /* S1->CPU S2->TracePort */
		if(bus_hazard)
		begin
			s1_gnt_debug <= s1_gnt_debug_seq;
			s1_gnt_dbus <= s1_gnt_dbus_seq;
			
			s2_gnt_debug <= s2_gnt_debug_seq;
			s2_gnt_dbus <= s2_gnt_dbus_seq;
		end
		else
		begin
			s1_gnt_debug <= 0;
			s1_gnt_dbus <= 0;
		
			s2_gnt_debug <= 0;
			s2_gnt_dbus <= 0;
		
			bus_hazard_req <= 0;
		
			if(s2_req_debug && s1_req_dbus)
			begin /* S2访问Debug, S1访问DBus */
				s1_gnt_dbus <= 1;
				s2_gnt_debug <= 1;
			end
			else if(s1_req_debug && s2_req_dbus)
			begin /* S1访问Debug，S2访问DBus */
				s1_gnt_debug <= 1;
				s2_gnt_dbus <= 1;
			end
			else
			begin
				bus_hazard_req <= 1; /* 需要时序仲裁 */
				if(s1_req_debug && s2_req_debug) /* Debug优先级最高 */
					s2_gnt_debug <= 1;
				else if(s1_req_dbus && s2_req_dbus)
					s2_gnt_dbus <= 1;
					
			end
		end
			
	end
	
	always @(posedge clk_i or negedge rst_i)
	begin
		if(!rst_i)
		begin
			bus_hazard <= 0;
			s1_gnt_debug_seq <= 0;
			s1_gnt_dbus_seq <= 0;
			s2_gnt_debug_seq <= 0;
			s2_gnt_dbus_seq <= 0;
			
			s1_ready <= 1;
			s2_ready <= 1;
		end
		else
		begin
			if(bus_hazard_req && !bus_hazard) /* 需要时序仲裁 */
			begin
				bus_hazard <= 1;
				s1_ready <= 0; /* 阻塞S1 */
			end
		end
	end
	
	reg HREADY_TI_I, HREADY_DO_I;
	assign HREADY_TI = HREADY_TI_I && s1_ready;
	assign HREADY_DO = HREADY_DO_I && s2_ready;
	
	always @*
	begin
		/* M2 MUX，调试总线 */
		HREADY_TI_I <= 1;
		HREADY_DO_I <= 1;
		if(s2_gnt_debug) /* 若S2取得总线 */
		begin
			HADDR_DBG <= HADDR_TI;
			HBURST_DBG <= HBURST_TI;
			HMASTLOCK_DBG <= HMASTLOCK_TI;
			HPROT_DBG <= HPROT_TI;
			HSIZE_DBG <= HSIZE_TI;
			HTRANS_DBG <= HTRANS_TI;
			HWDATA_DBG <= HWDATA_TI;
			HWRITE_DBG <= HWRITE_TI;
			
			HRDATA_TI <= HRDATA_DBG;
			HREADY_TI_I <= HREADY_DBG;
			HRESP_TI <= HRESP_DBG;
		end
		else if(s1_gnt_debug) /* S1取得总线 */
		begin
			HADDR_DBG <= HADDR_DO;
			HBURST_DBG <= HBURST_DO;
			HMASTLOCK_DBG <= HMASTLOCK_DO;
			HPROT_DBG <= HPROT_DO;
			HSIZE_DBG <= HSIZE_DO;
			HTRANS_DBG <= HTRANS_DO;
			HWDATA_DBG <= HWDATA_DO;
			HWRITE_DBG <= HWRITE_DO;
			
			HRDATA_DO <= HRDATA_DBG;
			HREADY_DO_I <= HREADY_DBG;
			HRESP_DO <= HRESP_DBG;	
		end
		else /* 接dummy */
		begin
			HADDR_DBG <= HADDR_DUMMY;
			HBURST_DBG <= HBURST_DO;
			HMASTLOCK_DBG <= HMASTLOCK_DO;
			HPROT_DBG <= HPROT_DO;
			HSIZE_DBG <= HSIZE_DO;
			HTRANS_DBG <= HTRANS_DO;
			HWDATA_DBG <= HWDATA_DO;
			HWRITE_DBG <= HWRITE_DO;
		end					
		
		if(s1_gnt_dbus)
		begin 
			HADDR_DI <= HADDR_DO;
			HBURST_DI <= HBURST_DO;
			HMASTLOCK_DI <= HMASTLOCK_DO;
			HPROT_DI <= HPROT_DO;
			HSIZE_DI <= HSIZE_DO;
			HTRANS_DI <= HTRANS_DO;
			HWDATA_DI <= HWDATA_DO;
			HWRITE_DI <= HWRITE_DO;
			
			HRDATA_DO <= HRDATA_DI;
			HREADY_DO_I <= HREADY_DI;
			HRESP_DO <= HRESP_DI;
		end
		else if(s2_gnt_dbus)
		begin
			HADDR_DI <= HADDR_TI;
			HBURST_DI <= HBURST_TI;
			HMASTLOCK_DI <= HMASTLOCK_TI;
			HPROT_DI <= HPROT_TI;
			HSIZE_DI <= HSIZE_TI;
			HTRANS_DI <= HTRANS_TI;
			HWDATA_DI <= HWDATA_TI;
			HWRITE_DI <= HWRITE_TI;
			
			HRDATA_TI <= HRDATA_DI;
			HREADY_TI_I <= HREADY_DI;
			HRESP_TI <= HRESP_DI;
		end
		else
		begin
			HADDR_DI <= HADDR_DUMMY;
			HBURST_DBG <= HBURST_DUMMY;
			HMASTLOCK_DBG <= HMASTLOCK_DUMMY;
			HPROT_DBG <= HPROT_DUMMY;
			HSIZE_DBG <= HSIZE_DUMMY;
			HTRANS_DBG <= HTRANS_DUMMY;
			HWDATA_DBG <= HWDATA_DUMMY;
			HWRITE_DBG <= HWRITE_DUMMY;						
		end
		
	end
	
endmodule

module kmkz_dummymaster( /* 假主机 */
	input clk_i,
	input rst_i,
	
	output  [31:0]	HADDR,
	output  [2:0] 	HBURST,
	output 		HMASTLOCK,
	output  [3:0]	HPROT,
	output  [2:0] 	HSIZE,
	output  [1:0] 	HTRANS,
	output  [31:0]	HWDATA,
	output 		HWRITE,
	
	input [31:0]	HRDATA,
	input		HREADY,
	input		HRESP
	);
	assign HADDR = 32'h8000_0000;
	assign HBURST = 2'h0;
	assign HMASTLOCK = 1'b0;
	assign HPROT = 4'h0;
	assign HSIZE = 4'h0;
	assign HTRANS = 2'b0;
	assign HWDATA = 32'h0;
	assign HWRITE = 1'b0;
endmodule
