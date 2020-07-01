`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 00:04:02
// Design Name: 
// Module Name: instruction_mem
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

module instruction_mem #
                (
                    parameter DATA_WIDTH    = 32,
                    parameter ADDRESS_WIDTH = 32
                )
                (
                    input      [ADDRESS_WIDTH-1:0] i_read_address,
                    output reg [DATA_WIDTH-1   :0] o_instruction
                );
    localparam textDump = "./DUMP/dump";
    localparam memSize  = 2000;
    initial begin
        genvar i;
        for(i = 0; i < memSize; i = i + 1) begin
            I_memory[i] = 0;
        end
        $readmemh(textDump, I_memory);
    end
    reg [DATA_WIDTH-1:0] I_memory[0:memSize-1];
    always @(*) begin
        o_instruction = I_memory[i_read_address];
    end
endmodule  //instruction_mem