`timescale 1ns / 1ps

module vendingMachine_tb();
    reg clk, rst, A, B, C;
    wire [2:0] state;
    wire y;
    
    vendingMachine vM (clk, rst, A, B, C, state, y);
    
    initial begin
        clk <= 0;
        rst <= 1;
        {A, B, C} <= 3'b000;
        #15 rst <= 0;
        
        #30 {A, B, C} <= 3'b100;
        #30 {A, B, C} <= 3'b010;
        #30 {A, B, C} <= 3'b100;
        #30 {A, B, C} <= 3'b010;
        #30 {A, B, C} <= 3'b001;
        #30 {A, B, C} <= 3'b000; rst <= 1;
        #30 rst <= 0;
        #30 {A, B, C} <= 3'b100;
        #30 {A, B, C} <= 3'b010;
        #30 {A, B, C} <= 3'b001;
        #30
        
        $stop;
    end
    
    always begin
        #5 clk <= ~clk;
    end
endmodule
