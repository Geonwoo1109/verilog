`timescale 1us / 1ns

module text_LCD_basic_tb();
    reg clk, rst;
    wire [7:0] LCD_DATA;
    
    text_LCD_basic LCD1(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LCD_out);
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        #1e+6 rst <= 0; // delay 1s
        
        #1e+6;
        
        $stop;
        
        
    end
    
    always begin
        #15 clk <= ~clk;
    end
endmodule
