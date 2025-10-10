`timescale 1ns / 1ps

module bin2bcd_tb();
    reg clk, rst;
    reg [3:0] bin;
    wire [7:0] bcd;
    
    bin2bcd b2b(clk, rst, bin, bcd);
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        #15 rst <= 0;
        
        #10 bin <= 0;
        #10 bin <= 1;
        #10 bin <= 2;
        #10 bin <= 3;
        #10 bin <= 4;
        #10 bin <= 5;
        #10 bin <= 6;
        #10 bin <= 7;
        #10 bin <= 8;
        #10 bin <= 9;
        #10 bin <= 10;
        #10 bin <= 11;
        #10 bin <= 12;
        #10 bin <= 13;
        #10 bin <= 14;
        #10 bin <= 15;
        
        $stop;
    end
    
    always begin
        #5 clk <= ~clk;
    end
endmodule
