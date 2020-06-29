`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 00:18:06
// Design Name: 
// Module Name: register_file
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

module register_file #
                    (
                        parameter DATA_WIDTH    = 32,
                        parameter ADDRESS_WIDTH = 6
                    )
                    (
                        input                           clk,
                        input  [ADDRESS_WIDTH-1:0]      i_read_addr1,
                        input  [ADDRESS_WIDTH-1:0]      i_read_addr2,
                        input  [ADDRESS_WIDTH-1:0]      i_write_addr,
                        input  [DATA_WIDTH-1   :0]      i_write_data,
                        input                           i_RegWrite,
                        output reg [DATA_WIDTH-1:0]     o_data1_rs,
                        output reg [DATA_WIDTH-1:0]     o_data2_rt
                    );

reg [DATA_WIDTH:0] reg_file [0:31];

always @(i_read_addr1 or i_read_addr2) begin
    o_data1_rs <= reg_file[i_read_addr1];
    o_data2_rt <= reg_file[i_read_addr2];
end

always @(posedge clk) begin
    if(i_RegWrite)
        reg_file[i_write_addr] = i_write_data;
end

endmodule  //register_file