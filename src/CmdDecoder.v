`include "./../cmd.v"

module CmdDecoder (
    input   wire            clk,
    input   wire            rstn,

    input   wire[7:0]       cmd,

    output  wire[1:0]       RegSel0_o,
    output  wire[1:0]       RegSel1_o,
    output  wire[2:0]       RegSrc_o,
    output  wire[2:0]       ALUSel_o,
    output  wire            RDOnly_o,
    output  wire            RDRequest_o,
    output  wire            WRRequest_o,
    output  wire[7:0]       ExternVal_o,

    output  wire            Halt_o,
    output  wire            ExternSel_o,
    output  wire[7:0]       ImmData_o

);

//cmd:      7:5          4         3        2:0
//      operation      DstReg    srcReg   immData


reg[2:0]    RegSrc;
always @(*) begin
    case(cmd[7:5])
    `CMD_LDR : RegSrc = `SEL_EXTERN;
    `CMD_LDSP: RegSrc = cmd[4] == cmd[3] ? `SEL_EXTERN : {2'b0,cmd[3]};
    `CMD_ADD : RegSrc = `SEL_ALU;
    `CMD_SUB : RegSrc = `SEL_ALU;
    `CMD_MUL : RegSrc = `SEL_ALU;
    `CMD_SHIFT:RegSrc = `SEL_ALU;
    default  : RegSrc = 3'bx;
    endcase
end

reg[2:0]    RegSrcReg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        RegSrcReg <= 3'b0;
    else 
        RegSrcReg <= RegSrc;
end



reg[2:0]    ALUSel;
always @(*) begin
    case(cmd[7:5])
    `CMD_ADD : ALUSel = `ALU_ADD;
    `CMD_SUB : ALUSel = `ALU_SUB;
    `CMD_MUL : ALUSel = `ALU_MUL;
    `CMD_SHIFT:ALUSel = `ALU_SHIFT;
    default  : ALUSel = 3'b0;
    endcase
end


reg         RDOnly;
always @(*) begin
    case(cmd[7:5])
    `CMD_LDR : RDOnly = 1'b0;
    `CMD_NOP : RDOnly = 1'b1;
    `CMD_LDSP: RDOnly = 1'b0;
    `CMD_ADD : RDOnly = 1'b0;
    `CMD_SUB : RDOnly = 1'b0;
    `CMD_MUL : RDOnly = 1'b0;
    `CMD_SHIFT:RDOnly = 1'b0;
    `CMD_STR : RDOnly = 1'b1;
    default  : RDOnly = 1'bx;
    endcase
end

reg         RDOnlyReg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        RDOnlyReg <= 1'b0;
    else 
        RDOnlyReg <= RDOnly;
end


reg[1:0]    RegSel0;
always @(*) begin
    if(cmd[7:5] == `CMD_LDSP)  
        RegSel0 <= cmd[4] ? 2'h2 : 2'h3;        //pc en : lr en
    else
        RegSel0 <= {1'b0,cmd[4]};
end

reg[1:0]    RegSel0Reg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        RegSel0Reg <= 2'b0;
    else 
        RegSel0Reg <= RegSel0;
end

reg[1:0]    RegSel1;
always @(*) begin
    case(cmd[7:5])
    `CMD_ADD : RegSel1 = cmd[4] == cmd[3] ? 2'h3 :  {1'b0,cmd[3]};
    `CMD_SUB : RegSel1 = cmd[4] == cmd[3] ? 2'h3 :  {1'b0,cmd[3]};
    `CMD_MUL : RegSel1 = cmd[4] == cmd[3] ? 2'h3 :  {1'b0,cmd[3]};
    `CMD_SHIFT:RegSel1 = cmd[4] == cmd[3] ? 2'h3 :  {1'b0,cmd[3]};
    `CMD_LDR : RegSel1 = cmd[3];
    `CMD_STR : RegSel1 = cmd[3];
    default  : RegSel1 = 3'bx;
    endcase
end

reg[1:0]    RegSel1Reg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        RegSel1Reg <= 2'b0;
    else 
        RegSel1Reg <= RegSel1;
end
    

//[0]:ctl signal pause  [1]:data  pause
reg    Pause;
always @(posedge clk or negedge rstn) begin
    if(~rstn)  
        Pause <= 1'b0;
    else begin
        if(cmd[7:5] == `CMD_LDR)
            Pause <= 1'b1;
        else if(Pause)
            Pause <= 1'b0;
    end
end

reg[7:0]    cmdReg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        cmdReg <= 8'b0;
    else 
        cmdReg <= cmd;
end






wire    Halt;
assign Halt = cmd[7:5] == `CMD_LDR ;

assign ExternSel_o = (cmd[7:5] == `CMD_LDR  | cmd[7:5] == `CMD_LDSP | cmdReg[7:5] == `CMD_LDR) ? 1'b1 : 1'b0;


assign Halt_o = Halt;
assign RegSel0_o = Pause  ? RegSel0Reg : RegSel0;
assign RegSel1_o = Pause  ? RegSel1Reg : RegSel1;
assign RegSrc_o  = Pause  ? RegSrcReg  : RegSrc;
assign ALUSel_o  = ALUSel;
assign RDOnly_o  = Pause  ? RDOnlyReg  : RDOnly;
assign ImmData_o = {5'h0,cmd[2:0]};
assign RDRequest_o = ((cmd[7:5] == `CMD_LDR) | (cmd[7:5] == `CMD_LDSP)) ? 1'b1 : 1'b0;
assign WRRequest_o = cmd[7:5] == `CMD_STR  ? 1'b1 : 1'b0;



endmodule