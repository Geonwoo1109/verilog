module counter8(clk, rst, cnt);
    input clk, rst;
    output reg [7:0] cnt;
    
    always @(posedge clk or posedge rst) begin
        if (rst) cnt <= 8'b0000_0000;
        else cnt <= cnt + 1;        // stack overflow
    end
endmodule
