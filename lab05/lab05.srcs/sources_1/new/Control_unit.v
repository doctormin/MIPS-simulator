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
                    output reg [1:0] MemtoReg, //0:alu_res 1:dmem_data   2:pc + 8
                    output reg [1:0] ALUSrc,   //0:rt      1:imm         2:zero
                    output reg RegWrite,
                    output reg [1:0] RegDst    //0:rt      1:rd          2:pc+8
                );

               //RegDst - Mux3to1
    localparam rt        = 2'b00,
               rd        = 2'b01,
               GPR31     = 2'b10,
               //AUSrc - Mux3to1
               imm       = 2'b01,
               zero      = 2'b10,
               //MemtoReg - Mux3to1
               alu_res   = 2'b00,
               dmem_data = 2'b01,
               pc_plus_8 = 2'b10;

    always @(*) begin
        case(i_instruction[31:26]) //opcode
        `OP_R: 
            begin
                RegWrite = 1;
                ALUSrc   = rt; 
                MemtoReg = alu_res;
                RegDst   = rd; 
                MemRead  = 0;
                MemWrite = 0;
            end
        `OP_ADDI, `OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_SLTIU:
            begin
                RegWrite = 1;
                ALUSrc   = imm; 
                MemtoReg = alu_res;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0;
            end
        `OP_BEQ, `OP_BNE:
            begin
                RegWrite = 0;
                ALUSrc   = rt; 
                MemtoReg = 0; // don't care
                RegDst   = 0; // don't care
                MemRead  = 0;
                MemWrite = 0;                 
            end
        `OP_BLTZ, `OP_BGEZ, `OP_BGTZ, `OP_BLEZ:
            begin
                RegWrite = 0;
                ALUSrc   = zero; 
                MemtoReg = 0; // don't care
                RegDst   = 0; // don't care
                MemRead  = 0;
                MemWrite = 0; 
            end
        `OP_BLTZAL, `OP_BGEZAL,  `OP_JAL:
            begin
                RegWrite = 1;
                ALUSrc   = zero; 
                MemtoReg = pc_plus_8;
                RegDst   = GPR31; 
                MemRead  = 0;
                MemWrite = 0;
            end
        `OP_LUI:
            begin
                RegWrite = 1;
                ALUSrc   = imm; 
                MemtoReg = alu_res;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0; 
            end
        `OP_J, `OP_JR:
            begin
                RegWrite = 0;
                ALUSrc   = 0; //Don't care 
                MemtoReg = 0; //Don't care
                RegDst   = 0; //Don't care 
                MemRead  = 0;
                MemWrite = 0; 
            end
        `OP_LB, `OP_LBU, `OP_LH, `OP_LHU, `OP_LW: 
            begin
                ALUSrc   = imm; 
                //Mem -> Reg
                MemtoReg = dmem_data;
                RegWrite = 1;
                RegDst   = rt; 
                MemRead  = 1; 
                MemWrite = 0;
            end
        `OP_SB, `OP_SH, `OP_SW: 
            begin
                ALUSrc   = imm; 
                //Reg -> Mem
                MemtoReg = 0; //Don;t care
                RegWrite = 0;
                RegDst   = 0; //Don't care
                MemRead  = 0; 
                MemWrite = 1;
            end
        default: 
            begin
                $warning("%m: opcode not recognized: %06b", i_instruction[31:26]);
            end
        endcase
    end
endmodule  //control_unit
