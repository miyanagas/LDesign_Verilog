module decoder_to7 (Clk, I, Resetn, Q);
    input Clk, I, Resetn;
    output [6:0] Q;

    parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,
                S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111,
                S8 = 4'b1000, S9 = 4'b1001, S10 = 4'b1010, S11 = 4'b1011,
                S12 = 4'b1100;
    reg [3:0] cur_st, next_st;

    assign Q =
        (cur_st == S3) ? 7'b0001000 : (
        (cur_st == S4) ? 7'b0000011 : (
        (cur_st == S7) ? 7'b1000110 : (
        (cur_st == S8) ? 7'b0100001 : (
        (cur_st == S9) ? 7'b0000110 : (
        (cur_st == S11) ? 7'b0001110 : (
        (cur_st == S12) ? 7'b1110111 : 7'b1111111 ))))));

    always @(posedge Clk) begin
        if (!Resetn) begin
            cur_st <= S0;
        end
        else begin
            cur_st <= next_st;
        end
    end

    always @(cur_st or I) begin
        case (cur_st)
            S0: next_st = (I) ? S2 : S1;
            S1: next_st = (I) ? S4 : S3;
            S2: next_st = (I) ? S6 : S5;
            S5: next_st = (I) ? S8 : S7;
            S6: next_st = (I) ? S10 : S9;
            S10: next_st = (I) ? S12 : S11;
            default: next_st = (I) ? S2 : S1;
        endcase
    end
endmodule