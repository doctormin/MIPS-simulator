`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 14:33:12
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

module  mux3to1 #
                (
                    parameter DATA_WIDTH    = 32
                )
                (
                    input  [DATA_WIDTH-1:0] i_option0,
                    input  [DATA_WIDTH-1:0] i_option1,
                    input  [DATA_WIDTH-1:0] i_option2,
                    input  [1:0]            i_select,
                    output [DATA_WIDTH-1:0] o_choice
                );
                
    assign o_choice = i_select[1] ? i_option2 : (i_select[0] ? i_option1 : i_option0);

endmodule  //mux3to1