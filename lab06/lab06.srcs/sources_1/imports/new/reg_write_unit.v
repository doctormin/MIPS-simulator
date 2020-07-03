`timescale 1ns / 1ps
`include "ISA.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/03 01:07:28
// Design Name: 
// Module Name: reg_write_unit
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
//本模块负责产生MemtoReg和RegDs和RegWrite信号
module reg_write_unit #
                (
                    parameter W = 32
                )
                (
                    input      [W-1:0] i_instruction,
                    output reg [1:  0] RegDst,
                    output reg [1:  0] MemtoReg,
                    output reg         RegWrite
                );
               //RegDst - Mux3to1
    localparam rt        = 2'b00,
               rd        = 2'b01,
               GPR31     = 2'b10;

    localparam //MemtoReg - Mux3to1
               alu_res   = 2'b00,
               dmem_data = 2'b01,
               pc_plus_8 = 2'b10;
    
    always @(*) begin
        case(`get_op(i_instruction)) 
        `OP_R: 
            begin
                RegWrite = 1;
                MemtoReg = alu_res;
                RegDst   = rd; 
            end     
        `OP_ADDI, `OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_SLTIU, `OP_LUI:
            begin
                RegWrite = 1;
                MemtoReg = alu_res;
                RegDst   = rt; 
            end
        `OP_BLTZAL, `OP_BGEZAL,  `OP_JAL:
            begin
                RegWrite = 1;
                MemtoReg = pc_plus_8;
                RegDst   = GPR31; 
            end
        `OP_LB, `OP_LBU, `OP_LH, `OP_LHU, `OP_LW:
            begin
                //Mem -> Reg
                MemtoReg = dmem_data;
                RegWrite = 1;
                RegDst   = rt; 
            end
        `OP_BEQ, `OP_BNE, `OP_BGTZ, `OP_BLEZ, `BGEZ, `BLTZ, `OP_J, `OP_JR, `OP_SB, `OP_SH, `OP_SW:
            begin
                RegWrite = 0;
                MemtoReg = 0; // don't care
                RegDst   = 0; // don't care                
            end
        default: 
            begin
                $warning("%m: reg_write_unit -> opcode not recognized: %06b", `get_op(i_instruction));
            end
        endcase
    end

endmodule  //reg_write_unit
