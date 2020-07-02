`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 23:39:57
// Design Name: 
// Module Name: adder
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


module adder #
                (
                    parameter DATA_WIDTH    = 32
                )
                (
                    input  [DATA_WIDTH-1:0] i_op1,
                    input  [DATA_WIDTH-1:0] i_op2,
                    output reg [DATA_WIDTH-1:0] o_sum,
                    output reg o_OF
                );

    always @(*) begin
        {o_OF, o_sum} = i_op1 + i_op2; 
    end
endmodule  //adder
