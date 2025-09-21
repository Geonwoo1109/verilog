`timescale 1ns / 1ps

module Dflipflop_tb();
    reg clk, D;
    wire Q;
    
    Dflipflop FF(clk, D, Q);
    
    initial begin
        clk <= 0;
        #30 D <= 0;
        #30 D <= 1;
        #30 D <= 0;
        #30 D <= 1;
        #30 D <= 0;
        #30 D <= 1;
    end
    
    always begin
        #5 clk <= ~clk;
    
   end
    
endmodule
