// sub module

module LCD_display(clk, rst, bin, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
    input clk, rst;
    
    input [7:0] bin;    // 8-bit data
    wire [11:0] bcd;    // {0~9}, {0~9}, {0~9}
    bin2bcd b1(clk, rst, bin, bcd);
    
    wire [11:0] bcd_volt;
    bin2bcd b2(clk, rst, bin*500/255, bcd_volt);     // truncate
    
    output wire LCD_E;
    assign LCD_E = clk;
    
    output reg LCD_RS, LCD_RW;
    output reg [7:0] LCD_DATA;
    
    reg [7:0] cnt;
    
    reg [2:0] state;
    parameter   DELAY        = 3'b000,
                FUNCTION_SET = 3'b001,
                DISP_ONOFF   = 3'b010,
                ENTRY_MODE   = 3'b011,
                LINE1        = 3'b100,
                LINE2        = 3'b101,
                DELAY_T      = 3'b110,
                CLEAR_DISP   = 3'b111;
    
    // change state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DELAY;
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
            case(state)
                DELAY:
                    if (cnt >= 70) begin
                        state <= FUNCTION_SET;
                        cnt <= 0;
                    end
                FUNCTION_SET:
                    if (cnt >= 30) begin
                        state <= DISP_ONOFF;
                        cnt <= 0;
                    end
                DISP_ONOFF:
                    if (cnt >= 30) begin
                        state <= ENTRY_MODE;
                        cnt <= 0;
                    end
                ENTRY_MODE:
                    if (cnt >= 30) begin
                        state <= LINE1;
                        cnt <= 0;
                    end
                LINE1:
                    if (cnt >= 50) begin
                        state <= LINE2;
                        cnt <= 0;
                    end
                LINE2:
                    if (cnt >= 50) begin
                        state <= DELAY_T;
                        cnt <= 0;
                    end
                DELAY_T:
                    if (cnt >= 20) begin
                        state <= CLEAR_DISP;
                        cnt <= 0;
                    end
                CLEAR_DISP:
                    if (cnt >= 20) begin
                        state <= LINE1;
                        cnt <= 0;
                    end
                default: state <= DELAY;
            endcase
        end
    end
    
    // print LCD
    always @(posedge clk or posedge rst) begin
        if (rst) {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;
        else begin
            case(state)
                FUNCTION_SET:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
                DISP_ONOFF:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
                ENTRY_MODE:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;
                    
                // LCD line 1 (up, first line)
                LINE1:
                    begin
                        case(cnt)
                            00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; // set address - line 1 (0, 0)
                            01: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; // i
                            02: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1110; // n
                            03: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0000; // p
                            04: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0101; // u
                            05: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t
                            06: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                            07: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            08: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd[11:8]}; // n
                            09: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd[7:4]};  // n
                            10: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd[3:0]};  // n
                            11: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            12: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            13: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            14: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            15: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            16: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            default: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                        endcase
                    end
                
                // LCD line 1 (up, first line)
                LINE2:
                    begin
                        case(cnt)
                            00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000; // set address - line 2 (1, 0)
                            01: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0000; // p
                            02: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0010; // r
                            03: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; // e
                            04: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0100; // d
                            05: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; // i
                            06: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0011; // c
                            07: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t
                            08: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                            09: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            10: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd_volt[11:8]}; // n
                            11: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1110; // .
                            12: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd_volt[7:4]};  // n
                            13: {LCD_RS, LCD_RW, LCD_DATA} = {6'b1_0_0011, bcd_volt[3:0]};  // n
                            14: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0110; // V
                            15: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            16: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // space
                            default: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                        endcase
                    end
                DELAY_T:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
                CLEAR_DISP:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
                default:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
            endcase
        end
    end
endmodule
