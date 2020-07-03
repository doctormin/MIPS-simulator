`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 12:06:08
// Design Name: 
// Module Name: CPU
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

module CPU #(
                parameter W = 32,
                parameter REG_ADDRESS_WIDTH = 5
            )
            (
                input  clk,
                input  reset,
                input  [W-1:0]    IF_instruction,
                input  [W-1:0]    i_cpu_dmem_read_data,
                output [W-1:0] o_cpu_pc,              //CPU->instruction mem的pc
                output [W-1:0]    o_cpu_dmem_addr,       //CPU->data mem的访问地�?
                output [W-1:0]    o_cpu_dmem_write_data, //CPU->data mem的写入数�?
                output [1:0]               o_cpu_dmem_mode,
                output                     o_cpu_MemWrite,
                output                     o_cpu_MemRead
            );
    //=====IF====
    reg  [W-1:0] IF_pc;
    wire [W-1:0] IF_new_pc;
    wire         flush_ID_EX;
    wire         flush_IF_ID;
    //=====ID====
    wire [W-1:0] ID_instruction;
    wire [W-1:0] ID_pc;
    wire flush;
    wire [W-1:0] ID_reg_read_rs;
    wire [W-1:0] ID_reg_read_rt;
    //=====EX=====
    wire [W-1:0] EX_instruction;
    wire [W-1:0] EX_pc;
    wire [W-1:0] EX_rs;
    wire [W-1:0] EX_rt;
    wire [W-1:0] EX_branch_des;   //branch的目的地
    wire [W-1:0] EX_imm_extended;  //imm经过extend之后的结果
    wire [W-1:0] EX_alu_oprand1;
    wire [W-1:0] EX_alu_oprand2;
    wire [W-1:0] EX_alu_res;
    wire [4  :0] EX_alu_ctr;
    wire         EX_alu_zero;
    wire         EX_branch_taken;
    wire         EX_isJR;
    //=====MEM====
    wire [W-1:0] MEM_instruction;
    wire [W-1:0] MEM_pc;
    //=====WB=====
    wire [W-1:0] WB_instruction;
    wire [W-1:0] WB_pc;
    wire [W-1:0] WB_dmem_read_data;
    wire [W-1:0] WB_reg_write_data;
    wire [W-1:0] WB_reg_write_addr;
    //===Control Signals===
    wire [1:0]   RegDst;
    wire [1:0]   MemtoReg;
    wire         RegWrite;

    //--------------cycle start--------------
    always @(negedge clk) IF_pc = IF_new_pc;
    //--------------IF BEGIN------------------
    pc_updater  #(W)
                cpu_pc_updater
                (
                    .i_pc_old(IF_pc),
                    .stall(stall),
                    .i_IF_instruction(IF_instruction),
                    .i_EX_isJR(EX_isJR), 
                    .i_EX_rs(EX_rs),  
                    .i_EX_branch_taken(EX_branch_taken),
                    .i_EX_branch_des(EX_branch_des),
                    .o_new_pc(IF_new_pc),
                    .flush_ID_EX(flush_ID_EX),
                    .flush_IF_ID(flush_IF_ID)
                );
    //--------------IF END--------------------
    IF_ID   #(W) 
            cpu_IF_ID
            (
                .clk(clk),
                .flush(flush_IF_ID), //如果为高电平，则清空本寄存器
                .i_IF_pc(IF_pc),
                .i_IF_instruction(IF_instruction),
                .o_ID_pc(ID_pc),
                .o_ID_instruction(ID_instruction)
            );
    //--------------ID BEGIN------------------
    register_file  #(W, REG_ADDRESS_WIDTH)
                   cpu_register_file
                   (
                       .clk(clk),
                       .reset(reset),
                       .i_read_addr1(`get_rs(ID_instruction)),
                       .i_read_addr2(`get_rt(ID_instruction)),
                       .i_write_data(WB_reg_write_data),
                       .i_write_addr(WB_reg_write_addr),
                       .i_RegWrite(RegWrite),
                       .o_read_rs(EX_rs),
                       .o_read_rt(EX_rt)
                   );
    //--------------ID END--------------------
    ID_EX   #(W) 
            cpu_ID_EX
            (
                .clk(clk),
                .flush(flush_ID_EX), //如果为高电平，则清空本寄存器
                .i_ID_rs(ID_reg_read_rs),
                .i_ID_rt(ID_reg_read_rt),
                .i_ID_pc(ID_pc),
                .i_ID_instruction(ID_instruction),
                .o_EX_pc(EX_pc),
                .o_EX_instruction(EX_instruction),
                .o_EX_rs(EX_rs),
                .o_EX_rt(EX_rt)
            );
    //-------------EX BEGIN--------------------
    ALU_decoder #(W)
        cpu_ALU_decoder
        (
            .i_instruction(EX_instruction),
            .o_alu_ctr(EX_alu_ctr)
        );
    ALU #(W)
        cpu_ALU
        (
            .i_oprand1(EX_alu_oprand1),
            .i_oprand2(EX_alu_oprand2),
            .i_alu_c(EX_alu_ctr), 
            .o_zero(EX_alu_zero),
            .o_alu_res(EX_alu_res)
        );
    branch_unit #(W)
        cpu_branch_unit
        (
            .i_alu_res(EX_alu_res),
            .i_alu_zero(EX_alu_zero),
            .i_EX_instruction(EX_instruction),
            .i_EX_rs(EX_rs),
            .i_EX_pc(EX_pc),
            .o_branch_taken(EX_branch_taken),
            .o_branch_des(EX_branch_des),
            .o_EX_isJR(EX_isJR)
        );
    //-------------EX END----------------------

    //-------------MEM BEGIN-------------------
    //-------------MEM END---------------------
    //-------------WB BEGIN--------------------
    //-------------WB BEGIN--------------------
    //=============Control Signals================
    reg_write_unit    #(W)
                    cpu_reg_write_unit
                    (
                        .i_WB_instruction(WB_instruction),
                        .RegDst(RegDst),
                        .MemtoReg(MemtoReg),
                        .RegWrite(RegWrite)
                    );
    //===选择写入寄存器的地址===
    mux3to1       #(W)
                  reg_write_addr_mux
                  (
                    .i_option0(`get_rt(WB_instruction)), //rt
                    .i_option1(`get_rd(WB_instruction)), //rd
                    .i_option2(`GPR31),                  //GRP[31] <- pc + 8
                    .i_select(RegDst),
                    .o_choice(WB_reg_write_addr)
                  );
    //===选择写入寄存器的值===            
    mux3to1       #(W)
                  reg_write_data_muxi_WB_
                  ( 
                    .i_option0(WB_alu_res),
                    .i_option1(WB_dmem_read_data),
                    .i_option2(WB_pc + 8),
                    .i_select(MemtoReg),
                    .o_choice(WB_reg_write_data)
                  );
    //选择ALU的两个运算数
    ALUSrc_selector
        #(W)
            
    
endmodule  //CPU