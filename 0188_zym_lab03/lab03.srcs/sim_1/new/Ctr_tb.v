`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/22 23:16:19
// Design Name: 
// Module Name: Ctr_tb
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
`define ALU_r   6'b000000;
`define ALU_iw  6'b100011;
`define ALU_sw  6'b101011;
`define ALU_beq 6'b000100;
`define ALU_j   6'b000010;

module Ctr_tb();
    reg [5:0] OpCode;
    wire RegDst;
    wire ALUSrc;
    wire MemToReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] ALUOp;
    wire Jump;
    Ctr ctr(
        .opCode     (OpCode),
        .regDst     (RegDst),
        .aluSrc     (ALUSrc),
        .memToReg   (MemToReg),
        .regWrite   (RegWrite),
        .memRead    (MemRead),
        .memWrite   (MemWrite),
        .branch     (Branch),
        .aluOp      (ALUOp),
        .jump       (Jump)
    );
    initial begin
        OpCode = 0;
        #100;
        #100 OpCode = `ALU_r;
        #100 OpCode = `ALU_iw;
        #100 OpCode = `ALU_sw
        #100 OpCode = `ALU_beq;
        #100 OpCode = `ALU_j;
        #100 OpCode = 6'b010101;
    end
endmodule
