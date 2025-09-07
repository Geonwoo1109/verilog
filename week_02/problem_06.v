module half_adder (
    input wire x, y,
    output reg c, s
);
    always @(*) begin
        case ({x, y})
            2'b00: {c, s} = 2'b00;
            2'b01: {c, s} = 2'b01;
            2'b10: {c, s} = 2'b01;
            2'b11: {c, s} = 2'b10;
        endcase
    end
endmodule

module half_adder_2 (
    input wire x, y,
    output reg c, s
);
    always @(*) begin
        case ({A, B})   // A와 B를 2비트 벡터로 묶음
            2'b00: begin s = 0; c = 0; end // 0 + 0
            2'b01: begin s = 1; c = 0; end // 0 + 1
            2'b10: begin s = 1; c = 0; end // 1 + 0
            2'b11: begin s = 0; c = 1; end // 1 + 1
        endcase
    end
endmodule
