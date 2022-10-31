module d_latch (EN, D, Q);
    input EN, D;
    output Q;
    reg Q;

    always @(EN or D) begin
        if (EN) begin
            Q <= D;
        end
    end
endmodule

module d_ff (Clk, D, Q);
    input Clk, D;
    output Q;
    wire Q1, Q2;

    d_latch master_latch(~Clk, D, Q1);
    d_latch slave_latch(Clk, Q1, Q2);
    assign Q = Q2;
endmodule