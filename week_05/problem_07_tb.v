`timescale 1ns / 1ps

module updownCounter_3bit_tb();
    reg clk, rst, x;
    wire y;
    wire [2:0] state;
    
    updownCounter_3bit UDC (clk, rst, x, y, state);
    
    initial begin
        clk <= 0;
        x <= 0;
        rst <= 1;
        #15 rst <= 0;
        
        x <= 1;
        #100
        
        $stop;
    end
    
    always begin
        #2 clk <= ~clk;
    end
endmodule
