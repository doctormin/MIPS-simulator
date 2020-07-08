`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/30 00:04:02
// Design Name: 
// Module Name: instruction_mem
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

module instruction_mem #
                (
                    parameter DATA_WIDTH    = 32,
                    parameter ADDRESS_WIDTH = 32
                )
                (
                    input      [ADDRESS_WIDTH-1:0] i_read_address,
                    output reg [DATA_WIDTH-1   :0] o_instruction
                );
    localparam memSize  = 400;
    reg [DATA_WIDTH-1:0] I_memory[0:memSize-1];
    integer i;
    initial begin
        for(i = 0; i < memSize; i = i + 1) begin
            I_memory[i] = 0;
        end
        //我用vivado尝试了多次相对路径写法，却总是读取失败，一直找不到原因，因此烦请老师使用绝对路径
        //test1 -> ".../lab05/lab05.srcs/sources_1/imports/new/DUMP/ALUtest1.mem"
        //test2 -> ".../lab05/lab05.srcs/sources_1/imports/new/DUMP/BranchJump.mem"
        //test3 -> ".../lab05/lab05.srcs/sources_1/imports/new/DUMP/MemTest.mem"
        $readmemh("C:/Users/18123/Desktop/lab05/lab05.srcs/sources_1/imports/new/DUMP/ALUtest1.mem", I_memory);
        $display("dump finished!\n");
    end
    always @(*) begin
        o_instruction = I_memory[i_read_address>>2];
    end
endmodule  //instruction_mem