`timescale 1ns / 1ps

module decoder_3to8_tb();
    reg x, y, z;
    wire [7:0] D;
    
    decoder_3to8 uut (
        .x(x), .y(y), .z(z),
        .D(D)
    );
    
   initial begin
       x = 1'b0; y = 1'b0; z = 1'b0;    #10
       x = 1'b0; y = 1'b0; z = 1'b1;    #10
       x = 1'b0; y = 1'b1; z = 1'b0;    #10
       x = 1'b0; y = 1'b1; z = 1'b1;    #10
       x = 1'b1; y = 1'b0; z = 1'b0;    #10
       x = 1'b1; y = 1'b0; z = 1'b1;    #10
       x = 1'b1; y = 1'b1; z = 1'b0;    #10
       x = 1'b1; y = 1'b1; z = 1'b1;    #10
       
       $stop;
   end 
endmodule
