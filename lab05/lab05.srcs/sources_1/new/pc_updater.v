`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 10:30:06
// Design Name: 
// Module Name: pc_updater
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

module pc_updater #
                (
                    parameter ADDRESS_WIDTH    = 32
                )
                (
                    input      [ADDRESS_WIDTH-1:0] i_pc_old,
                    input      [ADDRESS_WIDTH-1:0] i_instruction,
                    input      [ADDRESS_WIDTH-1:0] i_branch_offset,
                    input      [ADDRESS_WIDTH-1:0] i_rs,      //JAL : new_pc = rs
                    input      [ADDRESS_WIDTH-1:0] i_alu_res, //ALU的结果，用于ALU_SLT和ALU_SLE
                    input                          i_alu_zero, //用于beq & bne

                    output reg [ADDRESS_WIDTH-1:0] o_new_pc
                );
reg [ADDRESS_WIDTH-1:0] pc_plus_4;
reg [ADDRESS_WIDTH-1:0] pc_plus_8;
reg [ADDRESS_WIDTH-1:0] branch_des;


adder #(ADDRESS_WIDTH) pc_adder  (i_pc_old, 32'h0004, pc_plus_4, 0);
adder #(ADDRESS_WIDTH) jal_adder (i_pc_old, 32'h0008, pc_plus_8, 0);
adder #(ADDRESS_WIDTH) br_adder  (pc_plus_4, i_branch_offset, branch_des, 0);

always @(*) begin
    case(i_instruction[31:26]) //opcode
        `OP_BEQ:
            begin
                if(i_alu_zero == 1)
                    o_new_pc = branch_des;
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BNE:
            begin
                if(i_alu_zero == 0)
                    o_new_pc = branch_des;
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BLTZ, `OP_BLEZ, `OP_BLTZAL:
            begin
                if(i_alu_res == 1)
                    o_new_pc = branch_des;
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BGEZ, `OP_BGTZ, `OP_BGEZAL:
            begin
                if(i_alu_res == 0)
                    o_new_pc = branch_des;
                else
                    o_new_pc = pc_plus_4;
            end    
        `OP_J, `OP_JAL:
            o_new_pc = {i_pc_old[ADDRESS_WIDTH-1:ADDRESS_WIDTH-4], i_instruction[25:0], 2'b00};
        `OP_JR:
            o_new_pc = i_rs;
        default: 
            o_new_pc = pc_plus_4;
    endcase  
end

endmodule  //pc_updater