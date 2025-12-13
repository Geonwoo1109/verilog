module watch_another(clk, rst, state, output_watch_world, set_btn, mode_ampm, world_dip);
    input clk, rst;
    input [1:0] state;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;
                
    input mode_ampm;        // 1: 12h, 0: 24h
    input world_dip;        // 0: Korea(not this file), 1: Another country(here)
    input [5:0] set_btn;
    
    output reg [31:0] output_watch_world;
    
    reg [9:0] h_cnt;
    reg [5:0] h_ampm, h, m, s;
    reg [9:0] ms;
    
    reg [3:0] h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one;
    
    always @(posedge clk or posedge rst) begin
        if (rst) output_watch_world <= 32'd0;
        else begin
            h_ten = h_ampm/10;
            h_one = h_ampm%10;
            m_ten = m/10;
            m_one = m%10;
            s_ten = s/10;
            s_one = s%10;
            ms_ten = ms/100;
            ms_one = (ms/10)%10;
            
            output_watch_world <= {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one};
        end
    end
    
    // clock: 1MHz, 1,000clock = 1ms
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_ampm <= 0;
            h <= 0;
            m <= 0;
            s <= 0;
            ms <= 0;
        end
        else begin
            // default watch
            if (h_cnt == 999) begin
                h_cnt <= 0;
                if (ms == 999) begin
                    ms <= 0;
                    if (s == 59) begin
                        s <= 0;
                        if (m == 59) begin
                            m <= 0;
                            if (h == 23) begin
                                h <= 0;
                            end else h <= h + 1;
                        end else m <= m + 1;
                    end else s <= s + 1;
                end else ms <= ms + 1;
            end else h_cnt <= h_cnt + 1;
            h_ampm <= mode_ampm ? (h > 12 ? h-12 : h) : h;
        
            // setting time
            if (state == WATCH && world_dip == 1) begin
                case (set_btn)
                    6'b10_00_00: begin      // -1h
                        if (h == 0) h <= 23;
                        else h <= h - 1;
                    end
                    6'b01_00_00: begin      // +1h
                        if (h == 23) h <= 00;
                        else h <= h + 1;
                    end
                    
                    6'b00_10_00: begin      // -1min
                        if (m == 0) m <= 59;
                        else m <= m - 1;
                    end
                    6'b00_01_00: begin      // +1min
                        if (m == 59) m <= 0;
                        else m <= m + 1;
                    end
                    
                    6'b00_00_10: begin      // -1s
                        if (s == 0) s <= 59;
                        else s <= s - 1;
                    end
                    6'b00_00_01: begin      // +1s
                        if (s == 59) s <= 00;
                        else s <= s + 1;
                    end
                endcase
            end
        end
    end
endmodule
