`timescale 1ns / 1ps

module DAC_tb();
    reg clk, rst;
    reg [5:0] btn;
    reg add_sel;
    
    wire [7:0] led_out, dac_d;
    
    DAC DAC1(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);
    
    parameter   zero  = 6'b000000,  // 0
                one   = 6'b100000,  // -1
                three = 6'b010000,  // +1
                four  = 6'b001000,  // -2
                six   = 6'b000100,  // +2
                seven = 6'b000010,  // -8
                nine  = 6'b000001;  // +8
    
    initial begin
        clk <= 0;
        rst <= 1;
        add_sel <= 0;
        btn <= 6'b000000;
        
        #1e+6 rst <= 0;
        
        #1e+6 btn <= nine;      // = +8
        #1e+6 btn <= one;       // = +7
        #1e+6 btn <= six;       // = +9
        #1e+6 btn <= seven;     // = +1
        #1e+6 btn <= three;     // = +2
        #1e+6 btn <= four;      // = 0
        #1e+6;
        
        $stop;
    end
    
    always begin
        #15 clk <= ~clk;
    end
endmodule
