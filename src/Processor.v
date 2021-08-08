`include "./../cmd.v"
module Processor(

    input   wire        clk,
    input   wire        rstn,

    output  wire        LRMasterRD_o,
    output  wire        LRMasterWR_o,
    input   wire[7:0]   LRMasterRDData_i,
    output  wire[7:0]   LRMasterWRData_o,
    output  wire[7:0]   LRMasterAddr_o,

    output  wire        LROccupy_o

);

wire        Halt;
reg[2:0]    State;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        State <= 3'b0;
    else begin
        case(State)
        `STATE_INIT:    State <=   `STATE_GTCMD;
        `STATE_GTCMD:   State <= Halt ? State : `STATE_OPERATE;
        `STATE_OPERATE: State <= Halt ? State : `STATE_FRESHPC;
        `STATE_FRESHPC: State <= Halt ? State : `STATE_GTCMD;
        default:        State <= `STATE_INIT;
        endcase
    end
end

reg[2:0]    StateReg;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        StateReg <= 3'b0;
    else 
        StateReg <= State;
end

wire[7:0]   PC;
wire[7:0]       ExternAddr_o;
// all signal about address should use State to get 1 cycle earlier
reg[7:0]    Addr;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        Addr <= 8'h0;
    else
        Addr <= PC;
end

reg[7:0]    cmd;
always @(posedge clk or negedge rstn) begin
    if(~rstn)
        cmd <= 8'h0;
    else begin
        if(StateReg == `STATE_GTCMD)
            cmd <= 8'h0;
        else if(StateReg == `STATE_OPERATE)
            cmd <= LRMasterRDData_i;
        else if(StateReg == `STATE_FRESHPC)
            cmd <= {`CMD_LDSP,2'b11,3'b0};
    end
end





wire            RDRequest_o;
wire            WRRequest_o;
wire[7:0]       ExternVal_o;
wire[7:0]       ExternVal_i;
wire[31:0]       Regs;
Kernel  kernel(
    .clk            (clk),
    .rstn           (rstn),
    .Cmd_i          (cmd),
    .Regs_o         (Regs),
    .ExternVal_i    (ExternVal_i),
    .ExternVal_o    (ExternVal_o),
    .RDRequest_o    (RDRequest_o),
    .WRRequest_o    (WRRequest_o),
    .ExternAddr_o   (ExternAddr_o),
    .Halt_o         (Halt)
);


assign ExternVal_i      = State == `STATE_OPERATE ? PC + 8'b1 : LRMasterRDData_i;
assign LRMasterAddr_o   = State == `STATE_OPERATE ?  Addr : ExternAddr_o;
assign LRMasterWRData_o = ExternVal_o;
assign LRMasterRD_o     = RDRequest_o;
assign LRMasterWR_o     = WRRequest_o;
assign PC = Regs[23:16];

endmodule