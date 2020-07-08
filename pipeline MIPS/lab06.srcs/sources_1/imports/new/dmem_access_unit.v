`timescale 1ns / 1ps
`include "ISA.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/03 02:05:49
// Design Name: 
// Module Name: dmem_access_unit
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

module dmem_access_unit #
                (
                    parameter W = 32
                )
                (
                    input [W-1:0] i_MEM_instruction,
                    output reg       MemRead,
                    output reg       MemWrite,
                    output reg [1:0] mode
                );

    localparam word      = 2'b00,
               half_word = 2'b01,
               B         = 2'b10;
    
    always @(*) begin
        case(`get_op(i_MEM_instruction)) //opcode
        `OP_LB, `OP_LBU:
            begin
                MemRead  = 1; 
                MemWrite = 0;
                mode     = B;
            end
        `OP_LH, `OP_LHU: 
            begin
                MemRead  = 1; 
                MemWrite = 0;
                mode     = half_word;
            end
        `OP_LW:
            begin 
                MemRead  = 1; 
                MemWrite = 0;
                mode     = word;
            end
        `OP_SB:
            begin
                MemRead  = 0; 
                MemWrite = 1;
                mode     = B;
            end
        `OP_SH:
            begin
                MemRead  = 0; 
                MemWrite = 1;
                mode     = half_word;
            end
        `OP_SW: 
            begin
                MemRead  = 0; 
                MemWrite = 1;
                mode     = word;
            end
        default: 
            begin
                MemRead  = 0; 
                MemWrite = 0;
                mode     = word; //Don't care
            end
        endcase
        if(`isNop(i_MEM_instruction)) begin
            MemRead  = 0; 
            MemWrite = 0;
            mode     = word; //Don't care
        end
    end

endmodule  //reg_write_unit
