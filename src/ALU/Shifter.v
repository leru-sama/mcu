module shifter(
    input   wire[7:0]   D_i,
    input   wire[7:0]   Shift_i,
    input   wire        Dir_i,      //0: <<   ; 1: >>

    output  wire[7:0]   Q_o
);

assign Q_o = Dir_i ? D_i >> Shift_i : D_i << Shift_i;

endmodule