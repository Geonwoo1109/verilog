module updownCounter_3bit(clk, rst, x, y, state);
    input wire clk, rst, x;     // x ? enable : disable
    output reg y;               // y ? up : down
    output reg [2:0] state;
    
    // x
    always @(posedge rst or posedge clk) begin
        
    end
    
    //state
    always @(posedge rst or posedge clk) begin
        if (rst) begin
            y <= 0;
            state <= 3'b000;
        end
        else begin
            if (!y) begin
                case (state)
                    3'b000: state <= x ? 3'b001 : 3'b000;
                    3'b001: state <= x ? 3'b010 : 3'b001;
                    3'b010: state <= x ? 3'b011 : 3'b010;
                    3'b011: state <= x ? 3'b100 : 3'b011;
                    3'b100: state <= x ? 3'b101 : 3'b100;
                    3'b101: state <= x ? 3'b110 : 3'b101;
                    3'b110: state <= x ? 3'b111 : 3'b110;
                    3'b111: begin
                            state <= x ? 3'b110 : 3'b111;
                            y <= x ? 1 : 0;
                        end
                endcase
            end
            else begin
                case (state)
                    3'b111: state <= x ? 3'b110 : 3'b111;
                    3'b110: state <= x ? 3'b101 : 3'b110;
                    3'b101: state <= x ? 3'b100 : 3'b101;
                    3'b100: state <= x ? 3'b011 : 3'b100;
                    3'b011: state <= x ? 3'b010 : 3'b011;
                    3'b010: state <= x ? 3'b001 : 3'b010;
                    3'b001: state <= x ? 3'b000 : 3'b001;
                    3'b000: begin
                            state <= x ? 3'b001 : 3'b000;
                            y <= x ? 0 : 1;
                        end
                endcase
            end
        end
    end
    
endmodule
