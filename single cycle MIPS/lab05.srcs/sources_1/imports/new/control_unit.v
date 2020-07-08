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
                    input  [DATA_WIDTH-1   :0] i_instruction,
                    output reg MemRead,
                    output reg MemWrite,
                    output reg [1:0] mode,      //0:word    1:half word   2: byte
                    output reg [1:0] MemtoReg,  //0:alu_res 1:dmem_data   2:pc + 8
                    output reg       ALUSrc1,   //0:rs      1:sa, 即instruction[10:6]
                    output reg [1:0] ALUSrc2,   //0:rt      1:imm         2:zero
                    output reg       RegWrite,
                    output reg [1:0] RegDst     //0:rt      1:rd          2:pc+8
                );

               //RegDst - Mux3to1
    localparam rt        = 2'b00,
               rd        = 2'b01,
               GPR31     = 2'b10,
               //AUSrc2 - Mux3to1
               imm       = 2'b01,
               zero      = 2'b10,
               //MemtoReg - Mux3to1
               alu_res   = 2'b00,
               dmem_data = 2'b01,
               pc_plus_8 = 2'b10,
               //ALUSrc1 - Mux2to1
               rs        = 0,
               sa        = 1,
               //mode
               word      = 2'b00,
               half_word = 2'b01,
               B         = 2'b10;

    always @(*) begin
        case(i_instruction[31:26]) //opcode
        `OP_R: 
            case(i_instruction[5:0])
                `FUN_SLL, `FUN_SRL, `FUN_SRA:
                    begin
                        RegWrite = 1;
                        ALUSrc1  = sa;
                        ALUSrc2   = rt; 
                        MemtoReg = alu_res;
                        RegDst   = rd; 
                        MemRead  = 0;
                        MemWrite = 0;
                        mode     = word;
                    end
                default:
                    begin
                        RegWrite = 1;
                        ALUSrc1  = rs;
                        ALUSrc2   = rt; 
                        MemtoReg = alu_res;
                        RegDst   = rd; 
                        MemRead  = 0;
                        MemWrite = 0;
                        mode     = word;
                    end
            endcase
        `OP_ADDI, `OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_SLTIU:
            begin
                RegWrite = 1;
                ALUSrc1  = rs;
                ALUSrc2   = imm; 
                MemtoReg = alu_res;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0;
                mode     = word;
            end
        `OP_BEQ, `OP_BNE:
            begin
                RegWrite = 0;
                ALUSrc1  = rs;
                ALUSrc2   = rt; 
                MemtoReg = 0; // don't care
                RegDst   = 0; // don't care
                MemRead  = 0;
                MemWrite = 0;
                mode     = word;                 
            end
        `OP_BGTZ, `OP_BLEZ:
            begin
                RegWrite = 0;
                ALUSrc1  = rs;
                ALUSrc2   = zero; 
                MemtoReg = 0; // don't care
                RegDst   = 0; // don't care
                MemRead  = 0;
                MemWrite = 0; 
                mode     = word;
            end
        `OP_BLTZAL, `OP_BGEZAL,  `OP_JAL, `OP_BGEZ, `OP_BLTZ:
            case(i_instruction[20:16])
                `BLTZAL, `BGEZAL:
                    begin
                        RegWrite = 1;
                        ALUSrc1  = rs;
                        ALUSrc2   = zero; 
                        MemtoReg = pc_plus_8;
                        RegDst   = GPR31; 
                        MemRead  = 0;
                        MemWrite = 0;
                        mode     = word;
                    end
                `BGEZ, `BLTZ:
                    begin
                        RegWrite = 0;
                        ALUSrc1  = rs;
                        ALUSrc2   = zero; 
                        MemtoReg = 0; // don't care
                        RegDst   = 0; // don't care
                        MemRead  = 0;
                        MemWrite = 0; 
                        mode     = word;
                    end
                default: //JAL
                    begin
                        RegWrite = 1;
                        ALUSrc1  = rs;
                        ALUSrc2   = zero; 
                        MemtoReg = pc_plus_8;
                        RegDst   = GPR31; 
                        MemRead  = 0;
                        MemWrite = 0;
                        mode     = word;
                    end
            endcase
            
        `OP_LUI:
            begin
                RegWrite = 1;
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                MemtoReg = alu_res;
                RegDst   = rt; 
                MemRead  = 0;
                MemWrite = 0;
                mode     = word; 
            end
        `OP_J, `OP_JR:
            begin
                RegWrite = 0;
                ALUSrc1  = rs; //Don't care
                ALUSrc2  = 0; //Don't care 
                MemtoReg = 0; //Don't care
                RegDst   = 0; //Don't care 
                MemRead  = 0;
                MemWrite = 0;
                mode     = word; 
            end
        `OP_LB, `OP_LBU:
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Mem -> Reg
                MemtoReg = dmem_data;
                RegWrite = 1;
                RegDst   = rt; 
                MemRead  = 1; 
                MemWrite = 0;
                mode     = B;
            end
        `OP_LH, `OP_LHU: 
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Mem -> Reg
                MemtoReg = dmem_data;
                RegWrite = 1;
                RegDst   = rt; 
                MemRead  = 1; 
                MemWrite = 0;
                mode     = half_word;
            end
        `OP_LW:
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Mem -> Reg
                MemtoReg = dmem_data;
                RegWrite = 1;
                RegDst   = rt; 
                MemRead  = 1; 
                MemWrite = 0;
                mode     = word;
            end
        `OP_SB:
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Reg -> Mem
                MemtoReg = 0; //Don;t care
                RegWrite = 0;
                RegDst   = 0; //Don't care
                MemRead  = 0; 
                MemWrite = 1;
                mode     = B;
            end
        `OP_SH:
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Reg -> Mem
                MemtoReg = 0; //Don;t care
                RegWrite = 0;
                RegDst   = 0; //Don't care
                MemRead  = 0; 
                MemWrite = 1;
                mode     = half_word;
            end
        `OP_SW: 
            begin
                ALUSrc1  = rs;
                ALUSrc2  = imm; 
                //Reg -> Mem
                MemtoReg = 0; //Don;t care
                RegWrite = 0;
                RegDst   = 0; //Don't care
                MemRead  = 0; 
                MemWrite = 1;
                mode     = word;
            end
        default: 
            begin
                $warning("%m: opcode not recognized: %06b", i_instruction[31:26]);
            end
        endcase
    end
endmodule  //control_unit
