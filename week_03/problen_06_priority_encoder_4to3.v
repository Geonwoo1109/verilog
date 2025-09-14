module priority_encoder_4to3(d0, d1, d2, d3, x, y, V);
    input wire d0, d1, d2, d3;
    output wire x, y, V;
    
    assign x = d3 | d2;
    assign y = d3 | ((~d2) & d1);
    assign V = d3 | d2 | d1 | d0;

endmodule
