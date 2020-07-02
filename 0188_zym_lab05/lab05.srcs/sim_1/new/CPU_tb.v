`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 17:47:03
// Design Name: 
// Module Name: CPU_tb
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
//registers
`define ZERO    5'd00
`define AT      5'd01
`define V0      5'd02
`define V1      5'd03
`define T0      5'd08
`define T1      5'd09
`define T2      5'd10
`define T3      5'd11
`define T4      5'd12
`define T5      5'd13
`define T6      5'd14
`define T7      5'd15
`define GP      5'd28
`define SP      5'd29
`define FP      5'd30
`define RA      5'd31

//debugging
`define assert(signal, value) if (signal != value) $warning("ASSERTION FAILED: signal(%08X,%d) != value(%08X)", signal, signal, value);
`define regFile TOP_instance.TOP_CPU.CPU_register_file.reg_file

module CPU_tb();
    reg clk;
    reg reset;
    parameter PERIOD = 100;
    always # (PERIOD) clk = !clk;

    TOP TOP_instance(.clk(clk), .reset(reset));
    
    initial begin
        clk = 0;
        reset = 1;
        #150
        reset = 0;
        #3000;
        `assert(`regFile[`T2], 'hffff8000);
        `assert(`regFile[`T3], 'h00008000);
        `assert(`regFile[`T4], 'hffffffff);
        `assert(`regFile[`T5], 'h000000ff);
        `assert(`regFile[`T6], 'hffff8090);
    
    end
endmodule
