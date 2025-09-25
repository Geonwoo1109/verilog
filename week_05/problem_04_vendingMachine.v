module vendingMachine(clk, rst, A, B, C, state, y);
    input wire clk, rst, A, B, C;
    reg A_reg, B_reg, C_reg;
    reg A_trig, B_trig, C_trig;
    output reg [2:0] state;
    output reg y;
    
    parameter s0 = 3'b000;
    parameter s50 = 3'b001;
    parameter s100 = 3'b010;
    parameter s150 = 3'b011;
    parameter s200 = 3'b100;
    
    always @(posedge rst or posedge clk) begin  // button using one-shot trigger
        if (rst) begin
            {A_reg, B_reg, C_reg} <= 3'b000;
            {A_trig, B_trig, C_trig} <= 3'b000;
        end
        else begin
            {A_reg, B_reg, C_reg} <= {A, B, C};
            {A_trig, B_trig, C_trig} <= {A, B, C} & ~{A_reg, B_reg, C_reg};
            
        end
    end
    
    always @(posedge rst or posedge clk) begin  // insert money
        if (rst) state <= 3'b000;
        else begin
            case (state)
                s0: state <= A_trig ? s50 : B_trig ? s100 : s0;
                s50: state <= A_trig ? s100 : B_trig ? s150 : s50;
                s100: state <= A_trig ? s150 : B_trig ? s200 : s100;
                s150: state <= A_trig ? s200 : B_trig ? s200 : s150;
                s200: state <= A_trig ? s200 : B_trig ? s200 : C_trig ? s0 : s200;
            endcase
        end
    end
    
    always @(posedge rst or posedge clk) begin  // buy?
        if (rst) y <= 0;
        else begin
            case (state)
                s200: y <= C_trig ? 1 : 0;
            endcase
        end
    end
endmodule
