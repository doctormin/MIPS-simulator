`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 16:55:36
// Design Name: 
// Module Name: TOP
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


module TOP (
            input clk,
            input reset 
           );
    localparam DATA_WIDTH        = 32,
               ADDRESS_WIDTH     = 32,
               REG_ADDRESS_WIDTH = 5;
    wire [DATA_WIDTH-1:0]    TOP_instruction;
    wire [DATA_WIDTH-1:0]    TOP_dmem_read_data;
    wire [DATA_WIDTH-1:0]    TOP_dmem_write_data;
    wire [ADDRESS_WIDTH-1:0] TOP_pc;
    wire [ADDRESS_WIDTH-1:0] TOP_dmem_addr;
    wire                     TOP_MemWrite;
    wire                     TOP_MemRead;


    CPU #(ADDRESS_WIDTH, DATA_WIDTH, REG_ADDRESS_WIDTH)
        TOP_CPU
        (
            .clk(clk),
            .reset(reset),
            .i_cpu_instruction(TOP_instruction),
            .i_cpu_dmem_read_data(TOP_dmem_read_data),
            .o_cpu_pc(TOP_pc),
            .o_cpu_dmem_addr(TOP_dmem_addr),
            .o_cpu_dmem_write_data(TOP_dmem_write_data),
            .o_cpu_MemWrite(TOP_MemWrite),
            .o_cpu_MemRead(TOP_MemRead)
        );
        
    instruction_mem #(DATA_WIDTH, ADDRESS_WIDTH)
                   TOP_instuction_mem
                   (
                       .i_read_address(TOP_pc),
                       .o_instruction(TOP_instruction)
                   );
   
    data_mem       #(DATA_WIDTH, ADDRESS_WIDTH)
                   TOP_data_mem
                   (
                       .clk(clk),
                       .MemWrite(TOP_MemWrite),
                       .MemRead(TOP_MemRead),
                       .i_address(TOP_dmem_addr),
                       .i_write_data(TOP_dmem_write_data),
                       .o_read_data(TOP_dmem_read_data)
                   );

endmodule //TOP