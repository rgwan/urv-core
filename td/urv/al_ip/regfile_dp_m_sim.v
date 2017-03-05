// Verilog netlist created by TD v3.1.131
// Sun Mar  5 13:19:57 2017

module regfile_dp_m  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(14)
  (
  di,
  raddr,
  waddr,
  wclk,
  we,
  do
  );

  input [31:0] di;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(23)
  input [4:0] raddr;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(25)
  input [4:0] waddr;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(24)
  input wclk;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(26)
  input we;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(26)
  output [31:0] do;  // /home/rgwan/riscv/urv-core/td/urv/al_ip/regfile_dp_m.v(28)

  parameter ADDR_WIDTH_R = 5;
  parameter ADDR_WIDTH_W = 5;
  parameter DATA_DEPTH_R = 32;
  parameter DATA_DEPTH_W = 32;
  parameter DATA_WIDTH_R = 32;
  parameter DATA_WIDTH_W = 32;
  wire dram_do_i0_000;
  wire dram_do_i0_001;
  wire dram_do_i0_002;
  wire dram_do_i0_003;
  wire dram_do_i0_004;
  wire dram_do_i0_005;
  wire dram_do_i0_006;
  wire dram_do_i0_007;
  wire dram_do_i0_008;
  wire dram_do_i0_009;
  wire dram_do_i0_010;
  wire dram_do_i0_011;
  wire dram_do_i0_012;
  wire dram_do_i0_013;
  wire dram_do_i0_014;
  wire dram_do_i0_015;
  wire dram_do_i0_016;
  wire dram_do_i0_017;
  wire dram_do_i0_018;
  wire dram_do_i0_019;
  wire dram_do_i0_020;
  wire dram_do_i0_021;
  wire dram_do_i0_022;
  wire dram_do_i0_023;
  wire dram_do_i0_024;
  wire dram_do_i0_025;
  wire dram_do_i0_026;
  wire dram_do_i0_027;
  wire dram_do_i0_028;
  wire dram_do_i0_029;
  wire dram_do_i0_030;
  wire dram_do_i0_031;
  wire dram_do_i1_000;
  wire dram_do_i1_001;
  wire dram_do_i1_002;
  wire dram_do_i1_003;
  wire dram_do_i1_004;
  wire dram_do_i1_005;
  wire dram_do_i1_006;
  wire dram_do_i1_007;
  wire dram_do_i1_008;
  wire dram_do_i1_009;
  wire dram_do_i1_010;
  wire dram_do_i1_011;
  wire dram_do_i1_012;
  wire dram_do_i1_013;
  wire dram_do_i1_014;
  wire dram_do_i1_015;
  wire dram_do_i1_016;
  wire dram_do_i1_017;
  wire dram_do_i1_018;
  wire dram_do_i1_019;
  wire dram_do_i1_020;
  wire dram_do_i1_021;
  wire dram_do_i1_022;
  wire dram_do_i1_023;
  wire dram_do_i1_024;
  wire dram_do_i1_025;
  wire dram_do_i1_026;
  wire dram_do_i1_027;
  wire dram_do_i1_028;
  wire dram_do_i1_029;
  wire dram_do_i1_030;
  wire dram_do_i1_031;
  wire waddr$4$_neg;
  wire we_0;
  wire we_1;

  AL_MUX dram_do_mux_b0_al_mux_b0_0_0 (
    .i0(dram_do_i0_000),
    .i1(dram_do_i1_000),
    .sel(raddr[4]),
    .o(do[0]));
  AL_MUX dram_do_mux_b10_al_mux_b0_0_0 (
    .i0(dram_do_i0_010),
    .i1(dram_do_i1_010),
    .sel(raddr[4]),
    .o(do[10]));
  AL_MUX dram_do_mux_b11_al_mux_b0_0_0 (
    .i0(dram_do_i0_011),
    .i1(dram_do_i1_011),
    .sel(raddr[4]),
    .o(do[11]));
  AL_MUX dram_do_mux_b12_al_mux_b0_0_0 (
    .i0(dram_do_i0_012),
    .i1(dram_do_i1_012),
    .sel(raddr[4]),
    .o(do[12]));
  AL_MUX dram_do_mux_b13_al_mux_b0_0_0 (
    .i0(dram_do_i0_013),
    .i1(dram_do_i1_013),
    .sel(raddr[4]),
    .o(do[13]));
  AL_MUX dram_do_mux_b14_al_mux_b0_0_0 (
    .i0(dram_do_i0_014),
    .i1(dram_do_i1_014),
    .sel(raddr[4]),
    .o(do[14]));
  AL_MUX dram_do_mux_b15_al_mux_b0_0_0 (
    .i0(dram_do_i0_015),
    .i1(dram_do_i1_015),
    .sel(raddr[4]),
    .o(do[15]));
  AL_MUX dram_do_mux_b16_al_mux_b0_0_0 (
    .i0(dram_do_i0_016),
    .i1(dram_do_i1_016),
    .sel(raddr[4]),
    .o(do[16]));
  AL_MUX dram_do_mux_b17_al_mux_b0_0_0 (
    .i0(dram_do_i0_017),
    .i1(dram_do_i1_017),
    .sel(raddr[4]),
    .o(do[17]));
  AL_MUX dram_do_mux_b18_al_mux_b0_0_0 (
    .i0(dram_do_i0_018),
    .i1(dram_do_i1_018),
    .sel(raddr[4]),
    .o(do[18]));
  AL_MUX dram_do_mux_b19_al_mux_b0_0_0 (
    .i0(dram_do_i0_019),
    .i1(dram_do_i1_019),
    .sel(raddr[4]),
    .o(do[19]));
  AL_MUX dram_do_mux_b1_al_mux_b0_0_0 (
    .i0(dram_do_i0_001),
    .i1(dram_do_i1_001),
    .sel(raddr[4]),
    .o(do[1]));
  AL_MUX dram_do_mux_b20_al_mux_b0_0_0 (
    .i0(dram_do_i0_020),
    .i1(dram_do_i1_020),
    .sel(raddr[4]),
    .o(do[20]));
  AL_MUX dram_do_mux_b21_al_mux_b0_0_0 (
    .i0(dram_do_i0_021),
    .i1(dram_do_i1_021),
    .sel(raddr[4]),
    .o(do[21]));
  AL_MUX dram_do_mux_b22_al_mux_b0_0_0 (
    .i0(dram_do_i0_022),
    .i1(dram_do_i1_022),
    .sel(raddr[4]),
    .o(do[22]));
  AL_MUX dram_do_mux_b23_al_mux_b0_0_0 (
    .i0(dram_do_i0_023),
    .i1(dram_do_i1_023),
    .sel(raddr[4]),
    .o(do[23]));
  AL_MUX dram_do_mux_b24_al_mux_b0_0_0 (
    .i0(dram_do_i0_024),
    .i1(dram_do_i1_024),
    .sel(raddr[4]),
    .o(do[24]));
  AL_MUX dram_do_mux_b25_al_mux_b0_0_0 (
    .i0(dram_do_i0_025),
    .i1(dram_do_i1_025),
    .sel(raddr[4]),
    .o(do[25]));
  AL_MUX dram_do_mux_b26_al_mux_b0_0_0 (
    .i0(dram_do_i0_026),
    .i1(dram_do_i1_026),
    .sel(raddr[4]),
    .o(do[26]));
  AL_MUX dram_do_mux_b27_al_mux_b0_0_0 (
    .i0(dram_do_i0_027),
    .i1(dram_do_i1_027),
    .sel(raddr[4]),
    .o(do[27]));
  AL_MUX dram_do_mux_b28_al_mux_b0_0_0 (
    .i0(dram_do_i0_028),
    .i1(dram_do_i1_028),
    .sel(raddr[4]),
    .o(do[28]));
  AL_MUX dram_do_mux_b29_al_mux_b0_0_0 (
    .i0(dram_do_i0_029),
    .i1(dram_do_i1_029),
    .sel(raddr[4]),
    .o(do[29]));
  AL_MUX dram_do_mux_b2_al_mux_b0_0_0 (
    .i0(dram_do_i0_002),
    .i1(dram_do_i1_002),
    .sel(raddr[4]),
    .o(do[2]));
  AL_MUX dram_do_mux_b30_al_mux_b0_0_0 (
    .i0(dram_do_i0_030),
    .i1(dram_do_i1_030),
    .sel(raddr[4]),
    .o(do[30]));
  AL_MUX dram_do_mux_b31_al_mux_b0_0_0 (
    .i0(dram_do_i0_031),
    .i1(dram_do_i1_031),
    .sel(raddr[4]),
    .o(do[31]));
  AL_MUX dram_do_mux_b3_al_mux_b0_0_0 (
    .i0(dram_do_i0_003),
    .i1(dram_do_i1_003),
    .sel(raddr[4]),
    .o(do[3]));
  AL_MUX dram_do_mux_b4_al_mux_b0_0_0 (
    .i0(dram_do_i0_004),
    .i1(dram_do_i1_004),
    .sel(raddr[4]),
    .o(do[4]));
  AL_MUX dram_do_mux_b5_al_mux_b0_0_0 (
    .i0(dram_do_i0_005),
    .i1(dram_do_i1_005),
    .sel(raddr[4]),
    .o(do[5]));
  AL_MUX dram_do_mux_b6_al_mux_b0_0_0 (
    .i0(dram_do_i0_006),
    .i1(dram_do_i1_006),
    .sel(raddr[4]),
    .o(do[6]));
  AL_MUX dram_do_mux_b7_al_mux_b0_0_0 (
    .i0(dram_do_i0_007),
    .i1(dram_do_i1_007),
    .sel(raddr[4]),
    .o(do[7]));
  AL_MUX dram_do_mux_b8_al_mux_b0_0_0 (
    .i0(dram_do_i0_008),
    .i1(dram_do_i1_008),
    .sel(raddr[4]),
    .o(do[8]));
  AL_MUX dram_do_mux_b9_al_mux_b0_0_0 (
    .i0(dram_do_i0_009),
    .i1(dram_do_i1_009),
    .sel(raddr[4]),
    .o(do[9]));
  AL_LOGIC_DRAM16X4 dram_r0_c0 (
    .di(di[3:0]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_003,dram_do_i0_002,dram_do_i0_001,dram_do_i0_000}));
  AL_LOGIC_DRAM16X4 dram_r0_c1 (
    .di(di[7:4]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_007,dram_do_i0_006,dram_do_i0_005,dram_do_i0_004}));
  AL_LOGIC_DRAM16X4 dram_r0_c2 (
    .di(di[11:8]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_011,dram_do_i0_010,dram_do_i0_009,dram_do_i0_008}));
  AL_LOGIC_DRAM16X4 dram_r0_c3 (
    .di(di[15:12]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_015,dram_do_i0_014,dram_do_i0_013,dram_do_i0_012}));
  AL_LOGIC_DRAM16X4 dram_r0_c4 (
    .di(di[19:16]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_019,dram_do_i0_018,dram_do_i0_017,dram_do_i0_016}));
  AL_LOGIC_DRAM16X4 dram_r0_c5 (
    .di(di[23:20]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_023,dram_do_i0_022,dram_do_i0_021,dram_do_i0_020}));
  AL_LOGIC_DRAM16X4 dram_r0_c6 (
    .di(di[27:24]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_027,dram_do_i0_026,dram_do_i0_025,dram_do_i0_024}));
  AL_LOGIC_DRAM16X4 dram_r0_c7 (
    .di(di[31:28]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_0),
    .do({dram_do_i0_031,dram_do_i0_030,dram_do_i0_029,dram_do_i0_028}));
  AL_LOGIC_DRAM16X4 dram_r1_c0 (
    .di(di[3:0]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_003,dram_do_i1_002,dram_do_i1_001,dram_do_i1_000}));
  AL_LOGIC_DRAM16X4 dram_r1_c1 (
    .di(di[7:4]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_007,dram_do_i1_006,dram_do_i1_005,dram_do_i1_004}));
  AL_LOGIC_DRAM16X4 dram_r1_c2 (
    .di(di[11:8]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_011,dram_do_i1_010,dram_do_i1_009,dram_do_i1_008}));
  AL_LOGIC_DRAM16X4 dram_r1_c3 (
    .di(di[15:12]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_015,dram_do_i1_014,dram_do_i1_013,dram_do_i1_012}));
  AL_LOGIC_DRAM16X4 dram_r1_c4 (
    .di(di[19:16]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_019,dram_do_i1_018,dram_do_i1_017,dram_do_i1_016}));
  AL_LOGIC_DRAM16X4 dram_r1_c5 (
    .di(di[23:20]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_023,dram_do_i1_022,dram_do_i1_021,dram_do_i1_020}));
  AL_LOGIC_DRAM16X4 dram_r1_c6 (
    .di(di[27:24]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_027,dram_do_i1_026,dram_do_i1_025,dram_do_i1_024}));
  AL_LOGIC_DRAM16X4 dram_r1_c7 (
    .di(di[31:28]),
    .raddr(raddr[3:0]),
    .waddr(waddr[3:0]),
    .wclk(wclk),
    .we(we_1),
    .do({dram_do_i1_031,dram_do_i1_030,dram_do_i1_029,dram_do_i1_028}));
  not \waddr[4]_inv (waddr$4$_neg, waddr[4]);
  and we_0i (we_0, we, waddr$4$_neg);
  and we_1i (we_1, we, waddr[4]);

endmodule 

module AL_MUX
  (
  input i0,
  input i1,
  input sel,
  output o
  );

  wire not_sel, sel_i0, sel_i1;
  not u0 (not_sel, sel);
  and u1 (sel_i1, sel, i1);
  and u2 (sel_i0, not_sel, i0);
  or u3 (o, sel_i1, sel_i0);

endmodule

