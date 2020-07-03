`timescale 1ns / 1ps
`include "ISA.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/03 20:56:04
// Design Name: 
// Module Name: forwarding unit
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
/**
 * 该模块选择ALU的两个运算数
 * 对于op1:
 *      1. rs
 *      2. sa
 *      3. forwarded_data
 * 对于op2:
 *      1. rt
 *      2. imm_extended
 *      3. 0
 *      4. forwarded_data
 */

module ALUSrc_selector #(parameter W = 32)
    (
        input      [W-1:0] i_instruction,
        input      [W-1:0] i_rs,
        input      [W-1:0] i_rt,
        input      [W-1:0] i_forwarded_data,
        input              i_rs_forward_signal,
        input              i_rt_forward_signal,
        output reg [W-1:0] o_alu_oprand1,
        output reg [W-1:0] o_alu_oprand2
    );
    wire [`op]   opcode = `get_op(i_instruction);
    wire [`fun]  fun    = `get_fun(i_instruction);
    wire [`sa]   sa     = `get_sa(i_instruction);
    wire [`imm]  imm    = `get_imm(i_instruction);
    wire [W-1:0] imm_signext;
    sign_extender #(.from(16), .to(32)) 
                    ALUSrc_sign_extender
                    (
                        .inst(imm), 
                        .data(imm_signext)
                    );
    wire [W-1:0] imm_zeroext = {{16{0}}, imm};

    //op1
    always @(*) begin
        case (opcode)
            `OP_R: 
                begin
                    case (fun)
                        `FUN_SLL, `FUN_SRL, `FUN_SRA: begin
                            o_alu_oprand1 = {{27{1'b0}}, sa};

                        end 
                        default:
                            o_alu_oprand1 = i_rs_forward_signal ? i_forwarded_data : i_rs;
                    endcase
                end
            default:
                o_alu_oprand1 = i_rs_forward_signal ? i_forwarded_data : i_rs;
        endcase
    end

    //op2
    always @(*) begin
        case (opcode)
            `OP_R, `OP_BEQ, `OP_BNE: 
                o_alu_oprand2 =  i_rt_forward_signal ? i_forwarded_data : i_rt;
            `OP_REGIMM, `OP_BGTZ, `OP_BLEZ: 
                o_alu_oprand2 = 0;
            `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_LB, `OP_LBU, `OP_LH, `OP_LHU, `OP_LW, `OP_SB, `OP_SH, `OP_SW: 
                o_alu_oprand2 = imm_signext;
            `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LUI: 
                o_alu_oprand2 = imm_zeroext;
            default:
                o_alu_oprand2 = {32{1'bx}};
        endcase
    end
endmodule  //ALUSrc_selector