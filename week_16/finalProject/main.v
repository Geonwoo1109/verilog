module main(clk, rst,
            seg_data, seg_com,
            LCD_E, LCD_RS, LCD_RW, LCD_DATA,
            mode_btn, set_btn, fn_btn,
            ampm_dip, world_dip,
            LED_mode, LED_ampm24, LED_world);
    input clk, rst;
    output wire [7:0] seg_data, seg_com;
    output wire LCD_E;
    output wire LCD_RS, LCD_RW;
    output wire [7:0] LCD_DATA;
    
    wire [31:0] output_watch,
                output_watch_world,
                output_timer,
                output_stopwatch;
    
    // button setting
    input [2:0] mode_btn;       // mode change
                                // watch / timer / stopwatch
    input [5:0] set_btn;        // -1, +1
    input [2:0] fn_btn;         // start & stop, reset, record
    
    wire [2:0] mode_btn_t;
    wire [5:0] set_btn_t;       // [5:0]
    wire [2:0] fn_btn_t;
    
    oneshot_universal #(.WIDTH(3)) o1(clk, rst, mode_btn[2:0], mode_btn_t[2:0]);
    oneshot_universal #(.WIDTH(6)) o2(clk, rst, set_btn[5:0], set_btn_t[5:0]);
    oneshot_universal #(.WIDTH(3)) o3(clk, rst, fn_btn[2:0], fn_btn_t[2:0]);
    
    output reg [2:0] LED_mode;  // 100: watch, 010: timer, 001: stopwatch
    
    input ampm_dip;     // 1: 12h, 0: 24h
    output reg LED_ampm24;  // LED8
    
    input world_dip;    // 0: Korea, 1: Another Country
    output reg LED_world;   // LED7
    
    // mode
    reg [1:0] state;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;
    
    reg timer_start, timer_reset;
    reg stopwatch_start, stopwatch_reset, stopwatch_record;
    
    // change state(mode) with mode_btn
    always @(posedge clk or posedge rst) begin
        if (rst) state <= WATCH;
        else begin
            case (mode_btn)
                3'b100: state <= WATCH;
                3'b010: state <= TIMER;
                3'b001: state <= STOPWATCH;
            endcase
        end
    end
    
    // control LED
    always @(posedge clk or posedge rst) begin
        if (rst) LED_mode <= 3'b000;
        else begin
            // Mode
            case (state)
                WATCH: LED_mode <= 3'b100;
                TIMER: LED_mode <= 3'b010;
                STOPWATCH: LED_mode <= 3'b001;
            endcase
            
            // LED_mode <= mode_btn;
            // ampm @ watch
            if (ampm_dip) LED_ampm24 <= 1;
            else LED_ampm24 <= 0;
            // world @ watch
            if (world_dip) LED_world <= 1;
            else LED_world <= 0;
        end
    end
    
    // watch
    watch           wo(clk, rst, state,
                        output_watch, set_btn_t, mode_ampm, world_dip);
    watch_another   w1(clk, rst, state,
                        output_watch_world, set_btn_t, mode_ampm, world_dip);
    
    // timer
    timer           t1(clk, rst, state,
                        output_timer, set_btn_t, timer_start, timer_reset);
    
    // stopwatch
    stopwatch       s1(clk, rst, state,
                        output_stopwatch,
                        stopwatch_start, stopwatch_reset, stopwatch_record);
    
    // 7-segment
    display_7segment seg1(
        clk, rst, state,
        output_watch, output_watch_world, output_timer, output_stopwatch,
        seg_data, seg_com, world_dip);
    
    // text-LCD
    reg [32:0]  prev_output_watch,
                prev_output_watch_world,
                prev_output_timer,
                prev_output_stopwatch;
    wire update =   (output_watch != prev_output_watch) ||
                    (output_watch_world != prev_output_watch_world) ||
                    (output_timer != prev_output_timer) ||
                    (output_stopwatch != prev_output_stopwatch);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_output_watch <= 0;
            prev_output_watch_world <= 0;
            prev_output_timer <= 0;
            prev_output_stopwatch <= 0;
        end
        else begin
            prev_output_watch <= output_watch;
            prev_output_watch_world <= output_watch_world;
            prev_output_timer <= output_timer;
            prev_output_stopwatch <= output_stopwatch;
        end
    end
    display_textLCD LCD1(
        clk, rst, update, state_mode,
        output_watch, output_watch_world, output_timer, output_stopwatch,
        LCD_E, LCD_RS, LCD_RW, LCD_DATA,
        world_dip);
        
    // fn_btn
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // state <= WATCH;
            {stopwatch_start, stopwatch_reset, stopwatch_record} <= 3'b010;
            {timer_start, timer_reset} <= 2'b01;
        end
        else begin
            case (state)
                WATCH: begin
                    
                end
                TIMER: begin
                    case (fn_btn_t)
                        3'b100: timer_start <= ~timer_start;
                        3'b010: begin
                            timer_reset <= 1;
                            timer_start <= 0;
                        end
                        default: timer_reset <= 0;
                    endcase
                end
                STOPWATCH: begin   // num3, start & stop
                                   // num6, reset
                                   // num9, record
                    case (fn_btn_t)
                        3'b100: stopwatch_start <= ~stopwatch_start;
                        3'b010: begin
                            stopwatch_reset <= 1;
                            stopwatch_start <= 0;
                        end
                        default: stopwatch_reset <= 0;
                    endcase
                    
                end
            endcase
        end
    end
endmodule
