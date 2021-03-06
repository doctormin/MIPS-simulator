`timescale 1ns / 1ps
`include "ISA.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/03 17:20:00
// Design Name: 
// Module Name: forwarding unit
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

module forwarding_unit 
    #(parameter W = 32)
    (
        input [W-1:0] i_EX_instruction,
        input [W-1:0] i_MEM_instruction,
        input [W-1:0] i_WB_instruction,
        input [W-1:0] i_WB_reg_write_data, i_MEM_reg_write_data,    
        input [`reg]  i_WB_reg_write_addr, i_MEM_reg_write_addr,  
        input         i_WB_RegWrite,       i_MEM_RegWrite,

        output reg [W-1:0] o_forwarded_data,
        output reg o_rs_forward_signal,        //高电平意味着forward data到ALU op1
        output reg o_rt_forward_signal,        //高电平意味着forward data到ALU op2
        output reg o_mem_forward_signal        //高电平意味着forward data到dmem_write_data
    );

    wire [`reg] EX_rs_id  = `get_rs(i_EX_instruction);
    wire [`reg] EX_rt_id  = `get_rt(i_EX_instruction);
    wire [`reg] MEM_rs_id = `get_rs(i_MEM_instruction);
    wire [`reg] MEM_rt_id = `get_rt(i_MEM_instruction);
    wire WB_not_nop = !`isNop(i_WB_instruction);
    wire MEM_not_nop = !`isNop(i_MEM_instruction);
    wire EX_use_rs;
    wire EX_use_rt;
    wire MEM_use_rs;
    wire MEM_use_rt;
    wire MEM_is_store = `isStore(i_MEM_instruction);
    reg [3:0] case_indicator;

    use_register #(32)
        fu_use_reg1
        (
            .instruction(i_EX_instruction),
            .use_rs(EX_use_rs),
            .use_rt(EX_use_rt)
        );
    use_register #(32)
        fu_use_reg2
        (
            .instruction(i_MEM_instruction),
            .use_rs(MEM_use_rs),
            .use_rt(MEM_use_rt)
        );
      
    initial begin
        o_rs_forward_signal = 0;
        o_rt_forward_signal = 0;
        o_mem_forward_signal = 0;
    end
    always @(*) begin
        o_rs_forward_signal  = 0;
        o_rt_forward_signal  = 0;
        o_mem_forward_signal = 0;
        o_forwarded_data = {32{1'b0}};
        case_indicator = 0;
        if(i_WB_RegWrite && WB_not_nop) begin
            //WB->MEM
            case_indicator = 1;
            if(MEM_is_store && MEM_use_rt && MEM_rt_id == i_WB_reg_write_addr) 
                begin
                    o_forwarded_data     = i_WB_reg_write_data;
                    o_mem_forward_signal = 1;
                    case_indicator = 2;
                end
            else 
                begin
                    case_indicator = 3;
                    //WB->EX
                    if(EX_use_rs && EX_rs_id == i_WB_reg_write_addr) begin
                        //转发到rs
                        o_forwarded_data    = i_WB_reg_write_data;
                        o_rs_forward_signal = 1;
                        case_indicator = 4;
                    end 
                    if(EX_use_rt && EX_rt_id == i_WB_reg_write_addr) begin
                        //转发到rt
                        o_forwarded_data    = i_WB_reg_write_data;
                        o_rt_forward_signal = 1;
                        case_indicator = 5;
                    end
                end
        end
        //case2 MEM -> EX
        if(i_MEM_RegWrite && MEM_not_nop) begin
            case_indicator = 6;
            /*
            if(`isStore(i_EX_instruction)) 
                case_indicator = 7;
                //转发到mem
                if(EX_use_rt && EX_rt_id == i_MEM_reg_write_addr) begin
                    o_forwarded_data     = i_MEM_reg_write_data;
                    o_mem_forward_signal = 1;
                    case_indicator = 4;
                end
            
            else*/ 
                if(EX_use_rs && EX_rs_id == i_MEM_reg_write_addr) begin
                    //转发到rs
                    o_forwarded_data    = i_MEM_reg_write_data;
                    o_rs_forward_signal = 1;
                    case_indicator = 7;
                end 
                if(EX_use_rt && EX_rt_id == i_MEM_reg_write_addr) begin
                    //转发到rt
                    o_forwarded_data    = i_MEM_reg_write_data;
                    o_rt_forward_signal = 1;
                    case_indicator = 8;
                end
        
        end

    end
endmodule  //forwaring_unit