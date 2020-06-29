`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 23:46:32
// Design Name: 
// Module Name: mux2to1
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

module  mux2to1 #
                (
                    parameter DATA_WIDTH    = 32
                )
                (
                    input  [DATA_WIDTH-1:0] i_option1,
                    input  [DATA_WIDTH-1:0] i_option2,
                    input  i_select,
                    output [DATA_WIDTH-1:0] o_choice
                );
                
    assign o_choice = i_select ? i_option2 : i_option1;

endmodule  //mux2to1