`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 21:37:12
// Design Name: 
// Module Name: Register_tb
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


module Register_tb();
    reg clk;
    reg  [25:21] readReg1;
    reg  [20:16] readReg2;
    reg  [4:0]   writeReg; //待写入的寄存器编号
    reg  [31:0]  writeData; //待写入的数据
    reg  regWrite; //写入信号
    wire [31:0] readData1; //读出的数据1
    wire [31:0] readData2; //读出的数据2
    parameter PERIOD = 100;
    always # (PERIOD) clk = !clk;

    Registers register(
        .clk(clk),
        .readReg1 (readReg1),
        .readReg2 (readReg2),
        .writeReg (writeReg),
        .writeData(writeData),
        .regWrite (regWrite),
        .readData1(readData1),
        .readData2(readData2)
    );
    initial begin
        clk = 1;
        readReg1 = 5'bxxxxx;
        readReg2 = 5'bxxxxx;
        #285;
        regWrite = 1'b1;
        writeReg = 5'b10101;
        writeData = 32'b11111111111111110000000000000000;
        
        #200;
        writeReg = 5'b01010;
        writeData = 32'b00000000000000001111111111111111;

        #200;
        regWrite = 1'b0;
        writeReg = 5'b00000;
        writeData = 32'b00000000000000000000000000000000;

        #50;
        readReg1 = 5'b10101;
        readReg2 = 5'b01010;
    end

endmodule
