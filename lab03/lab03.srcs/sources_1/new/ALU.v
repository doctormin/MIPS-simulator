`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/23 17:15:33
// Design Name: 
// Module Name: ALU
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


module ALU(
        input  [31:0] src1,
        input  [31:0] src2,
        input  [3:0]  aluCtr,
        output [31:0] aluRes,
        output zero
    );
    reg Zero;
    reg [31:0] ALURes;

    parameter AND = 4'b0000,
              OR  = 4'b0001,
              ADD = 4'b0010,
              SUB = 4'b0110,
              SLT = 4'b0110,
              NOR = 4'b1100;

    always @ (src1 or src2 or aluCtr)begin
        case (aluCtr)
            AND : ALURes = src1 & src2;
            OR  : ALURes = src1 | src2;
            ADD : ALURes = src1 + src2;
            SUB : begin
                    ALURes = src1 - src2;
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0;   
                  end 
            SLT : begin
                    if (src1 < src2)
                        ALURes = 1;
                    else
                        ALURes = 0;
                  end
            NOR : ALURes = ~(src1 ^ src2);
        endcase 
    end
    assign aluRes = ALURes;
    assign zero   = Zero;
endmodule
