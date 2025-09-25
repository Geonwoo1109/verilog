module stateMachine(clk, rst, x, y, state);
    input wire clk, rst, x;
    output reg y;
    output reg [1:0] state;
    
    always @(posedge rst or posedge clk) begin
        if (rst) state <= 2'b00;
        else begin
            case(state)
                2'b00: state <= x ? 2'b01 : 2'b00;
                2'b01: state <= x ? 2'b11 : 2'b00;
                2'b10: state <= x ? 2'b10 : 2'b00;
                2'b11: state <= x ? 2'b10 : 2'b00;
            endcase
        end
    end
    always @(posedge rst or posedge clk) begin
        if (rst) y <= 1'b0;
        else begin
            case(state)
                2'b00: y <= x ? 0 : 0;
                2'b01: y <= x ? 0 : 1;
                2'b10: y <= x ? 0 : 1;
                2'b11: y <= x ? 0 : 1;
            endcase
        end              
    end
endmodule
