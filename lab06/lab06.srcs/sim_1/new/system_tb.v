`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/01 17:47:03
// Design Name: 
// Module Name: system_tb
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

module system_tb();
    reg clk;
    reg reset;
    parameter PERIOD = 100;
    always # (PERIOD) clk = !clk;

    TOP TOP_instance(.clk(clk), .reset(reset));
    
    initial begin
        clk = 0;
        reset = 0;
        #101
        reset = 1;
        #10
        reset = 0;
    end
endmodule
