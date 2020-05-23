`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 22:22:36
// Design Name: 
// Module Name: dataMemory_tb
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


module dataMemory_tb();
    reg  clk;
    reg  [31:0] address;
    reg  [31:0] writeData;
    reg  memWrite;
    reg  memRead;
    wire [31:0] readData;

    parameter PERIOD = 100;
    always # (PERIOD) clk = !clk;

    dataMemory memory(
        .clk       (clk),
        .address   (address),
        .writeData (writeData),
        .memWrite  (memWrite),
        .memRead   (memRead),
        .readData  (readData)
    );

    initial begin
        clk  = 0;
        address = {32{1'bx}};
        #185;
        memWrite = 1'b1;
        address = 32'b00000000000000000000000000000111;
        writeData = 32'b11100000000000000000000000000000;

        #100;
        memWrite = 1'b1;
        writeData = 32'hffffffff;
        address = 32'b00000000000000000000000000000110;

        #185;
        memRead = 1'b1;
        memWrite = 1'b0;

        #80;
        memWrite = 1;
        address = 8;
        writeData = 32'haaaaaaaa;

        #80;
        memWrite = 0;
        memRead = 1;
    end
endmodule
