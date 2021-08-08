`timescale 1ps/1ps
module processor_tb;
    
reg             clk;
reg             rstn;
wire[7:0]       Addr;
wire[7:0]       RDData;
wire[7:0]       WRDATA;
wire            read;
wire            write;

Processor   u0(
    .clk                (clk),
    .rstn               (rstn),

    .LRMasterRD_o       (read),
    .LRMasterWR_o       (write),
    .LRMasterRDData_i   (RDData),
    .LRMasterWRData_o   (WRDATA),
    .LRMasterAddr_o     (Addr)
);


AvalonMem P0ram(
    .clk                    (clk),
    .rstn                   (rstn),
    .AvalonAddr_i           (Addr[5:0]),
    .AvalonRead_i           (read),
    .AvalonWrite_i          (write),
    .AvalonWriteData_i      (WRDATA),
    .AvalonReadData_o       (RDData)
);

initial begin
    rstn = 0;
    clk = 1;
    #10
    rstn = 1;
end
always #5 clk = ~clk;
endmodule