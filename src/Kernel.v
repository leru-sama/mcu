`include "./../cmd.v"
module Kernel(
    input   wire        clk,
    input   wire        rstn,

    input   wire[7:0]   Cmd_i,
    output  wire[31:0]  Regs_o,
    input   wire[7:0]   ExternVal_i,

    output  wire[7:0]   ExternVal_o,
    output  wire[7:0]   ExternAddr_o,
    output  wire        RDRequest_o,
    output  wire        WRRequest_o,

    output  wire        Halt_o
);

wire        Pause;
wire[1:0]   RegSel0;
wire[1:0]   RegSel1;
wire[2:0]   RegSrc;
wire[2:0]   ALUSel;
wire        RDOnly;
wire[7:0]   ImmData;
wire[7:0]   ExternVal;
wire        Sel;
assign      ExternVal = Sel  ? ExternVal_i : ImmData;

wire    CmdHalt;
CmdDecoder cmddecoder0(
    .clk            (clk),
    .rstn           (rstn),
    .cmd            (Cmd_i),
    .RegSel0_o      (RegSel0),
    .RegSel1_o      (RegSel1),
    .RegSrc_o       (RegSrc),
    .ALUSel_o       (ALUSel),
    .RDOnly_o       (RDOnly),
    .ImmData_o      (ImmData),
    .RDRequest_o    (RDRequest_o),
    .WRRequest_o    (WRRequest_o),
    .Halt_o         (CmdHalt),
    .ExternSel_o    (Sel)
);


wire    CalculateHalt;
Calculate   calculate0(
    .clk            (clk),
    .rstn           (rstn),
    .RegSel0_i      (RegSel0),
    .RegSel1_i      (RegSel1),
    .RegSrc_i       (RegSrc),
    .ALUSel_i       (ALUSel),
    .RDOnly_i       (RDOnly),
    .ExternVal_i    (ExternVal),
    .Regs_o         (Regs_o),
    .Halt_o         (CalculateHalt),
    .ExternVal_o    (ExternVal_o),
    .ExternAddr_o   (ExternAddr_o)
);  

assign Halt_o = CalculateHalt | CmdHalt;


endmodule