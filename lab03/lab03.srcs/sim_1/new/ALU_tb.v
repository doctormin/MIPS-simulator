`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 17:39:10
// Design Name: 
// Module Name: ALU_tb
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

module ALU_tb();
    reg  [31:0] src1;
    reg  [31:0] src2;
    reg  [3:0]  aluCtr;
    wire [31:0] aluRes;
    wire zero;
    ALU alu(
        .src1(src1),
        .src2(src2),
        .aluCtr(aluCtr),
        .aluRes(aluRes),
        .zero(zero)
    );

    parameter AND = 4'b0000,
              OR  = 4'b0001,
              ADD = 4'b0010,
              SUB = 4'b0110,
              SLT = 4'b0110,
              NOR = 4'b1100;
    
    initial begin
        src1 <= 0;
        src2 <= 0;
        #100;
        src1 = 1;
        src2 = 1;
        aluCtr = SUB;
        #100;
        src1 = 10;
        src2 = 1;
        aluCtr = ADD;
        #100;
        src1 = 4'b1101;
        src2 = 4'b1011;
        aluCtr = AND;
    end
endmodule
