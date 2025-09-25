`timescale 1ns / 1ps

module upCounter_2bit_tb();
    reg clk, rst, x;
    wire [1:0] state;
    
    upCounter_2bit NC (clk, rst, x, state);
    
    initial begin
        clk <= 0;
        x <= 0;
        rst <= 1;
        #15 rst <= 0;
        x <= 1;
        
        #50 x <= 0;
        #10 x <= 1;
        #30
        
        $stop;
    end
    
    always begin
        #5 clk <= ~clk;
    end
endmodule
