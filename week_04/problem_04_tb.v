`timescale 1ns / 1ps

module JKflipflop_tb();
    reg clk, J, K;
    wire Q;
    
    JKflipflop FF(clk, J, K, Q);
    
    initial begin
        clk <= 0;
        J <= 0; K <= 0;
        #30 J <= 0; K <= 1;
        #30 J <= 0; K <= 0;
        #30 J <= 1; K <= 0;
        #30 J <= 0; K <= 0;
        #30 J <= 1; K <= 1;
        #30 J <= 0; K <= 0;
        
        $stop;
    end
    
    always begin
        #3 clk <= ~clk;
    end
    
endmodule
