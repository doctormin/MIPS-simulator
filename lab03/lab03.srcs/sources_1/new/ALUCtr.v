`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 15:59:26
// Design Name: 
// Module Name: ALUCtr
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

module ALUCtr(
        input  [5:0] funct,
        input  [1:0] ALUOp,
        output [3:0] AlUCtrOut
    );

    reg [3:0] aluCtrOut;
    assign AlUCtrOut = aluCtrOut; 

    always @ (ALUOp or funct) begin
        casex({ALUOp, funct})
            /*
            8'b00xxxxxx : aluCtrOut = 4'b0010;
            8'bx1xxxxxx : aluCtrOut = 4'b0110;
            8'b1xxx0000 : aluCtrOut = 4'b0010;
            8'b1xxx0010 : aluCtrOut = 4'b0110;
            8'b1xxx0100 : aluCtrOut = 4'b0000;
            8'b1xxx0101 : aluCtrOut = 4'b0001;
            8'b1xxx1010 : aluCtrOut = 4'b0111;
            */
            8'b00000000 : aluCtrOut = 4'b0010;
            8'b01000000 : aluCtrOut = 4'b0110;
            8'b10000000 : aluCtrOut = 4'b0010;
            8'b10000010 : aluCtrOut = 4'b0110;
            8'b10000100 : aluCtrOut = 4'b0000;
            8'b10000101 : aluCtrOut = 4'b0001;
            8'b10001010 : aluCtrOut = 4'b0111;

        endcase
    end
endmodule
