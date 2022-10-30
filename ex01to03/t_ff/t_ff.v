module t_ff (Clk, T);
    input Clk, T;
    output Q;
    reg Q;

    always @(posedge Clk) begin
        if (T == 1'b1) begin
            Q <= ~Q;
        end
    end
endmodule