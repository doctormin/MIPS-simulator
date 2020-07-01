`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 00:44:25
// Design Name: 
// Module Name: data_mem
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

module data_mem #
                (
                    parameter DATA_WIDTH    = 32,
                    parameter ADDRESS_WIDTH = 32
                )
                (
                    input                          clk,
                    input                          MemWrite,
                    input                          MemRead,
                    input      [ADDRESS_WIDTH-1:0] i_address,
                    input      [ADDRESS_WIDTH-1:0] i_write_data,
                    
                    output reg [DATA_WIDTH-1   :0] o_read_data
                );

reg [DATA_WIDTH-1:0] D_memory [0:99];

always @(*) begin
    if(MemRead)
        o_read_data = D_memory[i_address];
end

always @(negedge clk) begin
    if(MemWrite)
        D_memory[i_address] = i_write_data;
end

endmodule //data memory
