module regX (cur_st, D, Q);
    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    input [2:0] cur_st;
    input [3:0] D;
    output [7:0] Q;
	reg [7:0] Q;

    always @(cur_st) begin
        if (cur_st == I) begin
            Q <= D;
        end
        else begin
            if (cur_st == A0 || cur_st == A1 || cur_st == A2 ||cur_st == A3) begin
                Q <= Q << 1;
            end
            else begin
                if (cur_st == F) begin
                    Q <= Q;
                end
            end
        end
    end
endmodule

module regY (cur_st, D, Q);
    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    input [2:0] cur_st;
    input [3:0] D;
    output [3:0] Q;
	reg [3:0] Q;

    always @(cur_st) begin
        if (cur_st == I) begin
            Q <= D;
        end
        else begin
            if (cur_st == A0 || cur_st == A1 || cur_st == A2 ||cur_st == A3) begin
                Q <= Q >> 1;
            end
            else begin
                if (cur_st == F) begin
                    Q <= Q;
                end
            end
        end
    end
endmodule

module regM (cur_st, D, Q);
    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    input [2:0] cur_st;
    input [7:0] D;
    output [7:0] Q;
	reg [7:0] Q;

    always @(cur_st) begin
        if (cur_st == I) begin
            Q <= 0;
        end
        else begin
            if (cur_st == A0 || cur_st == A1 || cur_st == A2 ||cur_st == A3) begin
                Q <= D;
            end
            else begin
                if (cur_st == F) begin
                    Q <= Q;
                end
            end
        end
    end
endmodule

module adder (Xin, Y_lsb, M, Q);
    input [7:0] Xin, M;
    input Y_lsb;
    output [7:0] Q;

    assign Q = (Y_lsb) ? Xin + M : M;
endmodule

module multiplier_4bit (Clk, Xin, Y, Resetn, M);
    input Clk, Resetn;
    input [3:0] Xin, Y;
    output [7:0] M;
    wire [7:0] xout, mout, Q;
    wire [3:0] yout;

    parameter I = 3'b000, A0 = 3'b001, A1 = 3'b010,
                A2 = 3'b011, A3 = 3'b100, F = 3'b101;
    reg [2:0] cur_st, next_st;

    regX reg_x(cur_st, Xin, xout);
    regY reg_y(cur_st, Y, yout);
    adder Adder(xout, yout[0], mout, Q);
    regM reg_m(cur_st, Q, mout);
    assign M = mout;

    always @(posedge Clk) begin
        if (!Resetn) begin
            cur_st <= I;
        end
        else begin
            cur_st <= next_st;
        end
    end

    always @(cur_st) begin
        case (cur_st)
            I: next_st = A0;
            A0: next_st = A1;
            A1: next_st = A2;
            A2: next_st = A3;
            A3: next_st = F;
            F: next_st = F;
            default: next_st = 3'bxxx;
        endcase
    end
endmodule