`timescale 1us / 1ns        // 1us / 1ns: 1MHz frequancy / resolution

module LED_control_tb();
    reg clk, rst;
    reg [7:0] bin;
    wire [7:0] cnt;
    
    wire [7:0] seg_data, seg_sel;
    wire led_signal;
    
    LED_control c1(clk, rst, bin, cnt, seg_data, seg_sel, led_signal);
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        #15 rst <= 0;
        
        #15 bin <= 8'd0;
        #1e+6 bin <= 8'd64;
        #1e+6 bin <= 8'd128;
        #1e+6 bin <= 8'd191;
        #1e+6 bin <= 8'd255;
        #1e+6
        
        $stop;
    end
    
    always begin
        #0.5 clk <= ~clk;       // 1 MHz
    end
endmodule
