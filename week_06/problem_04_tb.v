`timescale 1us / 1ns    // 1 MHz

module piezo_tb();

    reg clk, rst;
    reg [7:0] btn;
    wire piezo;
    
    piezo_basic P1(clk, rst, btn, piezo);
    
    initial begin
        clk <= 0;
        rst <= 1;
        btn <= 8'b00000000;
        
        #1e+6; rst <= 0;    // 1 s
        
        #1e+6; btn <= 8'b00000001;
        #1e+6; btn <= 8'b00000010;
        #1e+6; btn <= 8'b00000100;
        #1e+6; btn <= 8'b00001000;
        #1e+6; btn <= 8'b00010000;
        #1e+6; btn <= 8'b00100000;
        #1e+6; btn <= 8'b01000000;
        #1e+6; btn <= 8'b10000000;
        #1e+6;
        
        
        $stop;
    end
    
    always begin
        #0.5 clk <= ~clk;
    end
endmodule
