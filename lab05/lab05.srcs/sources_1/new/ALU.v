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
                input  [3:0] i_alu_ctr,
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
           ALU_SRL   = 10,
           ALU_SRA   = 11,
           ALU_SLT   = 12,
           ALU_SLTU  = 13,
           ALU_SLE   = 14,
           ALU_LUI   = 15,
           ALU_NO    = 16;

always @(*) begin
    o_alu_res = {DATA_WIDTH{1'b0}};
    o_zero = 1'bx;
    case(i_alu_ctr)
        /*
           ADD  : rd = rs + rt  (with overflow exception)
           ADDI : rt = rs + imm (with overflow exception)
           SB   : MEM[rs + imm] <- rt[7 :0]
           SH   : MEM[rs + imm] <- rt[15:0]
           SW   : MEM[rs + imm] <- rt[31:0]
           LB   : rt            <- sign_extend(MEM[rs + imm])
           LBU  : rt            <- zero_extend(MEM[rs + imm])
           LH   : rt            <- sign_extend(MEM[rs + imm])
           LHU  : rt            <- zero_extend(MEM[rs + imm])
           LW   : rt            <- MEM[rs + imm]
        */
        ALU_ADD:  begin
            o_alu_res = i_oprand1 + i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end
        
        /* 
           ADDU :  rd = rs + rt  (without overflow exception)
           ADDIU:  rt = rs + imm (without overflow exception)
        */
        ALU_ADDU: begin
            o_alu_res = i_oprand1 + i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           SUB  : rd = rs - rt (with overflow exception)
        */
        ALU_SUB:  begin
            o_alu_res = i_oprand1 - i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           SUBU  : rd = rs - rt (without overflow exception)
           BEQ / BNE  : ?  = rs - rt (without overflow exception)
        */
        ALU_SUBU: begin
            o_alu_res = i_oprand1 - i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           AND  : rd = rs & rt
           ANDI : rt = rs & (zero_extend)imm
        */
        ALU_AND:  begin
            o_alu_res = i_oprand1 & i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           OR   : rd = rs | rt
           ORI  : rt = rs | (zero_extend)imm
        */
        ALU_OR:   begin
            o_alu_res = i_oprand1 | i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           XOR  : rd = rs ^ rt
           XORI : rt = rs ^ (zero_extend)imm
        */
        ALU_XOR:  begin
            o_alu_res = i_oprand1 ^ i_oprand2;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        // NOR  : rd = ~(rs | rt)
        ALU_NOR:  begin
            o_alu_res = ~(i_oprand1 | i_oprand2);
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        //逻辑左移 rd = rt << rs || rd = rt << sa
        ALU_SLL:  begin 
            o_alu_res = i_oprand2 << $unsigned(i_oprand1);
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        //逻辑右移 rd = rt >> rs || rd = rt >> sa
        ALU_SRL:  begin 
            o_alu_res = i_oprand2 >> $unsigned(i_oprand1);
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        //算数右移  rd = rt >>> rs || rd = rt >>> sa
        ALU_SRA:  begin 
            o_alu_res = i_oprand2 >>> $unsigned(i_oprand1);
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           SLT  : rd = (rs < rt)
           SLTI : rt = (rs < imm)
           BGEZ / BGTZ / BGEZAL / BLEZ / BLTZ / BLTZAL : ?  = rs ? 0 (without overflow exception)
        */
        ALU_SLT:  begin
            if($signed(i_oprand1) < $signed(i_oprand2))
                o_alu_res = 1;
            else
                o_alu_res = 0;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           SLTU : rd = ($unsigned(rs) < $unsigned(rt))
           SLTIU: rt = ($unsigned(rs) < $unsigned(imm))
        */
        ALU_SLTU: begin
            if($unsigned(i_oprand1) < $unsigned(i_oprand2))
                o_alu_res = 1;
            else
                o_alu_res = 0;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           BGTZ
           BLEZ
        */
        ALU_SLE: begin
            if($signed(i_oprand1) <= $signed(i_oprand2))
                o_alu_res = 1;
            else
                o_alu_res = 0;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end


        // LUI  : rt = imm << 16
        ALU_LUI:  begin
            o_alu_res = (i_oprand2 << 16);
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end

        /*
           JR
         */
        ALU_NO:  begin
            o_alu_res = 32'bx;
            if(o_alu_res == {DATA_WIDTH{1'b0}})
                o_zero = 1'b1;
            else
                o_zero = 1'b0;
        end
        default: begin
			$display("%x:illegal ALU ctl code %b\n", 0, i_ALUCTL);
		end
    endcase
end

endmodule
