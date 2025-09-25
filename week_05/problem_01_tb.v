`timescale 1ns / 1ps

module stateMachine_tb();
    reg clk, rst, x;
    // reg [1:0] state;
    wire t;
    wire [1:0] state;
    
    stateMachine SM(clk, rst, x, y, state);
    
    initial begin
        clk <= 0;
        rst <= 1;
        x <= 0;
        // state <= 2'b00;
        #15 rst <= 0;
        
        #10 x <= 1; // state -> 01  4.1.1
        #10 x <= 0; // state -> 00  4.1.2
        
        #10 x <= 1; // state -> 01     
        #10 x <= 1; // state -> 11  4.1.3
        #10 x <= 1; // state -> 10     
        #10 x <= 0; // state -> 00  4.1.4
        
        #10 x <= 1; // state -> 01     
        #10 x <= 1; // state -> 11
        #10 x <= 1; // state -> 10
        #10 x <= 1; // state -> 10  4.1.5
        #10 x <= 0; // state -> 00
        
        #10 x <= 1; // state -> 01     
        #10 x <= 1; // state -> 11
        #10 x <= 0; // state -> 00  4.1.6
        #10
        
        $stop;
    end
        
    always begin
        #5 clk <= !clk;
    end
        

endmodule
