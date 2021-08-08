module Adder(
    input   wire[7:0]   D0_i,
    input   wire[7:0]   D1_i,

    output  wire[7:0]   Q_o
);

assign Q_o = D0_i + D1_i;

endmodule