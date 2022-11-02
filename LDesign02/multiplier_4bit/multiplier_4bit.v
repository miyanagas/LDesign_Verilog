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

module Adder (Xin, Y_lsb, M, Q);
    input [7:0] Xin, M;
    input Y_lsb;
    output [7:0] Q;

    assign Q = (Y_lsb) ? Xin + M : M;
endmodule

module multiplier_4bit (Clk, Xin, Yin, Resetn, M, reg_x_in, reg_y_in, reg_m_in, reg_x_out, reg_y_out, reg_m_out);
    input Clk, Resetn;
    input [3:0] Xin, Yin;
    output [7:0] M;
	output [7:0] reg_x_in, reg_m_in, reg_x_out, reg_m_out;
    output [3:0] reg_y_in, reg_y_out;
    reg [7:0] reg_x_in, reg_m_in;
    reg [3:0] reg_y_in;
    wire [7:0] reg_x_out, reg_m_out, adder_out;
    wire [3:0] reg_y_out;

    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    reg [2:0] cur_st, next_st;

    register regX(Clk, reg_x_in, reg_x_out);
    register #(4) regY(Clk, reg_y_in, reg_y_out);
    Adder adder(reg_x_out, reg_y_out[0], reg_m_out, adder_out);
    register regM(Clk, reg_m_in, reg_m_out);
    assign M = reg_m_out;

	always@(posedge Clk or negedge Resetn) begin
        if (!Resetn) begin
            cur_st <= I;
        end
        else begin
			cur_st <= next_st;
		end
	end

    always @(cur_st) begin
        begin
            case (cur_st)
                I: begin
                    reg_x_in <= {4'b0000, Xin};
                    reg_y_in <= Yin;
                    reg_m_in <= 0;
                    next_st <= A0;
                end
                A0: begin
                    reg_x_in <= reg_x_out << 1;
                    reg_y_in <= reg_y_out >> 1;
                    reg_m_in <= adder_out;
                    next_st <= A1;
                end
                A1: begin
                    reg_x_in <= reg_x_out << 1;
                    reg_y_in <= reg_y_out >> 1;
                    reg_m_in <= adder_out;
                    next_st <= A2;
                end
                A2: begin
                    reg_x_in <= reg_x_out << 1;
                    reg_y_in <= reg_y_out >> 1;
                    reg_m_in <= adder_out;
                    next_st <= A3;
                end
                A3: begin
                    reg_x_in <= reg_x_out << 1;
                    reg_y_in <= reg_y_out >> 1;
                    reg_m_in <= adder_out;
                    next_st <= F;
                end
                F: next_st <= F;
                default: next_st <= 3'bxxx;
            endcase
        end
    end
endmodule