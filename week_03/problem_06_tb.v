`timescale 1ns / 1ps

module priority_encoder_4to3_tb();
    reg d0, d1, d2, d3;
    wire x, y, V;
    
    priority_encoder_4to3 uut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .x(x), .y(y), .V(V)
    );
    
    initial begin
        d0 = 1'b0; d1 = 1'b0; d2 = 1'b0; d3 = 1'b0;     #10
        d0 = 1'b1; d1 = 1'b0; d2 = 1'b0; d3 = 1'b0;     #10
        d0 = 1'b1; d1 = 1'b0; d2 = 1'b1; d3 = 1'b1;     #10
        d0 = 1'b0; d1 = 1'b1; d2 = 1'b0; d3 = 1'b1;     #10
        d0 = 1'b0; d1 = 1'b0; d2 = 1'b0; d3 = 1'b1;     #10
    
        $stop;
    end 
endmodule
