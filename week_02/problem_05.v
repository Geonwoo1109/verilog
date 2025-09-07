module half_adder (
    input wire x, y,
    output wire c, s
);
    assign c = x & y;
    assign s = x ^ y;
endmodule
