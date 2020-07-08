`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 13:00:23
// Design Name: 
// Module Name: ALU_decoder
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

module ALU_decoder	#(
                        parameter ADDRESS_WIDTH = 32,
                        parameter DATA_WIDTH = 32
				     )
                     (
                        input [DATA_WIDTH-1:0] i_instruction,
                        output reg [3:0] o_alu_ctr
                     );
    localparam ALU_ADD   = 0,
               ALU_ADDU  = 1,
               ALU_SUB   = 2,
               ALU_SUBU  = 3,
               ALU_AND   = 4,
               ALU_OR    = 5,
               ALU_XOR   = 6,
               ALU_NOR   = 7,
               ALU_SLL   = 8,
               ALU_SRL   = 9,
               ALU_SRA   = 10,
               ALU_SLT   = 11,
               ALU_SLTU  = 12,
               ALU_SLE   = 13,
               ALU_LUI   = 14,
               ALU_NO    = 15;

    always @(*) begin
        case(i_instruction[31:26]) //opcode
        `OP_R: 
            begin  
                case(i_instruction[5:0])
                    `FUN_ADD:
                        begin
                            o_alu_ctr = ALU_ADD;
                        end
                    `FUN_ADDU:
                        begin
                            o_alu_ctr = ALU_ADDU;
                        end
                    `FUN_SUB:
                        begin
                            o_alu_ctr = ALU_SUB;
                        end 
                    `FUN_SUBU:
                        begin
                            o_alu_ctr = ALU_SUBU;
                        end  
                    `FUN_AND:
                        begin
                            o_alu_ctr = ALU_AND;
                        end 
                    `FUN_OR:
                        begin
                            o_alu_ctr = ALU_OR;
                        end
                    `FUN_NOR:
                        begin
                            o_alu_ctr = ALU_NOR;
                        end
                    `FUN_XOR:
                        begin
                            o_alu_ctr = ALU_XOR;
                        end
                    `FUN_SLL, `FUN_SLLV, `FUN_NOOP:
                        begin
                            o_alu_ctr = ALU_SLL;
                        end   
                    `FUN_SRL, `FUN_SRLV:
                        begin
                            o_alu_ctr = ALU_SRL;
                        end
                    `FUN_SRA, `FUN_SRAV:
                        begin
                            o_alu_ctr = ALU_SRA;
                        end
                    `FUN_SLT:
                        begin
                            o_alu_ctr = ALU_SLT;
                        end
                    `FUN_SLTU:
                        begin
                            o_alu_ctr = ALU_SLTU;
                        end
                    `FUN_JR:
                        begin
                            o_alu_ctr = ALU_NO;
                        end  
                    default: 
                        begin
                            $warning("%m: fun not recognized: %06b", i_instruction[5:0]);
                        end
                endcase
            end
        `OP_ADDI:
            begin
                o_alu_ctr = ALU_ADD;
            end
        `OP_ADDIU:
            begin
                o_alu_ctr = ALU_ADDU;
            end
        `OP_ANDI:
            begin
                o_alu_ctr = ALU_AND;
            end
        `OP_ORI:
            begin
                o_alu_ctr = ALU_OR;
            end
        `OP_XORI:
            begin
                o_alu_ctr = ALU_XOR;
            end
        `OP_SLTI:
            begin
                o_alu_ctr = ALU_SLT;
            end
        `OP_SLTIU:
            begin
                o_alu_ctr = ALU_SLTU;
            end
        `OP_BEQ, `OP_BNE:
            begin
                o_alu_ctr = ALU_SUBU;
            end
        `OP_BLTZ, `OP_BLTZAL, `OP_BGEZ, `OP_BGEZAL:
            begin
                o_alu_ctr = ALU_SLT;    
            end
        `OP_BGTZ, `OP_BLEZ:
            begin
                o_alu_ctr = ALU_SLE;
            end
        `OP_LUI:
            begin
                o_alu_ctr = ALU_LUI;
            end
        `OP_J, `OP_JAL:
            begin
                o_alu_ctr = ALU_NO;
            end
        `OP_LB, `OP_LBU, `OP_LH, `OP_LHU, `OP_LW, `OP_SB, `OP_SH, `OP_SW:
            begin
                o_alu_ctr = ALU_ADDU;
            end
        default: 
            begin
                $warning("%m: opcode not recognized: %06b", i_instruction[31:26]);
            end
        endcase
    end
endmodule  //ALU_decoder
