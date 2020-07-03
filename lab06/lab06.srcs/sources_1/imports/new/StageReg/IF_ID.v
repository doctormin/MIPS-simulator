`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/02 12:14:25
// Design Name: 
// Module Name: IF_ID
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

module  IF_ID   #
                (
                    parameter DW = 32,
                    parameter AW = 32
                )
                (
                    input                   clk,
                    input                   flush, //如果为高电平，则清空本寄存器
                    input       [AW-1:0]    i_IF_pc,
                    input       [DW-1:0]    i_IF_instruction,
                    output  reg [AW-1:0]    o_ID_pc,
                    output  reg [DW-1:0]    o_ID_instruction
                );

always @(negedge clk) begin
    if(flush) begin
        o_ID_instruction <= 0;
        o_ID_pc <= 0;
    end
    else begin
        o_ID_instruction <= i_IF_instruction;
        o_ID_pc <= i_IF_pc;
    end
end
endmodule //IF_ID