`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/22 22:48:10
// Design Name: 
// Module Name: Ctr
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
`define ALU_lw  6'b100011;
`define ALU_sw  6'b101011;
`define ALU_beq 6'b000100;
`define ALU_j   6'b000010;

module Ctr(
        input [5:0] opCode,
        output regDst,
        output aluSrc,
        output memToReg,
        output regWrite,
        output memRead,
        output memWrite,
        output branch,
        output [1:0] aluOp,
        output jump
    );
    reg RegDst;
    reg ALUSrc;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg Branch;
    reg [1:0] ALUOp;
    reg Jump;
    always @ (opCode) begin 
        case(opCode)
        //R
        6'b000000: begin
            RegDst = 1;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp[1] = 1;
            ALUOp[0] = 0;
            Jump = 0;
        end
        //lw
        6'b100011: begin
            RegDst = 0;
            ALUSrc = 1;
            MemToReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp[1] = 0;
            ALUOp[0] = 0;
            Jump = 0;
        end
        //sw
        6'b101011: begin
            RegDst = 1'bx;
            ALUSrc = 1;
            MemToReg = 1'bx;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp[1] = 0;
            ALUOp[0] = 0;
            Jump = 0;
        end
        //beq
        6'b000100: begin
            RegDst = 1'bx;
            ALUSrc = 0;
            MemToReg = 1'bx;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            ALUOp[1] = 0;
            ALUOp[0] = 1;
            Jump = 0;
        end
        //j
        6'b000010: begin
            RegDst = 1'bx;
            ALUSrc = 0;
            MemToReg = 1'bx;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp[1] = 0;
            ALUOp[0] = 0;
            Jump = 1;
        end
        default: begin
            RegDst = 0;
            ALUSrc = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp = 2'b00;
            Jump = 0;
        end
        endcase
    end 
    assign regDst   = RegDst;
    assign aluSrc   = ALUSrc;
    assign memToReg = MemToReg;
    assign regWrite = RegWrite;
    assign memRead  = MemRead;
    assign memWrite = MemWrite;
    assign branch   = Branch;
    assign aluOp    = ALUOp;
    assign jump     = Jump;
endmodule

