`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 22:21:07
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input  clk,
    input  [31:0] address,
    input  [31:0] writeData,
    input  memWrite,
    input  memRead,
    output [31:0] readData
    );
    
    reg [31:0] ReadData;
    assign readData = ReadData;
    
    reg [31:0] memFile [0:63];
    
    //Read Data from Memory 
    always @ (*) begin
        if(memRead == 1'b1)
            ReadData = memFile[address];
    end
    //Write Data into Memory
    always @ (posedge clk or memWrite) begin
        if(memWrite == 1'b1)
            memFile[address] = writeData;
    end
endmodule
