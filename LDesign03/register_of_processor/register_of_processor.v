module register (Clk, D, EN, Resetn, Q);
    input Clk, EN, Resetn;
    input [7:0] D;
    output [7:0] Q;
    reg [7:0] Q;

    always @(posedge Clk or negedge Resetn) begin
        if (!Resetn) begin
            Q <= 0;
        end
        else begin
            if (EN) begin
                Q <= D;
            end
        end
    end
endmodule

module mux_8bit_5to1 (S, R0, R1, R2, R3, DIN, OUT);
    input [4:0] S;
    input [7:0] R0, R1, R2, R3, DIN;
    output [7:0] OUT;

    assign OUT = 
        (S == 5'b00001) ? R0 : (
        (S == 5'b00010) ? R1 : (
        (S == 5'b00100) ? R2 : (
        (S == 5'b01000) ? R3 : (
        (S == 5'b10000) ? DIN : 8'bxxxx_xxxx))));
endmodule

module register_of_processor (Clk, S, R0in, R1in, R2in, R3in, DIN, Resetn, OUT_R0, OUT_R1, OUT_R2, OUT_R3, Bus);
    input Clk, R0in, R1in, R2in, R3in, Resetn;
    input [4:0] S;
    input [7:0] DIN;
    output [7:0] OUT_R0, OUT_R1, OUT_R2, OUT_R3, Bus;
    wire [7:0] IN_R0, IN_R1, IN_R2, IN_R3, OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_MUX;

    register R0(Clk, IN_R0, R0in, Resetn, OUT_R0);
    register R1(Clk, IN_R1, R1in, Resetn, OUT_R1);
    register R2(Clk, IN_R2, R2in, Resetn, OUT_R2);
    register R3(Clk, IN_R3, R3in, Resetn, OUT_R3);
    mux_8bit_5to1 MUX(S, OUT_R0, OUT_R1, OUT_R2, OUT_R3, DIN, OUT_MUX);
    assign IN_R0 = OUT_MUX;
    assign IN_R1 = OUT_MUX;
    assign IN_R2 = OUT_MUX;
    assign IN_R3 = OUT_MUX;
    assign Bus = OUT_MUX;
endmodule