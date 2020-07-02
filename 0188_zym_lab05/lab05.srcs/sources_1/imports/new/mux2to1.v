`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/02 12:42:12
// Design Name: 
// Module Name: mux3to1
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
                    input  [DATA_WIDTH-1:0] i_option0,
                    input  [DATA_WIDTH-1:0] i_option1,
                    input                   i_select,
                    output [DATA_WIDTH-1:0] o_choice
                );
                
    assign o_choice = i_select ? i_option1 : i_option0;

endmodule  //mux2to1