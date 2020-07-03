`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 00:43:25
// Design Name: 
// Module Name: EX_MEM
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
module  EX_MEM  #
                (
                    parameter W = 32
                )
                (
                    input       clk,
                    input [W-1:0] i_EX_instruction,
                    input [W-1:0] i_EX_pc,
                    input [W-1:0] i_EX_alu_res, 
                    input [W-1:0] i_EX_rt,
                    output reg [W-1:0] o_MEM_alu_res,  //连接forwarding  unit
                    output reg [W-1:0] o_MEM_instruction,
                    output reg [W-1:0] o_MEM_pc,
                    output reg [W-1:0] o_MEM_rt
                );
    always @(negedge clk) begin
       o_MEM_alu_res     <= i_EX_alu_res;
       o_MEM_instruction <= i_EX_instruction;
       o_MEM_pc          <= i_EX_pc;
       o_MEM_rt          <= i_EX_rt;
    end
endmodule //
