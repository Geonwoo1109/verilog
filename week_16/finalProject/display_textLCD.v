module display_textLCD(
    clk, rst, update, state_mode,
    output_watch, output_watch_world, output_timer, output_stopwatch,
    LCD_E, LCD_RS, LCD_RW, LCD_DATA,
    world_dip);
    
    input clk, rst;
    input world_dip;    // 0: Korea, 1: Another Country
    input [31:0] output_watch, output_watch_world, output_timer, output_stopwatch;
    
    input update;
    input [1:0] state_mode;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;   
                
    reg [3:0] h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one;
    wire [7:0] LCD_h_ten, LCD_h_one, LCD_m_ten, LCD_m_one, LCD_s_ten, LCD_s_one, LCD_ms_ten, LCD_ms_one;
    
    LCD_decoder d2(h_ten, LCD_h_ten);
    LCD_decoder d3(h_one, LCD_h_one);
    LCD_decoder d4(m_ten, LCD_m_ten);
    LCD_decoder d5(m_one, LCD_m_one);
    LCD_decoder d6(s_ten, LCD_s_ten);
    LCD_decoder d7(s_one, LCD_s_one);
    LCD_decoder d8(ms_ten, LCD_ms_ten);
    LCD_decoder d9(ms_one, LCD_ms_one);
    
    output wire LCD_E;
    output reg LCD_RS, LCD_RW;
    output reg [7:0] LCD_DATA;
    
    assign LCD_E = clk;
    
    
    // which data?
    always @(posedge clk or posedge rst) begin
        if (rst) {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= 32'd0;
        else begin
            case (state_mode)
                WATCH: begin
                    if (!world_dip) begin
                        {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= output_watch;   // Korea
                        // seg_m_one <= 8'b0101_0101;
                    end
                    else {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= output_watch_world;        // Another
                end
                TIMER:      {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= output_timer;
                STOPWATCH:  {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= output_stopwatch;
            endcase
        end
    end
    
    reg [2:0] state;
    parameter   DELAY        = 3'b000,
                FUNCTION_SET = 3'b001,
                DISP_ONOFF   = 3'b010,
                ENTRY_MODE   = 3'b011,
                WRITE        = 3'b100,
                DELAY_T      = 3'b101,
                CURSOR_HOME  = 3'b110,
                CLEAR_DISP   = 3'b111;
    
    reg [7:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DELAY;
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
            case (state)
                DELAY: begin
                    if (cnt == 70) begin
                        cnt <= 0;
                        state <= FUNCTION_SET;
                    end
                end
                FUNCTION_SET: begin
                    if (cnt == 30) begin
                        cnt <= 0;
                        state <= DISP_ONOFF;
                    end
                end
                DISP_ONOFF: begin
                    if (cnt == 30) begin
                        cnt <= 0;
                        state <= ENTRY_MODE;
                    end
                end
                ENTRY_MODE: begin
                    if (cnt == 30) begin
                        cnt <= 0;
                        state <= WRITE;
                    end
                end
                
                // repeat start point
                WRITE: begin
                    if (cnt == 50) begin
                        cnt <= 0;
                        state <= DELAY_T;
                    end
                end
                DELAY_T: begin
                    cnt <= 0;
                    // 다음단계로 넘어가기 전 대기상태
                    if (update) state <= CURSOR_HOME;
                end
                CURSOR_HOME: begin
                    if (cnt == 5) begin
                        cnt <= 0;
                        state <= CLEAR_DISP;
                    end
                end
                CLEAR_DISP: begin
                    if (cnt == 5) begin
                        cnt <= 0;
                        state <= WRITE;
                    end
                end
            endcase
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;
        else begin
            case (state)
                DELAY: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b11_0000_0000;
                FUNCTION_SET: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_0011_1000;
                DISP_ONOFF: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_0000_1100;
                ENTRY_MODE: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_0000_0110;
                WRITE: begin
                    case (state_mode)
                        WATCH: begin
                            case (cnt)
                                // line 1
                                00: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_1000_0000; // addr setting
                                01: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0111; // W
                                02: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0001; // A
                                03: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0100; // T
                                04: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0011; // C
                                05: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1000; // H
                                06: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0010_1101; // -
                            endcase
                            case (world_dip)
                                0: begin
                                    case (cnt)
                                        07: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1011; // K
                                        08: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1111; // O
                                        09: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0010; // R
                                        10: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0101; // E
                                        11: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0001; // A
                                    endcase
                                end
                                1: begin
                                    case (cnt)
                                        07: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0100; // D
                                        08: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1001; // I
                                        09: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0110; // F
                                        10: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0110; // F
                                        11: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0010_1110; // .
                                    endcase
                                end
                            endcase
                        end
                        TIMER: begin
                            case (cnt)
                                // line 1
                                00: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_1000_0000; // addr setting
                                01: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0100; // T
                                02: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1001; // I
                                03: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_1101; // M
                                04: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0101; // E
                                05: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0010; // R
                                06: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0010_0000; // (space)
                            endcase
                        end
                        STOPWATCH: begin
                            case (cnt)
                                // line 1
                                00: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_1000_0000; // addr setting
                                01: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0011; // S
                                02: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0100; // T
                                03: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0010_1110; // .
                                04: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0101_0111; // W
                                05: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0100_0011; // C
                                06: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0010_0000; // (space)
                            endcase
                        end
                    endcase
                    
                    case (cnt)
                        // line 2
                        16: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_1100_0000; // addr setting
                        17: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_h_ten}; // h
                        18: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_h_one}; // h
                        19: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0011_1010;   // :
                        20: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_m_ten}; // m
                        21: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_m_one}; // m
                        22: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b10_0011_1010;   // :
                        23: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_s_ten}; // s
                        24: {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, LCD_s_one}; // s
                    endcase
                end
                DELAY_T: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b11_0000_0000;
                CURSOR_HOME: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_0000_0010;
                CLEAR_DISP: {LCD_RS, LCD_RW, LCD_DATA} <= 10'b00_0000_0001;
            endcase
        end
    end
endmodule
