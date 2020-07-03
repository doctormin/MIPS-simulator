`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 15:32:18
// Design Name: 
// Module Name: ISA
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

`define OP_R     6'b000000
`define OP_ADD   6'b000000
`define OP_ADDI  6'b001000
`define OP_ADDIU 6'b001001
`define OP_ADDU  6'b000000
`define OP_SUB   6'b000000
`define OP_SUBU  6'b000000
`define OP_AND   6'b000000
`define OP_ANDI  6'b001100
`define OP_OR    6'b000000
`define OP_ORI   6'b001101
`define OP_NOR   6'b000000
`define OP_XOR   6'b000000
`define OP_XORI  6'b001110
`define OP_SLL   6'b000000
`define OP_SLLV  6'b000000
`define OP_SRL   6'b000000
`define OP_SRLV  6'b000000
`define OP_SRA   6'b000000
`define OP_SRAV  6'b000000
`define OP_SLT   6'b000000
`define OP_SLTI  6'b001010
`define OP_SLTIU 6'b001011
`define OP_SLTU  6'b000000
`define OP_BEQ   6'b000100
`define OP_BGTZ  6'b000111
`define OP_BLEZ  6'b000110
`define OP_BNE   6'b000101
`define OP_LUI   6'b001111
`define OP_J     6'b000010
`define OP_JAL   6'b000011
`define OP_JR    6'b000000
`define OP_LB    6'b100000
`define OP_LBU   6'b100100
`define OP_LH    6'b100001
`define OP_LHU   6'b100101
`define OP_LW    6'b100011
`define OP_SB    6'b101000
`define OP_SH    6'b101001
`define OP_SW    6'b101011
`define OP_NOOP  6'b000000

`define FUN_ADD  6'b100000
`define FUN_ADDU 6'b100001
`define FUN_SUB  6'b100010
`define FUN_SUBU 6'b100011
`define FUN_AND  6'b100100
`define FUN_OR   6'b100101
`define FUN_NOR  6'b100111
`define FUN_XOR  6'b100110
`define FUN_SLL  6'b000000
`define FUN_SLLV 6'b000100
`define FUN_SRL  6'b000010
`define FUN_SRLV 6'b000110
`define FUN_SRA  6'b000011
`define FUN_SRAV 6'b000111
`define FUN_SLT  6'b101010
`define FUN_SLTU 6'b101011
`define FUN_JR   6'b001000
`define FUN_NOOP 6'b000000

`define BGEZ     5'b00001
`define BGEZAL   5'b10001
`define BLTZ     5'b00000
`define BLTZAL   5'b10000
`define OP_REGIMM 6'b000001
`define OP_BGEZ   6'b000001
`define OP_BGEZAL 6'b000001
`define OP_BLTZ   6'b000001
`define OP_BLTZAL 6'b000001

`define get_op(instruction)     instruction[31:26]
`define get_rs(instruction)     instruction[25:21]
`define get_rt(instruction)     instruction[20:16]
`define get_rd(instruction)     instruction[15:11]
`define get_sa(instruction)     instruction[10: 6]
`define get_fun(instruction)    instruction[ 5: 0]
`define get_imm(instruction)    instruction[15: 0]
`define get_j(instruction)      instruction[25: 0]

`define op     5:0
`define reg    4:0
`define fun    5:0
`define imm    15:0
`define sa     4:0
`define GPR31 5'b11111

`define isStore(i)          `get_op(i) == `OP_SB||`get_op(i) == `OP_SW||`get_op(i) == `OP_SH
`define isLoad(i)           `get_op(i) == `OP_LB||`get_op(i) == `OP_LBU||`get_op(i) == `OP_LH||`get_op(i) == `OP_LHU||`get_op(i) == `OP_LW  
`define isJump(instruction) `get_op(instruction) == `OP_J 
`define isJAL(instruction)  `get_op(instruction) == `OP_JAL 
`define isJR(instruction)   `get_op(instruction) == `OP_JR && `get_fun(instruction) == `FUN_JR
`define writeRT(i)          `isLoad(i)||`get_op(i) == `OP_LUI||`get_op(i) == `OP_SLTI||`get_op(i) == `OP_SLTIU
`define writeRD(i)          (`get_op(i)==`OP_R && (`get_fun(i)!=`FUN_JR))||`get_op(i)==`OP_ADDI||`get_op(i)==`OP_ADDIU||`get_op(i)==`OP_ANDI||`get_op(i)==`OP_ORI||`get_op(i)==`OP_XORI