module ALU(
    input   wire                clk,
    input   wire                rstn,

    input   wire[2:0]           Sel_i,

    input   wire[7:0]           D0_i,
    input   wire[7:0]           D1_i,

    output  wire[7:0]           Q_o,
    output  wire                Valid_o

);


wire[7:0]   AdderOut;

wire[7:0]   MulOut;

wire[7:0]   ShifterOut;

wire[7:0]   SubOut;


reg[7:0]    Result;
always @(*) begin

    case(Sel_i)
        3'h0:   Result <= 8'hx;
        3'h1:   Result <= AdderOut;
        3'h2:   Result <= MulOut;
        3'h3:   Result <= SubOut;
        3'h4:   Result <= ShifterOut;
        default Result <= 8'hx;
    endcase
end

/*
wire    valid;
assign valid = |Sel_i;

reg valid_reg;
always@(posedge clk or negedge rstn)begin
    if(~rstn)
        valid_reg <= 1'b0;
    else if(valid)
        valid_reg <= 1'b1;
    else 
        valid_reg <= 1'b0;
end
*/

assign Q_o      =   Result;
assign Valid_o  =   1'b1;



Adder   Adder0(
    .D0_i           (D0_i),
    .D1_i           (D1_i),
    .Q_o            (AdderOut)
);

Substracter   Sub0(
    .D0_i           (D0_i),
    .D1_i           (D1_i),
    .Q_o            (SubOut)
);

Multiplier   Multiplier0(
    .D0_i           (D0_i),
    .D1_i           (D1_i),
    .Q_o            (MulOut)
);

shifter   Shifter0(
    .D_i                (D0_i),
    .Shift_i            (D1_i),
    .Q_o                (ShifterOut)
);




endmodule