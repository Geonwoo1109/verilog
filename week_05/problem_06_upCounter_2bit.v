module upCounter_2bit(clk, rst, x, state);
    input wire clk, rst, x;
    reg x_reg, x_trig;
    output reg [1:0] state;
    
    always @(posedge rst or posedge clk) begin
        if (rst) x_trig <= 0;
        else x_trig <= x;
        
    /*
        if (rst) {x_reg, x_trig} <= 2'b00;
        else begin
            x_reg <= x;
            x_trig <= x & ~x_reg;
        end
        */
    end
    
    always @(posedge rst or posedge clk) begin
        if (rst) state <= 2'b00;
        else begin
            case (state)
                2'b00: state <= x_trig ? 2'b01 : 2'b00;
                2'b01: state <= x_trig ? 2'b10 : 2'b01;
                2'b10: state <= x_trig ? 2'b11 : 2'b10;
                2'b11: state <= x_trig ? 2'b00 : 2'b11;
            endcase
        end
    end
    
endmodule
