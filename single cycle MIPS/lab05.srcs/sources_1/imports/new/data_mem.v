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
                    input      [1:0]               mode,      //0:word, 1:half word, 2: byte
                    input      [ADDRESS_WIDTH-1:0] i_address,
                    input      [ADDRESS_WIDTH-1:0] i_write_data,
                    
                    output reg [DATA_WIDTH-1   :0] o_read_data
                );
    localparam  memSize = 1000;
    reg [7:0] D_memory [0:memSize-1];

    always @(*) begin
        if(MemRead) begin
            case (mode)
                2'b10: //Byte
                    o_read_data = {{24{1'b0}}, D_memory[i_address]};
                2'b01: //half word
                    o_read_data = {{16{1'b0}}, D_memory[i_address], D_memory[i_address + 1]};
                2'b00: //word 
                    o_read_data = {
                                    D_memory[i_address], 
                                    D_memory[i_address + 1], 
                                    D_memory[i_address + 2], 
                                    D_memory[i_address + 3]
                                };
            endcase
        end
    end

    always @(negedge clk) begin
        if(MemWrite) begin
            case (mode)
                2'b10: //Byte
                    D_memory[i_address + 0] = i_write_data[ 7: 0];
                2'b01: //half word
                    begin
                        D_memory[i_address + 0] = i_write_data[15: 8];
                        D_memory[i_address + 1] = i_write_data[ 7: 0];
                    end
                2'b00: //word
                    begin
                        D_memory[i_address + 0] = i_write_data[31:24];
                        D_memory[i_address + 1] = i_write_data[23:16];
                        D_memory[i_address + 2] = i_write_data[15: 8];
                        D_memory[i_address + 3] = i_write_data[ 7: 0];
                    end 
            endcase
        end
    end

    integer i;
    initial begin
        for(i = 0; i < memSize; i = i + 1) begin
            D_memory[i] = 0;
        end
    end

endmodule //data memory
