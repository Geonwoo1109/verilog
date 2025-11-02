`timescale 1ns / 1ps

module LCD_cursor_tb();
    reg clk, rst;
    
    reg [9:0] number_btn;
    reg [1:0] control_btn;
    
    wire [7:0] LCD_DATA;
    
    
    LCD_cursor LCD1(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);
    
    initial begin
        clk <= 0;
        rst <= 1;
        number_btn <= 0;
        control_btn <= 0;
        
        #1e+6 rst <= 0;
        
        #1e+6 number_btn <= 10'b1000_0000_00;   // 1
        #1e+6 number_btn <= 10'b0000_0000_10;   // 9
        #1e+6 number_btn <= 10'b0000_0000_00;   // none
        #1e+6 control_btn <= 2'b10;   // left
        #1e+6 control_btn <= 2'b01;   // right
        #1e+6 control_btn <= 2'b00;   // none
        #1e+6;
        
        $stop;
    end
    
    always begin
        #15 clk <= ~clk;
    end
endmodule
