module mux_3bit_5to1 (
    I0, I1, I2, I3, I4, S, O
);
    input [2:0] I0, I1, I2, I3, I4, S;
    output [2:0] O;

    assign O = mux_5to1_func(I0, I1, I2, I3, I4, S);

    function[2:0] mux_5to1_func;
        input [2:0] i0, i1, i2, i3, i4, s;
        reg [2:0] out;

        begin
            case (s)
                3'b000: out = i0;
                3'b001: out = i1;
                3'b010: out = i2;
                3'b011: out = i3;
                3'b100: out = i4;
            endcase
            mux_5to1_func = out;
        end
    endfunction
endmodule