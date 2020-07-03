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
            )
            (
                input  clk,
                input  reset,
                input  [W-1:0]    i_cpu_instruction,
                input  [W-1:0]    i_cpu_dmem_read_data,
                output [W-1:0]    o_cpu_pc,              //CPU->instruction mem的pc
                output [W-1:0]    o_cpu_dmem_addr,       //CPU->data mem的访问地址?
                output [W-1:0]    o_cpu_dmem_write_data, //CPU->data mem的写入数据?
                output [1:0]      o_cpu_dmem_mode,
                output            o_cpu_MemWrite,
                output            o_cpu_MemRead
            );
    //=====IF====
    reg  [W-1:0] IF_pc;
    wire [W-1:0] IF_new_pc;
    wire [W-1:0] IF_instruction;
    //=====ID====
    wire [W-1:0] ID_instruction;
    wire [W-1:0] ID_pc;
    wire [W-1:0] ID_reg_read_rs;
    wire [W-1:0] ID_reg_read_rt;
    //=====EX=====
    wire [W-1:0] EX_instruction;
    wire [W-1:0] EX_pc;
    wire [W-1:0] EX_rs;
    wire [W-1:0] EX_rt;
    wire [W-1:0] EX_branch_des;    //branch的目的地
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
    wire [W-1:0] MEM_rt;
    wire [W-1:0] MEM_alu_res;
    wire [W-1:0] MEM_dmem_read_data;
    wire [W-1:0] MEM_dmem_write_data; //1.来自rt, 2.来自转发
    wire [W-1:0] MEM_reg_write_data;
    wire [`reg]  MEM_reg_write_addr;
    //=====WB=====
    wire [W-1:0] WB_instruction;
    wire [W-1:0] WB_pc;
    wire [W-1:0] WB_dmem_read_data;
    wire [W-1:0] WB_reg_write_data;
    wire [`reg]  WB_reg_write_addr;
    //===Control Signals===
    wire         flush;
    wire         flush_ID_EX;
    wire         flush_IF_ID;
    //data memory相关
    wire         MemRead;
    wire         MemWrite;
    wire [1:0]   MemMode;          //0:word    1:half word   2: byte  
    //寄存器相关
    wire         MEM_RegWrite;
    wire         WB_RegWrite;
    wire [1:0]   MEM_RegDst;
    wire [1:0]   MEM_MemtoReg;
    //forwarding unit
    wire         rs_forward_signal;
    wire         rt_forward_signal;
    wire         mem_forward_signal;
    wire [W-1:0] forwarded_data;

    //--------------cycle start--------------
    always @(negedge clk) IF_pc = IF_new_pc;
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
    //--------------IF BEGIN------------------
    assign o_cpu_pc       = IF_pc;
    assign IF_instruction = i_cpu_instruction;
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
    register_file  #(W, 5)
                   cpu_register_file
                   (
                       .clk(clk),
                       .reset(reset),
                       .i_read_addr1(`get_rs(ID_instruction)),
                       .i_read_addr2(`get_rt(ID_instruction)),
                       .i_write_data(WB_reg_write_data),
                       .i_write_addr(WB_reg_write_addr),
                       .i_RegWrite(WB_RegWrite),
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
            .i_EX_pc(EX_pc),
            .o_branch_taken(EX_branch_taken),
            .o_branch_des(EX_branch_des),
            .o_EX_isJR(EX_isJR)
        );
    //-------------EX END----------------------
    EX_MEM  #(W)
        cpu_EX_MEM
        (
            .clk(clk),
            .i_EX_instruction(EX_instruction),
            .i_EX_pc(EX_pc),
            .i_EX_alu_res(EX_alu_res), 
            .i_EX_rt(EX_rt),
            .o_MEM_instruction(MEM_instruction),
            .o_MEM_alu_res(MEM_alu_res),
            .o_MEM_pc(MEM_pc),
            .o_MEM_rt(MEM_rt)
        );
    //-------------MEM BEGIN-------------------
    assign o_cpu_dmem_mode       = MemMode;
    assign o_cpu_MemWrite        = MemWrite;
    assign o_cpu_MemRead         = MemRead;
    assign MEM_dmem_write_data   = mem_forward_signal ? forwarded_data : MEM_rt; //处理ALU + sx的情况
    assign o_cpu_dmem_write_data = MEM_dmem_write_data;
    assign o_cpu_dmem_addr       = MEM_alu_res;
    assign MEM_dmem_read_data    = i_cpu_dmem_read_data;
    //-------------MEM END---------------------
    MEM_WB  #(W)
        cpu_MEM_WB
        (
            .clk(clk),
            .i_MEM_instruction(MEM_instruction),
            .i_MEM_pc(MEM_pc),
            .i_MEM_dmem_read_data(MEM_dmem_read_data),
            .i_MEM_alu_res(MEM_alu_res),
            .i_MEM_RegWrite(MEM_RegWrite),
            .i_MEM_reg_write_addr(MEM_reg_write_addr),
            .i_MEM_reg_write_data(MEM_reg_write_data),

            .o_WB_instruction(WB_instruction),
            .o_WB_pc(WB_pc),
            .o_WB_dmem_read_data(WB_dmem_read_data),
            .o_WB_alu_res(WB_alu_res),
            .o_WB_RegWrite(WB_RegWrite),
            .o_WB_reg_write_addr(WB_reg_write_addr),
            .o_WB_reg_write_data(WB_reg_write_data)
        );
    //-------------WB BEGIN--------------------
    //-------------WB END----------------------
    //=============Control================
    //===决定MemRead、MemWrite和MemMode信号===
    dmem_access_unit    
        #(W)
        cpu_dmem_access_unit
        (
            .i_MEM_instruction(MEM_instruction),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .mode(MemMode)
        );
    //===决定MemtoReg和RegWrite信号===
    reg_write_unit  #(W)
        cpu_reg_write_unit
        (
            .i_instruction(MEM_instruction),
            .RegDst(MEM_RegDst),
            .MemtoReg(MEM_MemtoReg),
            .RegWrite(MEM_RegWrite)
        );
    //===选择写入寄存器的地址===
    mux3to1 #(5)
        reg_write_addr_mux
        (
            .i_option0(`get_rt(MEM_instruction)), //rt
            .i_option1(`get_rd(MEM_instruction)), //rd
            .i_option2(`GPR31),                  //GRP[31] <- pc + 8
            .i_select(MEM_RegDst),
            .o_choice(MEM_reg_write_addr)
        );
    //===选择写入寄存器的值===            
    mux3to1 #(W)
        reg_write_data_mux
        ( 
            .i_option0(MEM_alu_res),
            .i_option1(MEM_dmem_read_data),     //SB SH SW
            .i_option2(MEM_pc + 8),             //JAL BXXAL
            .i_select(MEM_MemtoReg),
            .o_choice(MEM_reg_write_data)
        );
    //===选择ALU的两个运算数===
    ALUSrc_selector
        #(W)
        cpu_ALUSrc_selector
        (

        );
    //===Forward Unit===
    forwarding_unit #(W)
        cpu_forwarding_unit
        (
            .i_EX_instruction(EX_instruction),
            .i_WB_reg_write_data(WB_reg_write_data), 
            .i_MEM_reg_write_data(MEM_reg_write_data),    
            .i_WB_reg_write_addr(WB_reg_write_addr), 
            .i_MEM_reg_write_addr(MEM_reg_write_addr),  
            .i_WB_RegWrite(WB_RegWrite),       
            .i_MEM_RegWrite(MEM_RegWrite),

            .o_forwarded_data(forwarded_data),
            .o_rs_forward_signal(rs_forward_signal),        //高电平意味着forward data到ALU op1
            .o_rt_forward_signal(rt_forward_signal),        //高电平意味着forward data到ALU op2
            .o_mem_forward_signal(mem_forward_signal)
        );
    
endmodule  //CPU