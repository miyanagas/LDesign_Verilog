module jk_ff (Clk, J, K, Q);
    input Clk, J, K;
    output Q;
    reg Q;

    always @(posedge Clk) begin
        if (J == 1'b1 && K == 1'b1) begin
            Q <= ~Q;
        end
        else begin
            if (J | K == 1'b1) begin
                Q <= J;
            end
        end
    end
endmodule