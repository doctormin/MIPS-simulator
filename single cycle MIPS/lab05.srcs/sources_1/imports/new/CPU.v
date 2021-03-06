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
                parameter ADDRESS_WIDTH     = 32,
                parameter DATA_WIDTH        = 32,
                parameter REG_ADDRESS_WIDTH = 5
            )
            (
                input  clk,
                input  reset,
                input  [DATA_WIDTH-1:0]    i_cpu_instruction,
                input  [DATA_WIDTH-1:0]    i_cpu_dmem_read_data,
                output [ADDRESS_WIDTH-1:0] o_cpu_pc,              //CPU->instruction mem的pc
                output [DATA_WIDTH-1:0]    o_cpu_dmem_addr,       //CPU->data mem的访问地�?
                output [DATA_WIDTH-1:0]    o_cpu_dmem_write_data, //CPU->data mem的写入数�?
                output [1:0]               o_cpu_dmem_mode,
                output                     o_cpu_MemWrite,
                output                     o_cpu_MemRead
            );

    //ALU
    wire [DATA_WIDTH-1:0]      alu_oprand1;
    wire [DATA_WIDTH-1:0]      alu_oprand2;
    wire [DATA_WIDTH-1:0]      alu_res;
    wire [3:0]                 alu_ctr;
    wire                       alu_zero;
    //Instruction Mem
    wire [DATA_WIDTH-1:0]      instruction;
    //PC
    reg  [ADDRESS_WIDTH-1:0]   pc;   //在上升沿，pc <- new_pc, 如果是reset上升沿，那么 pc <- 0
    wire [ADDRESS_WIDTH-1:0]   pc_plus_8; //用于JAL & BLTZAL & BGEZAL 更新GPR[31]
    wire [ADDRESS_WIDTH-1:0]   new_pc;
    //Register File
    wire [DATA_WIDTH-1:0]      reg_read_data1_rs;
    wire [DATA_WIDTH-1:0]      reg_read_data2_rt;
    wire [DATA_WIDTH-1:0]      reg_write_data;
    wire [REG_ADDRESS_WIDTH-1:0] reg_write_addr;
    //Data Mem
    wire [DATA_WIDTH-1:0]      dmem_write_data;
    wire [DATA_WIDTH-1:0]      dmem_read_data;
    //Control Signal
    wire [1:0]                 mode;    //data mem的访存模式
    wire                       MemRead;
    wire                       MemWrite;
    wire                       RegWrite; 
    wire [1:0]                 MemtoReg; //0:alu_res 1:dmem_read_data 2:pc_plus_8
    wire                       ALUSrc1;  //0:rs      1:sa 
    wire [1:0]                 ALUSrc2;  //0:rt      1:imm<<16        2:0
    wire [1:0]                 RegDst;   //0:rt      1:rd              2:pc+8
    //Branch 
    wire [ADDRESS_WIDTH-1:0]   imm_after_signext; //also used for immediate-ALU
    wire [ADDRESS_WIDTH-1:0]   branch_offset;
    //----------------------------------IF-----------------------------------
    //update PC
    assign o_cpu_pc = pc;
    always @(posedge clk) begin
        if(reset == 1'b1)
            pc = 32'h00000000;
        else
            pc = new_pc;
    end
    //Instruction Mem
    assign instruction = i_cpu_instruction;   //读入instruction
    assign o_cpu_out = pc;                    //向instruction mem提供pc
    /*
    instruction_mem #(DATA_WIDTH, ADDRESS_WIDTH)
                   CPU_instuction_mem
                   (
                       .i_read_address(pc),
                       .o_instruction(instruction)
                   );
    */
    //----------------------------------ID-----------------------------------
    //Control Unit
    control_unit   #(DATA_WIDTH)
                   CPU_control_unit
                   (
                       .i_instruction(instruction),
                       .MemRead(MemRead),
                       .MemWrite(MemWrite),
                       .mode(mode),
                       .MemtoReg(MemtoReg),
                       .ALUSrc1(ALUSrc1),
                       .ALUSrc2(ALUSrc2),
                       .RegWrite(RegWrite),
                       .RegDst(RegDst)
                   );
    //ALU decoder
    ALU_decoder    #(ADDRESS_WIDTH, DATA_WIDTH)
                   CPU_ALU_decoder
                   (
                       .i_instruction(instruction),
                       .o_alu_ctr(alu_ctr)
                   );
    //----------------------------------EX-----------------------------------
    //ALU
    ALU            #(DATA_WIDTH)
                   CPU_ALU
                   (
                       .i_oprand1(alu_oprand1),
                       .i_oprand2(alu_oprand2),
                       .i_alu_ctr(alu_ctr),
                       .o_zero(alu_zero),
                       .o_alu_res(alu_res)
                   );
    //compute branch offset
    sign_extender #(.from(16), .to(32)) 
                  br_sign_extender
                  (
                      instruction[15:0], 
                      imm_after_signext
                  );
    shift2bits    #(DATA_WIDTH) 
                  br_shift2bits 
                  (
                      .i_op(imm_after_signext), 
                      .o_ans(branch_offset)
                  );
    //PC updater
    pc_updater     #(ADDRESS_WIDTH)
                   CPU_pc_updater
                   (
                       .i_pc_old(pc),
                       .i_instruction(instruction),
                       .i_branch_offset(branch_offset),
                       .i_rs(reg_read_data1_rs),
                       .i_alu_res(alu_res),
                       .i_alu_zero(alu_zero),
                       .o_new_pc(new_pc)
                   );
    //----------------------------------MEM----------------------------------
    //Data Mem
    assign o_cpu_MemWrite  = MemWrite;
    assign o_cpu_MemRead   = MemRead;
    assign o_cpu_dmem_addr = alu_res;
    assign o_cpu_dmem_write_data = reg_read_data2_rt;
    assign dmem_read_data  = i_cpu_dmem_read_data;
    assign o_cpu_dmem_mode = mode;
    /*
    data_mem       #(DATA_WIDTH, ADDRESS_WIDTH)
                   CPU_data_mem
                   (
                       .clk(clk),
                       .MemWrite(MemWrite),
                       .MemRead(MemRead),
                       .i_address(alu_res),
                       .i_write_data(reg_read_data2_rt),
                       .o_read_data(dmem_read_data)
                   );
    */
    //----------------------------------WB-----------------------------------
    //Register File
    register_file  #(DATA_WIDTH, REG_ADDRESS_WIDTH)
                   CPU_register_file
                   (
                       .clk(clk),
                       .reset(reset),
                       .i_read_addr1(instruction[25:21]),
                       .i_read_addr2(instruction[20:16]),
                       .i_write_data(reg_write_data),
                       .i_write_addr(reg_write_addr),
                       .i_RegWrite(RegWrite),
                       .o_data1_rs(reg_read_data1_rs),
                       .o_data2_rt(reg_read_data2_rt)
                   );
    //-----------------------------Wire Connction--------------------------
    //4 Mux
    wire   CPU_of;
    adder         #(DATA_WIDTH)
                  pc_plus_8_adder
                  (
                      .i_op1(pc),
                      .i_op2(8),
                      .o_sum(pc_plus_8),
                      .o_OF(CPU_of)
                  );
    mux3to1       #(DATA_WIDTH)
                  reg_write_data_mux
                  ( 
                      .i_option0(alu_res),
                      .i_option1(dmem_read_data),
                      .i_option2(pc_plus_8),
                      .i_select(MemtoReg),
                      .o_choice(reg_write_data)
                  );

    mux3to1       #(REG_ADDRESS_WIDTH)
                  reg_write_addr_mux
                  (
                      .i_option0(instruction[20:16]), //rt
                      .i_option1(instruction[15:11]), //rd
                      .i_option2(5'b11111),           //GRP[31] <- pc + 8
                      .i_select(RegDst),
                      .o_choice(reg_write_addr)
                  );

    mux3to1       #(DATA_WIDTH)
                  alu_oprand2_mux
                  (
                      .i_option0(reg_read_data2_rt),  //rt的�??
                      .i_option1(imm_after_signext),  //imm << 16
                      .i_option2(32'h00000000),           // for BXXXZ
                      .i_select(ALUSrc2),
                      .o_choice(alu_oprand2)
                  );

    mux2to1       #(DATA_WIDTH)
                  alu_oprand1_mux
                  (
                      .i_option0(reg_read_data1_rs),  //rs
                      .i_option1({{24{1'b0}}, instruction[10:6]}),  //sa
                      .i_select(ALUSrc1),
                      .o_choice(alu_oprand1)
                  );

endmodule  //CPU