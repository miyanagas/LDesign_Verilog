module counter_4bit_enable (Clk, EN, RSTB, Q);
    input Clk, EN, RST;
    output [3:0] Q;
    wire [3:0] Q;
    reg [3:0] Count;

    assign Q = Count;
    always @(posedge Clk or negedge RSTB) begin
        if (RSTB == 1'b0) begin
            Count <= 1'b0;
        end
        else begin
            if (EN == 1'b1) begin
                Count <= Count + 1'b1;
            end
        end
    end
endmodule