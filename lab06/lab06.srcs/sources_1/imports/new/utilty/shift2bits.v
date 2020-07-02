`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 00:01:52
// Design Name: 
// Module Name: shift2bits
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

module shift2bits #
                (
                    parameter DATA_WIDTH    = 32
                )
                (
                    input  [DATA_WIDTH-1:0] i_op,
                    output [DATA_WIDTH-1:0] o_ans
                );
                
    assign o_ans = i_op << 2;

endmodule  //shift2bits