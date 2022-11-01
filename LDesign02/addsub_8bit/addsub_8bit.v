module d_ff (Clk, D, Resetn, Q);
    parameter bitwidth = 8;
    input Clk, Resetn;
    input [bitwidth-1:0] D;
    output [bitwidth-1:0] Q;
	reg [bitwidth-1:0] Q;

    always @(posedge Clk) begin
        if (!Resetn) begin
            Q <= 0;
        end
        else begin
            Q <= D;
        end
    end
endmodule

module full_adder (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    assign S = (A ^ B) ^ Cin;
    assign Cout = (B & Cin) | (A & (B | Cin));
endmodule

module addsub (A, Sin, Mode, Sout, OF);
    input [7:0] A, Sin;
    input Mode;
    output [7:0] Sout;
    output OF;
    wire [7:0] a, c;

    assign a = (Mode) ? ~A + 1 : A;
    full_adder fa0(a[0], Sin[0], 1'b0, Sout[0], c[0]);
    full_adder fa1(a[1], Sin[1], c[0], Sout[1], c[1]);
    full_adder fa2(a[2], Sin[2], c[1], Sout[2], c[2]);
    full_adder fa3(a[3], Sin[3], c[2], Sout[3], c[3]);
    full_adder fa4(a[4], Sin[4], c[3], Sout[4], c[4]);
    full_adder fa5(a[5], Sin[5], c[4], Sout[5], c[5]);
    full_adder fa6(a[6], Sin[6], c[5], Sout[6], c[6]);
    full_adder fa7(a[7], Sin[7], c[6], Sout[7], c[7]);
    assign OF = ((a[7] == Sin[7]) && (Sout[7] != a[7])) ? 1'b1 : 1'b0;
    //assign Sout = (Mode) ? Sin - A : Sin + A;
    //assign OF = ((A[7] == Sin[7]) && (Sout[7] != A[7])) ? 1'b1 : 1'b0;
endmodule

module addsub_8bit (Clk, A, Mode, Resetn, S, OF);
    input Clk, Mode, Resetn;
    input [7:0] A;
    output [7:0] S;
    output OF;
    wire [7:0] a, s_in, s_out;
    wire D, Q;

    d_ff RegA(Clk, A, Resetn, a);
    addsub AddSub(a, s_out, Mode, s_in, D);
    d_ff RegB(Clk, s_in, Resetn, s_out);
    d_ff #(1) D_FF(Clk, D, Resetn, Q);
    assign S = s_out;
    assign OF = Q;
endmodule