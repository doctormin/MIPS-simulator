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


module signext
              #(
                parameter from = 16,
                parameter to = 32
              )
              (
                input  [from-1:0] inst,
                output [to-1  :0] data
              );
    genvar i;

    assign data[from-1:0] = inst[from-1:0];
    
    for(i = from; i < to; i = i + 1) begin
      assign data[i] = inst[from-1];
    end
endmodule
