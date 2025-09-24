module Tflipflop_oneShot(clk, rst, T, Q);
    input wire clk, rst, T;
    output reg Q;
    
    reg T_reg;
    
    always @(posedge clk or negedge !rst) begin
        if (rst) begin
            Q <= 0;
            T_reg <= 0;
        end
        else begin
            T_reg <= T;
            if (T & ~T_reg) Q <= ~Q;
        end
    end
    
    
            
    
endmodule
