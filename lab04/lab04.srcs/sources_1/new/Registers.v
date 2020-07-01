`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 19:48:51
// Design Name: 
// Module Name: Registers
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Registers(
    input          clk,
    input  [25:21] readReg1, 
    input  [20:16] readReg2, 
    input  [4 :0 ] writeReg, //待写入的寄存器编号
    input  [31:0 ] writeData, //待写入的数据
    input          regWrite, //写入信号
    output [31:0 ] readData1, //读出的数据1
    output [31:0 ] readData2 //读出的数据2
    );
    reg  [31:0] Register[0:31];
    //Read Data
    assign readData1 = Register[readReg1];
    assign readData2 = Register[readReg2];
    always @ (negedge clk) begin
        //Write Data
        if(regWrite) begin
            Register[writeReg] <= writeData;
        end
    end
endmodule
