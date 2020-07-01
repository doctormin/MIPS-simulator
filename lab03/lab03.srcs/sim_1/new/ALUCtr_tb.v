`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 16:20:26
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb();
    wire [3:0] ALUCtrOut;
    reg  [1:0] ALUOp;
    reg  [5:0] funct;
    ALUCtr aluCtr(
        .funct(funct),
        .ALUOp(ALUOp),
        .AlUCtrOut(ALUCtrOut)
    );
    initial begin
        funct = 6'b000000;
        ALUOp = 2'b00;
        #100 funct = 6'bxxxxxx;
        #60 ALUOp = 2'bx1;
        #60;
        ALUOp = 2'b1x;
        funct = 6'bxx0000;
        #60 funct = 6'bxx0010;
        #60 funct = 6'bxx0100;
        #60 funct = 6'bxx0101;
        #60 funct = 6'bxx1010;
    end
endmodule
