`timescale 1ns / 1ps
`include "ISA.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 01:07:28
// Design Name: 
// Module Name: Control_unit
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

module control_unit #
                (
                    parameter DATA_WIDTH    = 32
                )
                (
                    input [DATA_WIDTH-1   :0] i_instruction,
                    output reg MemRead,
                    output reg MemWrite,
                    output reg MemtoReg,
                    output reg ALUSrc,
                    output reg RegWrite,
                    output reg RegDst
                );

    localparam rt  = 0,
               rd  = 1,
               imm = 1;

    always @(*) begin
        case(i_instruction[31:26]) //opcode
        `OP_R: 
            begin
                RegWrite = 1;
                ALUSrc   = rt; 
                MemtoReg = 0;
                RegDst   = rd; 
                MemRead  = 0;
                MemWrite = 0;
            end
        `OP_ADDI, `OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_SLTIU:
            begin
                RegWrite = 1;
                ALUSrc   = imm; 
                MemtoReg = 0;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0;
            end
        `OP_BEQ, `OP_BNE, `OP_BLTZ, `OP_BLTZAL, `OP_BGEZ, `OP_BGEZAL, `OP_BGTZ, `OP_BLEZ:
            begin
                RegWrite = 0;
                ALUSrc   = rt; 
                MemtoReg = 0;
                RegDst   = 0; // don't care
                MemRead  = 0;
                MemWrite = 0;                 
            end
        `OP_LUI:
            begin
                RegWrite = 1;
                ALUSrc   = imm; 
                MemtoReg = 0;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0; 
            end
        `OP_J, `OP_JAL:
            begin
                RegWrite = 0;
                ALUSrc   = 0; //Don't care 
                MemtoReg = 0;
                RegDst   = 0; //Don't care 
                MemRead  = 0;
                MemWrite = 0; 
            end
        `OP_LB, `OP_LBU, `OP_LH, `OP_LHU, `OP_LW: 
            begin
                RegWrite = 1;
                ALUSrc   = imm; 
                MemtoReg = 1;
                RegDst   = rt; 
                MemRead  = 1; //Mem -> Reg
                MemWrite = 0;
            end
        `OP_SB, `OP_SH, `OP_SW: 
            begin
                RegWrite = 0;
                ALUSrc   = imm; 
                MemtoReg = 0;
                RegDst   = 0; //Don't care
                MemRead  = 0; //Reg -> Mem
                MemWrite = 1;
            end
        default: 
            begin
                $warning("%m: opcode not recognized: %06b", i_instruction[31:26]);
            end
        endcase
    end
endmodule  //control_unit
