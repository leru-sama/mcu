`timescale 1ps/1ps
`include "./../cmd.v"
module  tb;

reg clk;
reg rstn;


reg[7:0]        ExternVal_i;
wire[7:0]       ExternVal_o;
wire            RDRequest_o;
wire            WRRequest_o;
wire[7:0]       ExternAddr_o;


reg[7:0]    cmd;


Kernel  u0(
    .clk            (clk),
    .rstn           (rstn),
    .Cmd_i          (cmd),
    .ExternVal_i    (ExternVal_i),
    .ExternVal_o    (ExternVal_o),
    .RDRequest_o    (RDRequest_o),
    .WRRequest_o    (WRRequest_o),
    .ExternAddr_o   (ExternAddr_o)
);


initial begin
    clk = 1;
    rstn = 0;
    #50
    rstn = 1;
    ExternVal_i = 8'h30;
    cmd = {`CMD_LDR,2'b0,3'b0};         //LDR R0 0x30
    #10
    ExternVal_i = 8'h0f;
    cmd = {`CMD_LDR,2'b11,3'b0};        //LDR R1 0x0f
    #10
    ExternVal_i = 8'hf0;
    cmd = {`CMD_LDR,2'b11,3'b0};        //LDR R1 0xf0

    #10 
    cmd = {`CMD_LDR,2'b01,3'b0};        //LDR R0 R1

    #10
    ExternVal_i = 8'h1;
    cmd = {`CMD_LDSP,2'b11,3'b0};       //LDR PC    0x1
    #10 
    ExternVal_i = 8'h2;
    cmd = {`CMD_LDSP,2'b11,3'b0};       //LDR PC 0x2

    #10
    ExternVal_i = 8'h1;
    cmd = {`CMD_LDSP,2'b10,3'b0};       //LDR PC    R0

    #100
    cmd = 0;

    #10
    cmd = {`CMD_ADD,2'b01,3'b0};        //ADD R0 R0 R1
    #10
    cmd = {`CMD_ADD,2'b00,3'h1};        //ADD R0 R0 #0x4
    #10 
    cmd = {`CMD_LDR,2'b01,3'b0};        //LDR R0 [R1]
    #10
    cmd = {`CMD_STR,2'b01,3'b0};        //STR R0 [R1]
    #10
    cmd = 0;
end


always #5 clk = ~clk;

endmodule