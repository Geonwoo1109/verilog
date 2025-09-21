`timescale 1ns / 1ps

module Tflipflop_tb();
    reg clk, T;
    wire Q;
    
    reg rst;
    
    Tflipflop FF(clk, T, Q, rst);
    
    initial begin
        clk <= 0;
        rst <= 1;
        T <= 0; 
        #15 rst <= 0;
        
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        
        $stop;
    end
    
    always begin
        #1 clk <= ~clk;
    end
    
endmodule
