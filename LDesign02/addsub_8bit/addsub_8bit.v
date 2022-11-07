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

  assign {Cout, S} = A + B + Cin;
endmodule

module addsub (A, B, MODE, S, OF);
  input [7:0] A, B;
  input MODE;
  output [7:0] S;
  output OF;
  wire [7:0] A_, Carry;

  assign A_ = (MODE) ? ~A + 8'b0000_0001 : A;
  full_adder fa0(A_[0], B[0], 1'b0, S[0], Carry[0]);
  full_adder fa1(A_[1], B[1], Carry[0], S[1], Carry[1]);
  full_adder fa2(A_[2], B[2], Carry[1], S[2], Carry[2]);
  full_adder fa3(A_[3], B[3], Carry[2], S[3], Carry[3]);
  full_adder fa4(A_[4], B[4], Carry[3], S[4], Carry[4]);
  full_adder fa5(A_[5], B[5], Carry[4], S[5], Carry[5]);
  full_adder fa6(A_[6], B[6], Carry[5], S[6], Carry[6]);
  full_adder fa7(A_[7], B[7], Carry[6], S[7], Carry[7]);
  assign OF = ((A_[7] == B[7]) && (Carry[7] != S[7])) ? 1'b1 : 1'b0;
endmodule

module addsub_8bit (Clk, A, MODE, Resetn, S, OF);
  input Clk, MODE, Resetn;
  input [7:0] A;
  output [7:0] S;
  output OF;
  wire [7:0] Aout, Sin, Sout;
  wire D, Q;

  d_ff RegA(Clk, A, Resetn, Aout);
  addsub AddSub(Aout, Sout, MODE, Sin, D);
  d_ff RegS(Clk, Sin, Resetn, Sout);
  d_ff #(1) D_FF(Clk, D, Resetn, Q);
  assign S = Sout;
  assign OF = Q;
endmodule