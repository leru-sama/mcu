module Calculate(
    input   wire            clk,
    input   wire            rstn,

    //2 operate reg
    //src R1   dst R0
    input   wire[1:0]       RegSel0_i,
    input   wire[1:0]       RegSel1_i,
    input   wire[2:0]       RegSrc_i,  //[3]: ALUen [2:0]  operation
    input   wire[2:0]       ALUSel_i,
    input   wire            RDOnly_i,

    output  wire[31:0]      Regs_o,
    input   wire[7:0]       ExternVal_i,

    output  wire[7:0]       ExternVal_o,
    output  wire[7:0]       ExternAddr_o,

    output  wire            Halt_o

);
genvar i;

wire    [7:0]   reg0;
wire    [7:0]   reg1;

/*******************ALU MUX*******************/
reg     [7:0]   ALUData0;
always @(*) begin
    case(RegSel0_i)
    2'h0:   ALUData0 <= reg0;
    2'h1:   ALUData0 <= reg1;

    2'h3:   ALUData0 <= ExternVal_i;
    default:ALUData0 <= 8'hx;
    endcase
end

reg     [7:0]   ALUData1;
always @(*) begin
    case(RegSel1_i)
    2'h0:   ALUData1 <= reg0;
    2'h1:   ALUData1 <= reg1;

    2'h3:   ALUData1 <= ExternVal_i;
    default:ALUData1 <= 8'hx;
    endcase
end


wire    [7:0]   ALUQ;
wire            ALUValid;
ALU ALU0(
    .clk            (clk),
    .rstn           (rstn),
    .Sel_i          (ALUSel_i),
    .D0_i           (ALUData0),
    .D1_i           (ALUData1),
    .Q_o            (ALUQ),
    .Valid_o        (ALUValid)
);




/*********************2regs and pc 、 lr*******************/

wire    [31:0]  gereal_regs;
wire    [3:0]   RegEn;

generate
    for(i=0;i<4;i=i+1)  begin
        assign RegEn[i] = i==RegSel0_i    ? 1'b1 : 1'b0;
    end
endgenerate


reg     ALU_On;
always @(posedge clk or negedge rstn) begin
    if(~rstn) 
        ALU_On <= 1'b0;
    else if(|ALUSel_i)
        ALU_On <= 1'b1;
    else 
        ALU_On <= 1'b0;
end

wire    ALU;
assign ALU = |ALUSel_i | ALU_On;


wire    [7:0]   PC;
wire    [7:0]   LR;

generate
    for(i = 0 ;i < 4; i = i + 1)
        GeneralReg  Reg(
            .clk            (clk),
            .rstn           (rstn),

            .en_i           (RegEn[i] & ~RDOnly_i & (|ALUSel_i ?  ALUValid : 1'b1)),
            .SrcSel_i       (RegSrc_i),
            
            .Reg_o          (gereal_regs[8*i+7:8*i]),
            .Src0_i         (reg0),
            .Src1_i         (reg1),
            .Src4_i         (ExternVal_i),
            .Src3_i         (LR),
            .Src2_i         (PC),
            .Src7_i         (ALUQ)
        );
endgenerate




assign reg0 = gereal_regs[7:0];
assign reg1 = gereal_regs[15:8];
assign PC   = gereal_regs[23:16];
assign LR   = gereal_regs[31:24];



/**************extern value*******************/
reg[7:0]    ExternVal;
always @(*) begin
    case(RegSel0_i)
    2'h0:   ExternVal <= reg0;
    2'h1:   ExternVal <= reg1;
    2'h2:   ExternVal <= PC;
    2'h3:   ExternVal <= LR;
    default:ExternVal <= 2'hx;
    endcase
end

assign Halt_o = ALU ? ~ALUValid : 1'b0;
assign Regs_o  = gereal_regs;
assign ExternVal_o  = ExternVal;
assign ExternAddr_o = |RegSel1_i ? reg1 : reg0;

endmodule