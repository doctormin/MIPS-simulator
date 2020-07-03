`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 00:44:35
// Design Name: 
// Module Name: MEM_WB
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

module  MEM_WB  #
                (
                    parameter W = 32
                )
                (
                    input       clk,
                    input      [W-1:0] i_MEM_instruction,
                    input      [W-1:0] i_MEM_pc,
                    input      [W-1:0] i_MEM_dmem_read_data,
                    input      [W-1:0] i_MEM_alu_res,
                    input              i_MEM_RegWrite,
                    input      [`reg]  i_MEM_reg_write_addr,
                    input      [W-1:0] i_MEM_reg_write_data,

                    output reg [W-1:0] o_WB_instruction,
                    output reg [W-1:0] o_WB_pc,
                    output reg [W-1:0] o_WB_dmem_read_data, //连接forwading unit
                    output reg [W-1:0] o_WB_alu_res,
                    output reg         o_WB_RegWrite,
                    output reg [`reg]  o_WB_reg_write_addr,
                    output reg [W-1:0] o_WB_reg_write_data
                );
    always @(posedge clk) begin
       o_WB_instruction    <= i_MEM_instruction;
       o_WB_pc             <= i_MEM_pc;
       o_WB_dmem_read_data <= i_MEM_dmem_read_data;
       o_WB_alu_res        <= i_MEM_alu_res;
       o_WB_RegWrite       <= i_MEM_RegWrite;
       o_WB_reg_write_addr <= i_MEM_reg_write_addr;
       o_WB_reg_write_data <= i_MEM_reg_write_data;
    end
endmodule //MEM_WB