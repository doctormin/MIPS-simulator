`timescale 1ns / 1ps
`include "ISA.v"

module branch_unit #(parameter W = 32)
                    (
                        input  [W-1:0]  i_alu_res,
                        input           i_alu_zero,
                        input  [W-1:0]  i_EX_instruction,
                        input  [W-1:0]  i_EX_rs,
                        input  [W-1:0]  i_EX_pc,
                        output reg          o_branch_taken,
                        output reg [W-1:0]  o_branch_des,
                        output              o_EX_isJR, 
                    );
    wire [`op]   opcode = `get_op(i_EX_instruction);
    wire is_BEQ  = (opcode == `OP_BEQ);
    wire is_BNE  = (opcode == `OP_BNE);
    wire is_BLEZ = (opcode == `OP_BLEZ);
    wire is_BGTZ = (opcode == `OP_BGTZ);
    wire [W-1:0] imm_after_signext;
    sign_extender #(.from(16), .to(32)) 
                    br_sign_extender
                    (
                        i_EX_instruction[15:0], 
                        imm_after_signext
                    );
    assign  o_EX_isJR   = `isJR(i_EX_instruction);
    assign  o_EX_rs     = i_EX_rs;
    always @(*) begin
        o_branch_taken  = 0;
        o_branch_des = (imm_after_signext << 2) + i_EX_pc + 4;
        if(is_BEQ && i_alu_zero == 1) 
            o_branch_taken = 1;
        if(is_BNE && i_alu_zero == 0)
            o_branch_taken = 1;
        if(is_BLEZ && i_alu_res == 1)
            o_branch_taken = 1;
        if(is_BGTZ && i_alu_res == 0)
            o_branch_taken = 1;
        if(opcode == `OP_REGIMM) begin
            case(i_EX_instruction[20:16])
                `BLTZAL, `BLTZ:
                    if(i_alu_res == 1)
                        o_branch_taken = 1;
                `BGEZ, `BGEZAL:
                    if(i_alu_res == 0)
                        o_branch_taken = 1;
                default:
                    $warning("branch unit -> opcode == `OP_REGIMM ->  exception\n");
            endcase
        end
    end
endmodule  //branch_unit