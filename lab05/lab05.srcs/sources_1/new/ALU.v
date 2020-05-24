`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/24 12:31:18
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


module ALU #(
                parameter DATA_WIDTH    = 32,
                parameter ALU_CTR_WIDTH = 8
            )
            (
                //input
                input  signed [DATA_WIDTH-1:0] i_oprand1,
                input  signed [DATA_WIDTH-1:0] i_oprand2,
                input  [3:0] i_alu_ctr_out,
                //output
                output reg o_zero,
                output reg [DATA_WIDTH-1:0] o_alu_res
            );
localparam ALU_ADD   = 1,
           ALU_ADDU  = 2,
           ALU_SUB   = 3,
           ALU_SUBU  = 4,
           ALU_AND   = 5,
           ALU_OR    = 6,
           ALU_XOR   = 7,
           ALU_NOR   = 8,
           ALU_SLL   = 9,
           ALU_SLLV  = 10,
           ALU_SRL   = 11,
           ALU_SRLV  = 12,
           ALU_SRA   = 13,
           ALU_SRAV  = 14,
           ALU_SLT   = 15,
           ALU_SLTIU = 16,
           ALU_SLTU  = 17,
           ALU_LUI   = 18;


always @(*) begin
    o_alu_res <= {DATA_WIDTH{1'b0}};
    o_zero <= 1'bx;
    case(i_alu_ctr_out)
        ALU_ADD:  begin
            o_alu_res <= i_oprand1 + i_oprand2;
        end
        
        ALU_ADDU: begin
            o_alu_res <= i_oprand1 + i_oprand2;
        end

        ALU_SUB:  begin
            o_alu_res <= i_oprand1 - i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero <= 1'b1;
            else
                o_zero <= 1'bx;
        end

        ALU_SUBU: begin
            o_alu_res <= i_oprand1 - i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero <= 1'b1;
            else
                o_zero <= 1'bx;
        end

        ALU_AND:  begin
            o_alu_res <= i_oprand1 & i_oprand2;
        end

        ALU_OR:   begin
            o_alu_res <= i_oprand1 | i_oprand2;
        end

        ALU_XOR:  begin
            o_alu_res <= i_oprand1 ^ i_oprand2;
        end

        ALU_NOR:  begin
            o_alu_res <= ~(i_oprand1 | i_oprand2);
        end
        
        ALU_SLL:  begin //TODO: SLL mux
            o_alu_res <= i_oprand2 << i_oprand2;
        end

        ALU_SLL:  begin
            o_alu_res <= i_oprand2 << i_oprand1[4:0];
        end

        ALU_SRL:  begin //TODO: SRL mux
            o_alu_res <= i_oprand2 >> i_oprand2;
        end

        ALU_SRLV: begin
            o_alu_res <= i_oprand2 >> i_oprand1[4:0];
        end

        ALU_SRA:  begin //TODO: SRA mux
            o_alu_res <= i_oprand2 >>> i_oprand2;
        end

        ALU_SRAV: begin
            o_alu_res <= i_oprand2 >>> i_oprand1[4:0];
        end

        ALU_SLT:  begin
            if(i_oprand1 < i_oprand2)
                o_alu_res <= 1;
            else
                o_alu_res <= 0;
        end

        ALU_SLTIU: begin
            if(i_oprand1 < $unsigned(i_oprand2))
                o_alu_res <= 1;
            else
                o_alu_res <= 0;
        end

        ALU_LUI:  begin
            o_alu_res <= (i_oprand2 << 16);
        end

        default: begin
			$display("%x:illegal ALU ctl code %b\n", 0, i_ALUCTL);
		end
    endcase
end

endmodule
