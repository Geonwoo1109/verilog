// sub module

module oneshot_universal(clk, rst, btn, btn_trig);    
    input clk, rst;
    
    parameter WIDTH = 6;
    input [WIDTH-1:0] btn;
    reg [WIDTH-1:0] btn_reg;
    output reg [WIDTH-1:0] btn_trig;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_reg <= {WIDTH{1'b0}};
            btn_trig <= {WIDTH{1'b0}};
        end
        else begin
            btn_reg <= btn;
            btn_trig <= btn & ~btn_reg;
        end
    end
endmodule
