`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 23:17:13
// Design Name: 
// Module Name: signext_tb
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


module signext_tb();
    reg  [15:0] inst;
    wire [31:0] data;
    signext extend(
        .inst(inst),
        .data(data)
    );
    initial begin
        #100;
        inst = 16'b0111111111111111;
        #100;
        inst = 16'b0101010101010101;
        #100;
        inst = 16'b1111111111111111;
        #100;
        inst = 16'b1101010101010101;
    end
endmodule
