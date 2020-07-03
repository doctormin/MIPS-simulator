`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 00:45:25
// Design Name: 
// Module Name: ID_EX
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
`include "ISA.v"
module  ID_EX   #
                (
                    parameter W = 32
                )
                (
                    input       clk,
                    input       flush, //如果为高电平，则清空本寄存器
                    input       [W-1:0]    i_ID_rs,
                    input       [W-1:0]    i_ID_rt,
                    input       [W-1:0]    i_ID_pc,
                    input       [W-1:0]    i_ID_instruction,
                    output  reg [W-1:0]    o_EX_pc,
                    output  reg [W-1:0]    o_EX_instruction,
                    output  reg [W-1:0]    o_EX_rs,
                    output  reg [W-1:0]    o_EX_rt
                );
    always @(posedge clk) begin
        if(flush) begin
            o_EX_rs <= 0;
            o_EX_rt <= 0;
            o_EX_instruction <= 0;
            o_EX_pc <= 0;
        end
        else begin
            o_EX_rs <= i_ID_rs;
            o_EX_rt <= i_ID_rt;
            o_EX_instruction <= i_ID_instruction;
            o_EX_pc <= i_ID_pc;
        end
    end
endmodule //ID_EX