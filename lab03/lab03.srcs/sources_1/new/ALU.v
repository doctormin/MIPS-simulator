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
              SLT = 4'b0111,
              NOR = 4'b1100;

    always @ (src1 or src2 or aluCtr)begin
        case (aluCtr)
            AND : begin
                    ALURes = src1 & src2;
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0; 
                  end
            OR : begin
                    ALURes = src1 | src2;
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0; 
                  end
            ADD : begin
                    ALURes = src1 + src2;
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0; 
                  end
            SUB : begin
                    ALURes = src1 - src2;
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0;   
                  end 
            SLT : begin
                    ALURes = ($signed(src1) < $signed(src2));
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0;   
                  end
            NOR : begin
                    ALURes = ~(src1 ^ src2);
                    if (ALURes == 0)
                        Zero = 1;
                    else 
                        Zero = 0; 
                  end
            default: begin
			        $display("%x:illegal ALU ctl code %b\n", 0, aluCtr);
		          end
        endcase 
    end
    assign aluRes = ALURes;
    assign zero   = Zero;
endmodule
