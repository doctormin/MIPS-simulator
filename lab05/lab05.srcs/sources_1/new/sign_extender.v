`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 23:07:05
// Design Name: 
// Module Name: signext
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


module signext(
    input [15:0] inst,
    output [31:0] data
    );
    wire [31:0] Data;
    wire s_bit;
    assign data = Data;
    assign data = {{16{inst[15]}}, inst};
endmodule
