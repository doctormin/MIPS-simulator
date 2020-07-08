# Single Cycle / 5-stage Pipelined MIPS simulator
support 44 instructions
   |      |      |      |      |       |      |
| --------- | ---- | ----- | ------ | ---- | ---- | ---- | ------ | ---- | ---- | ---- | ---- | ---- | ---- | ----- | ---- |
| R-Type    | ADD  | ADDU  | SUB    | SUBU | AND  | OR   | XOR    | NOR  | SLLV | SRLV | SRAV | SRA  | SLT  | SLTU  | NOOP |
| immediate | ADDI | ADDIU |        |      | ANDI | ORI  | XORI   |      | SLL  | SRL  |      |      | SLTI | SLTIU | LUI  |
| Branch    | BEQ  | BGEZ  | BGEZAL | BGTZ | BLEZ | BLTZ | BLTZAL | BNE  |      |      |      |      |      |       |      |
| Jump      | J    | JAL   | JR     |      |      |      |        |      |      |      |      |      |      |       |      |
| Memory    | LB   | LBU   | LH     | LHU  | LW   | SB   | SH     | SW   |      |      |      |      |      |       |      |

