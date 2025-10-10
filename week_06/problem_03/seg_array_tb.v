`timescale 1ns / 1ps

module seg_array_tb();
    reg clk, rst, btn;
    // reg [7:0] state_bcd;
    wire [3:0] state_bin;
    wire [7:0] seg_data;
    wire [7:0] seg_sel;
    
    seg_array sa(clk, rst, btn, state_bin, btn_trig, seg_data, seg_sel);
    
    initial begin
        clk <= 0;
        rst <= 1;
        btn <= 0;
        
        #15 rst <= 0;
        
        repeat (20) begin
            #20 btn <= 1;
            #20 btn <= 0;
        end
        
        $stop;
    end
    
    always begin
        #5 clk <= ~clk;
    end
    
endmodule
