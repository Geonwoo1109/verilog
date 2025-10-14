`timescale 1us / 1ns        // 1us / 1ns: 1MHz frequancy / resolution

module LED3_control_tb();
    reg clk, rst;
    reg [7:0] btn;
    
    // reg [7:0] cnt;
    
    wire [23:0] state;
    
    wire [3:0] ledR, ledG, ledB;
    
    LED3_control c2(clk, rst, btn, state, ledR, ledG, ledB);
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        #15 rst <= 0;
        
        #15 btn   <= 8'b00000001;
        #1e+4 btn <= 8'b00000010;
        #1e+4 btn <= 8'b00000100;
        #1e+4 btn <= 8'b00001000;
        #1e+4 btn <= 8'b00010000;
        #1e+4 btn <= 8'b00100000;
        #1e+4 btn <= 8'b01000000;
        #1e+4 btn <= 8'b10000000;
        #1e+4
        
        $stop;
    end
    
    always begin
        #0.5 clk <= ~clk;
    end
endmodule
