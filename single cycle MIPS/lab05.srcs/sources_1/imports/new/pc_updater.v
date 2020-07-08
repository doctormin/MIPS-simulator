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
                    input      [ADDRESS_WIDTH-1:0] i_instruction, // J / JAL 
                    input      [ADDRESS_WIDTH-1:0] i_branch_offset,
                    input      [ADDRESS_WIDTH-1:0] i_rs,      //JR:new_pc = rs 
                    input      [ADDRESS_WIDTH-1:0] i_alu_res, //ALU的结果，用于ALU_SLT和ALU_SLE
                    input                          i_alu_zero, //用于beq & bne

                    output reg [ADDRESS_WIDTH-1:0] o_new_pc
                );
wire [ADDRESS_WIDTH-1:0] pc_plus_4;
wire [ADDRESS_WIDTH-1:0] branch_des;
wire                     pc_updater_OF;
adder #(ADDRESS_WIDTH) pc_adder  (i_pc_old, 32'h0000004, pc_plus_4, pc_updater_OF);
adder #(ADDRESS_WIDTH) br_adder  (pc_plus_4, i_branch_offset, branch_des, pc_updater_OF);

always @(*) begin
    case(i_instruction[31:26]) //opcode
        `OP_BEQ:
            begin
                if(i_alu_zero == 1) begin
                   o_new_pc = branch_des;
                   $display("OP_BEQ : o_new_pc = branch_des = %h\n",  branch_des);
                end
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BNE:
            begin
                if(i_alu_zero == 0) begin
                   o_new_pc = branch_des;
                   $display("OP_BNE : o_new_pc = branch_des = %h\n",  branch_des);
                end
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BLTZAL, `OP_BGEZAL, `OP_BGEZ, `OP_BLTZ: //这四个opcode相同
            begin
                case(i_instruction[20:16])
                    `BLTZAL, `BLTZ:
                        begin
                            if(i_alu_res == 1) begin
                                o_new_pc = branch_des;
                                $display("BLTZAL, BLTZ: : o_new_pc = branch_des = %h\n",  branch_des);
                            end
                            else
                                o_new_pc = pc_plus_4;
                        end
                    `BGEZ, `BGEZAL:
                        begin
                            if(i_alu_res == 0) begin
                                o_new_pc = branch_des; 
                                $display("`BGEZ, `BGEZAL : o_new_pc = %h\n",  branch_des);
                            end
                            else
                                o_new_pc = pc_plus_4;
                        end 
                endcase
            end
        `OP_BLEZ:
            begin
                if(i_alu_res == 1) begin
                    o_new_pc = branch_des;
                    $display("`OP_BLEZ : o_new_pc = branch_des = %h\n",  branch_des);
                end
                else
                    o_new_pc = pc_plus_4;
            end
        `OP_BGTZ: 
            begin
                if(i_alu_res == 0) begin
                   o_new_pc = branch_des; 
                   $display("`OP_BGTZ : o_new_pc = %h\n",  branch_des);
                end
                else
                    o_new_pc = pc_plus_4;
            end    
        `OP_J, `OP_JAL: begin
            o_new_pc = {i_pc_old[ADDRESS_WIDTH-1:ADDRESS_WIDTH-4], i_instruction[25:0], 2'b00};
            $display("`OP_J, `OP_JAL : o_new_pc = {i_pc_old[ADDRESS_WIDTH-1:ADDRESS_WIDTH-4], i_instruction[25:0], 2'b00} = %h\n", o_new_pc); 
        end
        `OP_R: begin
            case(i_instruction[5:0])
                `FUN_JR:
                    begin
                        o_new_pc = i_rs;
                        $display("OP_JR : o_new_pc = i_rs = %h\n",  i_rs);     
                    end
                 default:
                    begin
                        o_new_pc = pc_plus_4;
                        $display("R-ALU : o_new_pc = pc_plus_4 = %h\n",  pc_plus_4); 
                    end
            endcase
        end
        default: 
            o_new_pc = pc_plus_4;
    endcase  
end

endmodule  //pc_updater