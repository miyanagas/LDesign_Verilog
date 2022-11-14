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

module mux_8bit_6to1 (S, R0, R1, R2, R3, DIN, G, OUT);
    input [5:0] S;
    input [7:0] R0, R1, R2, R3, DIN, G;
    output [7:0] OUT;

    assign OUT = 
        (S == 6'b000001) ? G : (
        (S == 6'b000010) ? R0 : (
        (S == 6'b000100) ? R1 : (
        (S == 6'b001000) ? R2 : (
        (S == 6'b010000) ? R3 : (
        (S == 6'b100000) ? DIN : 8'bxxxx_xxxx)))));
endmodule

module arithmetic_logic_unit (A, B, Mode, OUT);
    input Mode;
    input [7:0] A, B;
    output [7:0] OUT;

    assign OUT = (Mode) ? A - B : A + B;
endmodule

module alu_of_processor (Clk, S, R0in, R1in, R2in, R3in, Ain, Gin, Mode, DIN, Resetn, OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_A, OUT_G, Bus);
    input Clk, R0in, R1in, R2in, R3in, Ain, Gin, Mode, Resetn;
    input [5:0] S;
    input [7:0] DIN;
    output [7:0] OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_A, OUT_G, Bus;
    wire [7:0] IN_R0, IN_R1, IN_R2, IN_R3, IN_A, OUT_MUX, OUT_ALU;

    register R0(Clk, IN_R0, R0in, Resetn, OUT_R0);
    register R1(Clk, IN_R1, R1in, Resetn, OUT_R1);
    register R2(Clk, IN_R2, R2in, Resetn, OUT_R2);
    register R3(Clk, IN_R3, R3in, Resetn, OUT_R3);
    register A(Clk, IN_A, Ain, Resetn, OUT_A);
    arithmetic_logic_unit ALU(OUT_A, Bus, Mode, OUT_ALU);
    register G(Clk, OUT_ALU, Gin, Resetn, OUT_G);
    mux_8bit_6to1 MUX(S, OUT_R0, OUT_R1, OUT_R2, OUT_R3, DIN, OUT_G, OUT_MUX);
    assign IN_A = OUT_MUX;
    assign IN_R0 = OUT_MUX;
    assign IN_R1 = OUT_MUX;
    assign IN_R2 = OUT_MUX;
    assign IN_R3 = OUT_MUX;
    assign Bus = OUT_MUX;
endmodule