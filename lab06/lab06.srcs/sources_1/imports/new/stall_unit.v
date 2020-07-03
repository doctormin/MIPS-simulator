`timescale 1ns / 1ps
`include "ISA.v"

//此unit在ID阶段生效，读取IF和ID的instruction，来决定是否stall IF 
module stall_unit #(parameter W = 32)
       (
            input [W-1:0] i_IF_instruction,
            input [W-1:0] i_ID_instruction,
            output reg    o_stall //该信号传给pc updater
       );
    wire [`reg] IF_use_rs_id = `get_rs(i_IF_instruction);
    wire [`reg] IF_use_rt_id = `get_rt(i_IF_instruction);
    wire [`reg] ID_load_reg_id = `get_rt(i_ID_instruction);
    wire IF_use_rs;
    wire IF_use_rt;
    use_register #(W) 
                cu_use_reg1
                (
                    .instruction(i_IF_instruction), 
                    .use_rs(IF_use_rs), 
                    .use_rt(IF_use_rt)
                );

    always @(*) begin
        //情况1， 碰到JR就无条件stall
        if(`isJR(i_ID_instruction))
            o_stall = 1;
        //情况2， use after load
        if(`isLoad(i_ID_instruction)) begin
            if(IF_use_rs && IF_use_rs_id == ID_load_reg_id) 
                o_stall = 1;
            if(IF_use_rt && IF_use_rt_id == ID_load_reg_id)
                o_stall = 1;
        end
    end
endmodule  //stall_unit