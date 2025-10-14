module LED3_control(clk, rst, btn, state, ledR, ledG, ledB);
    input clk, rst;
    input [7:0] btn;
    
    wire [7:0] cnt;     // 8-bit counter
    output reg [23:0] state;   // 8 + 8 + 8
    
    output reg [3:0] ledR, ledG, ledB;
    
    parameter red    = {8'd255, 8'd0, 8'd0};
    parameter orange = {8'd255, 8'd102, 8'd0};
    parameter yellow = {8'd255, 8'd255, 8'd0};
    parameter green  = {8'd0, 8'd255, 8'd0};
    parameter blue   = {8'd0, 8'd0, 8'd255};
    parameter indigo = {8'd0, 8'd0, 8'd128};
    parameter purple = {8'd128, 8'd0, 8'd128};
    parameter white  = {8'd255, 8'd255, 8'd255};
    
    counter8 c1(clk, rst, cnt);
    
    always @(posedge clk or posedge rst) begin
        if (rst) state <= 24'd0;
        else begin
            case (btn)
                8'b00000001: state <= red;
                8'b00000010: state <= orange;
                8'b00000100: state <= yellow;
                8'b00001000: state <= green;
                8'b00010000: state <= blue;
                8'b00100000: state <= indigo;
                8'b01000000: state <= purple;
                8'b10000000: state <= white;
            endcase
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ledR <= 4'b0000;
            ledG <= 4'b0000;
            ledB <= 4'b0000;
        end
        else begin
            if (cnt < state[23:16]) ledR <= 4'b1111;
            else ledR <= 4'b0000;
            
            if (cnt < state[15:8]) ledG <= 4'b1111;
            else ledG <= 4'b0000;
            
            if (cnt < state[7:0]) ledB <= 4'b1111;
            else ledB <= 4'b0000;
        end
    end
endmodule
