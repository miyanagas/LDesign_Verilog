module register (Clk, D, Q);
    parameter bitwidth = 8;
    input Clk;
    input [bitwidth-1:0] D;
    output [bitwidth-1:0] Q;
    reg [bitwidth-1:0] Q;

    always @(posedge Clk) begin
        Q <= D;
    end
endmodule

module adder (A, B, MODE, S);
    input [7:0] A, B;
    input MODE;
    output [7:0] S;

    assign S = (MODE) ? A + B : B;
endmodule

module multiplier_4bit (Clk, Xin, Yin, Resetn, M);
    input Clk, Resetn;
    input [3:0] Xin, Yin;
    output [7:0] M;
    reg [7:0] RegX_in, RegM_in, RegX_prev;
    reg [3:0] RegY_in, RegY_prev;
    wire [7:0] RegX_out, RegM_out, Adder_out;
    wire [3:0] RegY_out;

    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    reg [2:0] cur_st, next_st;

    register RegX(Clk, RegX_in, RegX_out);
    register #(4) RegY(Clk, RegY_in, RegY_out);
    register RegM(Clk, RegM_in, RegM_out);
    adder Adder(RegX_out, RegM_out, RegY_out[0], Adder_out);
    assign M = RegM_out;

	always@(posedge Clk) begin
        if (!Resetn) begin
            cur_st <= I;
        end
        else begin
            RegX_prev <= RegX_in;
            RegY_prev <= RegY_in;
			cur_st <= next_st;
		end
	end

    always @(cur_st) begin
        case (cur_st)
            I: begin
                RegX_in <= {4'b0000, Xin};
                RegY_in <= Yin;
                RegM_in <= 0;
                next_st <= A0;
            end
            A0: begin
                RegX_in <= RegX_prev << 1;
                RegY_in <= RegY_prev >> 1;
                RegM_in <= Adder_out;
                next_st <= A1;
            end
            A1: begin
                RegX_in <= RegX_prev << 1;
                RegY_in <= RegY_prev >> 1;
                RegM_in <= Adder_out;
                next_st <= A2;
            end
            A2: begin
                RegX_in <= RegX_prev << 1;
                RegY_in <= RegY_prev >> 1;
                RegM_in <= Adder_out;
                next_st <= A3;
            end
            A3: begin
                RegX_in <= RegX_prev << 1;
                RegY_in <= RegY_prev >> 1;
                RegM_in <= Adder_out;
                next_st <= F;
            end
            F: next_st <= F;
            default: next_st <= 3'bxxx;
        endcase
    end
endmodule