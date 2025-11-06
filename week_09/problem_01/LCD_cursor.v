module LCD_cursor(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);
    input clk, rst;
    input [9:0] number_btn;
    input [1:0] control_btn;
    
    wire [9:0] number_btn_t;
    wire [1:0] control_btn_t;
    
    oneshot_universal #(.WIDTH(12)) o1(clk, rst, {number_btn[9:0], control_btn[1:0]}, {number_btn_t[9:0], control_btn_t[1:0]});
    
    output LCD_E, LCD_RS, LCD_RW;
    output reg [7:0] LCD_DATA, LED_out;
    
    wire LCD_E;
    reg LCD_RS, LCD_RW;

    assign LCD_E = clk;
    
    reg [7:0] cnt;
    
    reg [2:0] state;
    parameter   DELAY        = 3'b000,
                FUNCTION_SET = 3'b001,
                DISP_ONOFF   = 3'b010,
                ENTRY_MODE   = 3'b011,
                SET_ADDRESS  = 3'b100,
                DELAY_T      = 3'b101,
                WRITE        = 3'b110,
                CURSOR       = 3'b111;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DELAY;
            LED_out <= 8'b0000_0000;
            cnt = 0;
        end
        else begin
            case(state)
                DELAY: begin
                    LED_out = 8'b1000_0000;
                    if (cnt >= 70) begin
                        state = FUNCTION_SET;
                        cnt = 0;
                    end else cnt <= cnt + 1;
                end
                FUNCTION_SET: begin
                    LED_out = 8'b0100_0000;
                    if (cnt >= 30) begin
                        state = DISP_ONOFF;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                DISP_ONOFF: begin
                    LED_out = 8'b0010_0000;
                    if (cnt >= 30) begin
                        state = ENTRY_MODE;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                ENTRY_MODE: begin
                    LED_out = 8'b0001_0000;
                    if (cnt >= 30) begin
                        state = SET_ADDRESS;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                SET_ADDRESS: begin
                    LED_out = 8'b0000_1000;
                    if (cnt >= 100) begin
                        state = DELAY_T;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                DELAY_T: begin
                    LED_out = 8'b0000_0100;
                    state <= |number_btn_t ? WRITE : (|control_btn_t ? CURSOR : DELAY_T);
                    cnt = 0;
                end
                WRITE: begin
                    LED_out = 8'b0000_0010;
                    if (cnt >= 30) begin
                        state = DELAY_T;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                CURSOR: begin
                    LED_out = 8'b0000_0001;
                    if (cnt >= 30) begin
                        state = DELAY_T;
                        cnt = 0;
                    end else cnt = cnt + 1;
                end
                default: state = DELAY;
            endcase
        end
    end
    
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
                SET_ADDRESS:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
                DELAY_T:
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
                    
                WRITE:      // LCD line 1 (up, first line)
                    begin
                        if (cnt == 20) begin
                            case(number_btn)
                                10'b1000_0000_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;   // 1
                                10'b0100_0000_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;   // 2
                                10'b0010_0000_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;   // 3
                                10'b0001_0000_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;   // 4
                                10'b0000_1000_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;   // 5
                                10'b0000_0100_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;   // 6
                                10'b0000_0010_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;   // 7
                                10'b0000_0001_00: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;   // 8
                                10'b0000_0000_10: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;   // 9
                                10'b0000_0000_01: {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;   // 0
                            endcase
                        end
                        else {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
                    end
                CURSOR:
                    begin
                        if (cnt == 20) begin
                            case (control_btn)
                                2'b10: {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_0000;  // left
                                2'b01: {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_0100;  // right
                            endcase
                        end
                        else {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
                    end
            endcase
        end
    end
endmodule
