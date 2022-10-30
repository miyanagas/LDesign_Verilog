module decoder_4x7 (switch, display);
    input [3:0] switch;
    output [6:0] display;

    always @(switch) begin
        case (switch)
            4'b0000: display = 7'b1000000; /* 0 */
            4'b0001: display = 7'b1111001; /* 1 */
            4'b0010: display = 7'b0100100; /* 2 */
            4'b0011: display = 7'b0110000; /* 3 */
            4'b0100: display = 7'b0011001; /* 4 */
            4'b0101: display = 7'b0010010; /* 5 */
            4'b0110: display = 7'b0000010: /* 6 */
            4'b0111: display = 7'b1011001; /* 7 */
            4'b1000: display = 7'b0000000; /* 8 */
            4'b1001: display = 7'b0010000; /* 9 */
            4'b1010: display = 7'b0001000; /* A */
            4'b1011: display = 7'b0000011; /* B */
            4'b1100: display = 7'b1000110; /* C */
            4'b1101: display = 7'b0100001; /* D */
            4'b1110: display = 7'b0000110; /* E */
            4'b1111: display = 7'b0001110; /* F */
            default: display = 7'bxxxxxxx;
        endcase
    end
endmodule

/*
    出力信号　ピン名
    display[0]  HEX0_D[0]
    display[1]  HEX0_D[1]
    display[2]  HEX0_D[2]
    display[3]  HEX0_D[3]
    display[4]  HEX0_D[4]
    display[5]  HEX0_D[5]
    display[6]  HEX0_D[6]
*/