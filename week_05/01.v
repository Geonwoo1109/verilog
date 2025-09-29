module stateMachine(clk, rst, x, y, state);
    input wire clk, rst, x;
    reg x_reg, x_trig;
    output reg y;
    output reg [1:0] state;
    
    // x
    always @(posedge rst or posedge clk) begin
        if (rst) {x_reg, x_trig} <= 2'b00;
        else begin
            x_reg <= x;
            x_trig <= x & ~x_reg;
        end
    end
    
    // state
    always @(posedge rst or posedge clk) begin
        if (rst) state <= 2'b00;
        else begin
            case(state)
                2'b00: state <= x_trig ? 2'b01 : 2'b00;
                2'b01: state <= x_trig ? 2'b11 : 2'b00;
                2'b10: state <= x_trig ? 2'b10 : 2'b00;
                2'b11: state <= x_trig ? 2'b10 : 2'b00;
            endcase
        end
    end
    always @(posedge rst or posedge clk) begin
        if (rst) y <= 1'b0;
        else begin
            case(state)
                2'b00: y <= x_trig ? 0 : 0;
                2'b01: y <= x_trig ? 0 : 1;
                2'b10: y <= x_trig ? 0 : 1;
                2'b11: y <= x_trig ? 0 : 1;
            endcase
        end              
    end
endmodule
