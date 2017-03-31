/*

 Kamikaze-uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 CERN
 Author: Tomasz Włostowski <tomasz.wlostowski@cern.ch>
 
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

module Kamikaze_CPU
(
  // 时钟与复位
  input			CLK, /* 系统时钟、AHB时钟 */
  input			nRST, /* CPU复位、AHB复位 */

  // 调试系统
  input			DBGU_RXD, /* 调试串口接收 */
  output		DBGU_TXD, /* 调试串口发送 */

  input			DBUG_nRST, /* 调试系统硬开关/复位 */

  //中断系统与异常处理系统
  input [31:0]	nIRQ, /* 32个中断输入，低电平有效 */
  input 		nNMI, /* 不可屏蔽中断输入,低电平有效 */
  output 		TRAP, /* 处理器挂起输出，由调试挂起/WFI/BREAK或异常指令触发 */
  input [31:0]	STARTUP_BASE, /* 中断向量表起始地址，于复位信号无效后被采样，系统由此开始执行，可直接写死 */

  // AHB-LITE 指令端口
  output [31:0]	HADDR_I,
  output [2:0] 	HBURST_I,
  output 		HMASTLOCK_I,
  output [3:0] 	HPROT_I,
  output [2:0] 	HSIZE_I,
  output [1:0] 	HTRANS_I,
  output [31:0] HWDATA_I,
  output 		HWRITE_I,

  input [31:0] 	HRDATA_I,
  input 		HREADY_I,
  input 		HRESP_I,

  // AHB-LITE 数据端口
  output [31:0]	HADDR_D,
  output [2:0] 	HBURST_D,
  output 		HMASTLOCK_D,
  output [3:0]	HPROT_D,
  output [2:0] 	HSIZE_D,
  output [1:0] 	HTRANS_D,
  output [31:0]	HWDATA_D,
  output		HWRITE_D,

  input [31:0]	HRDATA_D,
  input			HREADY_D,
  input			HRESP_D
);
