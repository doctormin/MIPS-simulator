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


//pc_updater是一个组合逻辑电路，用来生成下一条指令的pc, 即new_pc. 而pc的更新发生在CPU模块里
module pc_updater #
                (
                    parameter W = 32
                )
                (
                    input [W-1:0] i_pc_old,
                    /*出现load-use hazard时，stall pipe*/
                    input stall,
                    /*J, JAL*/
                    input [W-1:0] i_IF_instruction,
                    /*JR*/
                    input         i_EX_isJR, //若EX stage的指令是JR, 则为高电平
                    input [W-1:0] i_EX_rs,   //JR的跳转地址，即rs
                    input [W-1:0] i_rs_forward_signal, 
                    input         i_forwarded_data,//JR的跳转地址，即rs(forwarded)
                    /*Brach*/
                    input         i_EX_branch_taken,
                    input         i_EX_branch_des,
                    
                    output reg [W-1:0] o_new_pc,
                    //若branch taken, 要flash两个pipeline reg
                    output reg flush_ID_EX,
                    output reg flush_IF_ID
                );
always @(*) begin
    flush_ID_EX = 0;
    flush_IF_ID = 0;
    
    if(stall) begin
        o_new_pc = i_pc_old;  //重复现在的指令
        flush_IF_ID = 1;      //现在的指令不会进入ID stage
    end

    else 
        if(`isJump(i_IF_instruction) || `isJAL(i_IF_instruction)) begin
            o_new_pc = {i_pc_old[W-1:W-4], `get_j(i_IF_instruction), 2'b00};
        end

    else 
        if(i_EX_isJR) 
            o_new_pc = i_rs_forward_signal ? i_forwarded_data : i_EX_rs;

    else 
        if(i_EX_branch_taken) begin
            o_new_pc = i_EX_branch_des;
            flush_IF_ID = 1;
            flush_ID_EX = 1;
        end

    else 
        o_new_pc = i_pc_old + 4;
end
endmodule  //pc_updater