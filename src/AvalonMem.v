module  AvalonMem(
    input   wire                clk,
    input   wire                rstn,
    input   wire    [5:0]      AvalonAddr_i,
    input   wire                AvalonRead_i,
    input   wire                AvalonWrite_i,
    output  wire    [7:0]     AvalonReadData_o,
    input   wire    [7:0]     AvalonWriteData_i,
    input   wire                AvalonLock_i,
    output  wire                AvalonWaitReq_o
);

reg     [7:0] Mem [5:0];

initial begin
    $readmemh("F:/code/Soc/mcu/src/code.hex",Mem);
end



reg     [5:0]  ReadAddr;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        ReadAddr    <=  8'h0;
    else if(AvalonRead_i)
        ReadAddr    <=  AvalonAddr_i[5:0];
end

always@(posedge clk) begin
    if(AvalonWrite_i)
        Mem[AvalonAddr_i]    <=  AvalonWriteData_i;
end

assign  AvalonReadData_o    =   Mem[ReadAddr];
//assign  AvalonReadData_o    =   {4{8'h3,8'h2,8'h1,8'h0}};

assign  AvalonWaitReq_o =   1'b0;

endmodule



