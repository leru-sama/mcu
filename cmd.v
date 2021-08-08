`define ALU_ADD    3'h1
`define ALU_MUL    3'h2
`define ALU_SUB    3'h3
`define ALU_SHIFT  3'h4

`define SEL_ALU    3'h7
`define SEL_REG0   3'h0
`define SEL_REG1   3'h1
`define SEL_EXTERN 3'h4
`define SEL_LR     3'h3
`define SEL_PC     3'h2

`define CMD_ADD     3'h1
`define CMD_SUB     3'h2
`define CMD_MUL     3'h3
`define CMD_LDR     3'h5
`define CMD_STR     3'h6
`define CMD_LDSP    3'h7
`define CMD_NOP     3'h0
`define CMD_SHIFT   3'h4

`define STATE_INIT      3'h0
`define STATE_GTCMD     3'h1
`define STATE_OPERATE   3'h2
`define STATE_FRESHPC   3'h3