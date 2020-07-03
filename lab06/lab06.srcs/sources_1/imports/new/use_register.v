`timescale 1ns / 1ps
`include "ISA.v"

module use_register #(
                        parameter W = 32
                     )
                     (
                        input  [W-1:0] instruction,
                        output reg use_rs,
                        output reg use_rt
                     );

wire [`op]  opcode = `get_op(instruction);
wire [`fun] fun    = `get_fun(instruction);

    always @(*) begin
        use_rs = 1;
        use_rt = 1;
        if(opcode == `OP_J || opcode == `OP_JAL ) begin
            use_rs = 0;
            use_rt = 0;
        end
        /*不需要，因为实际上用�?$zero
        if(opcode == `OP_R && (fun == `FUN_SLL||fun == `FUN_SRL||fun == `FUN_SRA) 
            use_rs = 0;
        */
        if(opcode == `OP_REGIMM)
            use_rt = 0;
    end 
endmodule