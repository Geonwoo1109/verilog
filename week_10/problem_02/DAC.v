// main module

module DAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out, seg_data, seg_sel, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
    input clk, rst;
    input [5:0] btn;        // all button has oneshot trigger
    input add_sel;          // 0: select A, 1: select B
    
    output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
    output reg [7:0] dac_d;
    output reg [7:0] led_out;
    
    reg [7:0] dac_d_temp;
    reg [7:0] cnt;
    wire [5:0] btn_t;
    
    reg [1:0] state;
    
    parameter   DELAY   = 2'b00,
                SET_WRN = 2'b01,
                UP_DATA = 2'b10;
    
    oneshot_universal #(.WIDTH(6)) os1(clk, rst, {btn[5:0]}, {btn_t[5:0]});
    
    // display 7-segment
    output [7:0] seg_data, seg_sel;
    seg7_controller s1(clk, rst, dac_d_temp, seg_data, seg_sel);
    
    // display text-LCD
    output wire LCD_E;
    assign LCD_E = clk;
    output LCD_RS, LCD_RW;
    output [7:0] LCD_DATA;
    LCD_display LCD1(clk, rst, dac_d_temp, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
    
    // main function (digital I/O)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DELAY;
            cnt <= 8'b0000_0000;
        end
        else begin
            cnt <= cnt + 1;
            case (state)
                DELAY:
                    if (cnt >= 200) begin
                        cnt <= 0;
                        state <= SET_WRN;
                    end
                SET_WRN:
                    if (cnt >= 50) begin
                        cnt <= 0;
                        state <= UP_DATA;
                    end
                UP_DATA:
                    if (cnt >= 30) begin
                        cnt <= 0;
                        state <= DELAY;
                    end
            endcase
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) dac_wrn <= 1;
        else begin
            case (state)
                DELAY:
                    dac_wrn <= 1;
                SET_WRN:
                    dac_wrn <= 0;
                UP_DATA:    
                    dac_d <= dac_d_temp;
            endcase
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dac_d_temp <= 8'b0000_0000;
            led_out <= 8'b0101_0101;
        end
        else begin
                 if (btn_t == 6'b100000) dac_d_temp <= dac_d_temp - 8'b0000_0001;   // btn 1, -1
            else if (btn_t == 6'b010000) dac_d_temp <= dac_d_temp + 8'b0000_0001;   // btn 3, +1
            else if (btn_t == 6'b001000) dac_d_temp <= dac_d_temp - 8'b0000_0010;   // btn 4, -2
            else if (btn_t == 6'b000100) dac_d_temp <= dac_d_temp + 8'b0000_0010;   // btn 6, +2
            else if (btn_t == 6'b000010) dac_d_temp <= dac_d_temp - 8'b0000_1000;   // btn 7, -8
            else if (btn_t == 6'b000001) dac_d_temp <= dac_d_temp + 8'b0000_1000;   // btn 9, +8
            
            led_out <= dac_d_temp;
        end
    end
    
    always @(posedge clk) begin
        dac_csn <= 0;
        dac_ldacn <= 0;
        dac_a_b <= add_sel;     // 0: A(inside, LED), 1: B(outside, oscilloscope)
    end
endmodule
