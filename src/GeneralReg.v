module GeneralReg(
    input   wire                clk,
    input   wire                rstn,

    input   wire[2:0]           SrcSel_i,
    input   wire                en_i,

    input   wire[7 : 0]         Src0_i,
    input   wire[7 : 0]         Src1_i,
    input   wire[7 : 0]         Src2_i,
    input   wire[7 : 0]         Src3_i,
    input   wire[7 : 0]         Src4_i,
    input   wire[7 : 0]         Src5_i,
    input   wire[7 : 0]         Src6_i,
    input   wire[7 : 0]         Src7_i,
    


    output  wire[7 : 0]         Reg_o

);

reg[7 : 0]    SelData;
always @(*) begin
    case(SrcSel_i)
        3'h0:       SelData <= Src0_i;
        3'h1:       SelData <= Src1_i;
        3'h2:       SelData <= Src2_i;
        3'h3:       SelData <= Src3_i;
        3'h4:       SelData <= Src4_i;
        3'h5:       SelData <= Src5_i;
        3'h6:       SelData <= Src6_i;
        3'h7:       SelData <= Src7_i;
        default:    SelData <= 8'hx;
    endcase
end

reg[7 : 0]    RegData;
always @(posedge clk or negedge rstn) begin
    if(~rstn)   
        RegData <= 8'h0;
    else if(en_i) 
        RegData <= SelData;
    else        
        RegData <= RegData;
end

assign Reg_o = RegData;

endmodule