module register (Clk, D, EN, Resetn, Q);
    input Clk, EN, Resetn;
    input [7:0] D;
    output [7:0] Q;
    reg [7:0] Q;

    always @(posedge Clk or negedge Resetn) begin
        if (!Resetn) begin
            Q <= 0;
        end
        else begin
            if (EN) begin
                Q <= D;
            end
        end
    end
endmodule

module mux_8bit_6to1 (S, R0, R1, R2, R3, DIN, G, OUT);
    input [5:0] S;
    input [7:0] R0, R1, R2, R3, DIN, G;
    output [7:0] OUT;

    assign OUT = 
        (S == 6'b000001) ? G : (
        (S == 6'b000010) ? R3 : (
        (S == 6'b000100) ? R2 : (
        (S == 6'b001000) ? R1 : (
        (S == 6'b010000) ? R0 : (
        (S == 6'b100000) ? DIN : 8'bxxxx_xxxx)))));
endmodule

module arithmetic_logic_unit (A, B, Mode, OUT);
    input Mode;
    input [7:0] A, B;
    output [7:0] OUT;

    assign OUT = (Mode) ? A - B : A + B;
endmodule

module control_unit (Clk, Run, IR, Resetn, R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Mode, Done);
    input Clk, Run, Resetn;
    input [6:0] IR;
    output R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Mode, Done;
    reg [6:0] in_ctrl;
    reg [5:0] out_ctrl;
    reg reg_Mode, reg_Done;
    reg [1:0] cur_st, next_st;
    parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
    parameter mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011;

    always @(posedge Clk or negedge Resetn) begin
        if (!Resetn) begin
            cur_st <= T0;
        end
        else begin
            if (Done) begin
                cur_st <= T0;
            end
            else begin
                cur_st <= next_st;
            end
        end
    end

    assign {DINout, R0out, R1out, R2out, R3out, Gout} = out_ctrl;
    assign {R0in, R1in, R2in, R3in, Ain, Gin, IRin} = in_ctrl;
    assign Mode = reg_Mode;
    assign Done = reg_Done;

    always @(cur_st or Run) begin
        case (cur_st)
            T0: begin
                out_ctrl = 6'b000000;
                in_ctrl = 7'b0000001;
                reg_Mode = 1'b0;
                reg_Done = 1'b0;
                next_st = (Run) ? T1 : T0;
            end
            T1: begin
                case (IR[6:4])
                    mv: begin
                        case (IR[1:0])
                            2'b00: out_ctrl = 6'b010000;
                            2'b01: out_ctrl = 6'b001000;
                            2'b10: out_ctrl = 6'b000100;
                            2'b11: out_ctrl = 6'b000010;
                        endcase
                        case (IR[3:2])
                            2'b00: in_ctrl = 7'b1000000;
                            2'b01: in_ctrl = 7'b0100000;
                            2'b10: in_ctrl = 7'b0010000;
                            2'b11: in_ctrl = 7'b0001000;
                        endcase
                        reg_Mode = 1'b0;
                        reg_Done = 1'b1;
                    end
                    mvi: begin
                        out_ctrl = 6'b100000;
                        case (IR[3:2])
                            2'b00: in_ctrl = 7'b1000000;
                            2'b01: in_ctrl = 7'b0100000;
                            2'b10: in_ctrl = 7'b0010000;
                            2'b11: in_ctrl = 7'b0001000;
                        endcase
                        reg_Mode = 1'b0;
                        reg_Done = 1'b1;
                    end
                    add: begin
                        case (IR[3:2])
                            2'b00: out_ctrl = 6'b010000;
                            2'b01: out_ctrl = 6'b001000;
                            2'b10: out_ctrl = 6'b000100;
                            2'b11: out_ctrl = 6'b000010;
                        endcase
                        in_ctrl = 7'b0000100;
                        reg_Mode = 1'b0;
                        reg_Done = 1'b0;
                        next_st = T2;
                    end
                    sub: begin
                        case (IR[3:2])
                            2'b00: out_ctrl = 6'b010000;
                            2'b01: out_ctrl = 6'b001000;
                            2'b10: out_ctrl = 6'b000100;
                            2'b11: out_ctrl = 6'b000010;
                        endcase
                        in_ctrl = 7'b0000100;
                        reg_Mode = 1'b0;
                        reg_Done = 1'b0;
                        next_st = T2;
                    end
                endcase
            end
            T2: begin
                case (IR[6:4])
                    add: begin
                        case (IR[1:0])
                            2'b00: out_ctrl = 6'b010000;
                            2'b01: out_ctrl = 6'b001000;
                            2'b10: out_ctrl = 6'b000100;
                            2'b11: out_ctrl = 6'b000010;
                        endcase
                        in_ctrl = 7'b0000010;
                        reg_Mode = 1'b0;
                        reg_Done = 1'b0;
                        next_st = T3;
                    end
                    sub: begin
                        case (IR[1:0])
                            2'b00: out_ctrl = 6'b010000;
                            2'b01: out_ctrl = 6'b001000;
                            2'b10: out_ctrl = 6'b000100;
                            2'b11: out_ctrl = 6'b000010;
                        endcase
                        in_ctrl = 7'b0000010;
                        reg_Mode = 1'b1;
                        reg_Done = 1'b0;
                        next_st = T3;
                    end
                endcase
            end
            T3: begin
                case (IR[6:4])
                    add: begin
                        out_ctrl = 6'b000001;
                        case (IR[3:2])
                            2'b00: in_ctrl = 7'b1000000;
                            2'b01: in_ctrl = 7'b0100000;
                            2'b10: in_ctrl = 7'b0010000;
                            2'b11: in_ctrl = 7'b0001000;
                        endcase
                        reg_Mode = 1'b0;
                        reg_Done = 1'b1;
                    end
                    sub: begin
                        out_ctrl = 6'b000001;
                        case (IR[3:2])
                            2'b00: in_ctrl = 7'b1000000;
                            2'b01: in_ctrl = 7'b0100000;
                            2'b10: in_ctrl = 7'b0010000;
                            2'b11: in_ctrl = 7'b0001000;
                        endcase
                        reg_Mode = 1'b0;
                        reg_Done = 1'b1;
                    end
                endcase
            end
            default: begin
                out_ctrl = 6'bxxxxxx;
                in_ctrl = 7'bxxxxxxx;
                reg_Mode = 1'bx;
                reg_Done = 1'bx;
                next_st = 3'bxxx;
            end
        endcase
    end

endmodule

module processor (Clk, Run, DIN, Resetn, OUT_IR, OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_A, OUT_G, OUT_MUX, Bus, R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Done);
    input Clk, Run, Resetn;
    input [7:0] DIN;
    output R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Done;
    output [7:0] OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_A, OUT_G, OUT_MUX, Bus;
	output[6:0] OUT_IR;
    wire R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Mode;
    wire [6:0] IN_IR, OUT_IR;
    wire [7:0] IN_R0, IN_R1, IN_R2, IN_R3, IN_A, OUT_R0, OUT_R1, OUT_R2, OUT_R3, OUT_A, OUT_G, OUT_MUX, OUT_ALU;

    assign IN_IR = DIN[6:0];
    register IR(Clk, IN_IR, IRin, Resetn, OUT_IR);
    control_unit ControlUnit(Clk, Run, OUT_IR, Resetn, R0in, R1in, R2in, R3in, Ain, Gin, IRin, R0out, R1out, R2out, R3out, Gout, DINout, Mode, Done);
    register R0(Clk, IN_R0, R0in, Resetn, OUT_R0);
    register R1(Clk, IN_R1, R1in, Resetn, OUT_R1);
    register R2(Clk, IN_R2, R2in, Resetn, OUT_R2);
    register R3(Clk, IN_R3, R3in, Resetn, OUT_R3);
    register A(Clk, IN_A, Ain, Resetn, OUT_A);
    arithmetic_logic_unit ALU(OUT_A, Bus, Mode, OUT_ALU);
    register G(Clk, OUT_ALU, Gin, Resetn, OUT_G);
    mux_8bit_6to1 MUX({DINout, R0out, R1out, R2out, R3out, Gout}, OUT_R0, OUT_R1, OUT_R2, OUT_R3, DIN, OUT_G, OUT_MUX);
    assign IN_A = OUT_MUX;
    assign IN_R0 = OUT_MUX;
    assign IN_R1 = OUT_MUX;
    assign IN_R2 = OUT_MUX;
    assign IN_R3 = OUT_MUX;
    assign Bus = OUT_MUX;
endmodule