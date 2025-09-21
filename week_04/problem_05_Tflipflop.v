module Tflipflop(clk, T, Q, rst);
    input wire clk, T;
    output reg Q;
    
    input wire rst;
    
    
    always @(posedge clk) begin
        if (rst) Q <= 0;
        else begin
            case (T)
                1'b0: Q <= Q;
                1'b1: Q <= ~Q;
            endcase
        end
    end
endmodule
