`timescale 1ns / 1ps

module Tflipflop_oneShot_tb();
    reg clk, rst, T;
    wire Q;
    
    Tflipflop_oneShot FF(clk, rst, T, Q);
    
    initial begin
        clk <= 0;
        rst <= 1;
        T <= 0;
        #15 rst <= 0;
        
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        #30 T <= 0;
        #30 T <= 1;
        
        $stop;
    
    end 
    always begin
        #3 clk <= ~clk;
    end
endmodule
