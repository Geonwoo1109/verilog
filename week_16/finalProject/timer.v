module timer(clk, rst, state, output_timer, set_btn, timer_start, timer_reset);
    input clk, rst;
    input [1:0] state;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;
                
    input timer_start, timer_reset;
    input [5:0] set_btn;
    
    output reg [31:0] output_timer;
    
    // 1MHz clock: 1,000clock = 1ms
    reg [39:0] timeStamp, remain;
    reg [6:0] h, m, s;
    reg [9:0] ms;
    
    reg [3:0] h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one;
    
    always @(posedge clk or posedge rst) begin
        if (rst) output_timer <= 32'd0;
        else begin
            h_ten = h/10;
            h_one = h%10;
            m_ten = m/10;
            m_one = m%10;
            s_ten = s/10;
            s_one = s%10;
            ms_ten = ms/10;
            ms_one = ms%10;
            
            output_timer <= {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one};
        end
    end
    
    // translate timestamp to hh:mm:ss:ms
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 0;
            m <= 0;
            s <= 0;
            ms <= 0;
            timeStamp <= 0;
            remain <= 0;
        end
        else begin
            // timeStamp: dowmCount 1us
            if (timer_reset) timeStamp <= 0;
            else if (timer_start && timeStamp != 0) timeStamp <= timeStamp - 1;
       
            // default timer
            remain = timeStamp / 1000 / 10;
            
            ms = remain;
            remain = remain / 100;
            
            s = remain % 60;
            remain = remain / 60;
            
            m = remain % 60;
            remain = remain / 60;
            
            h = remain;
            
            // setting time
            if (state == TIMER) begin
                case (set_btn)
                    6'b10_00_00: begin      // -1h
                        if (timeStamp < 1000*1000*60*60) timeStamp <= 0;
                        else timeStamp <= timeStamp - 1000*1000*60*60;
                    end
                    6'b01_00_00: begin      // +1h
                        timeStamp <= timeStamp + 1000*1000*60*60;
                    end
                    
                    6'b00_10_00: begin      // -1min
                        if (timeStamp < 1000*1000*60) timeStamp <= 0;
                        else timeStamp <= timeStamp - 1000*1000*60;
                    end
                    6'b00_01_00: begin      // +1min
                        timeStamp <= timeStamp + 1000*1000*60;
                    end
                    
                    6'b00_00_10: begin      // -1s
                        if (timeStamp < 1000*1000) timeStamp <= 0;
                        else timeStamp <= timeStamp - 1000*1000;
                    end
                    6'b00_00_01: begin      // +1s
                        timeStamp <= timeStamp + 1000*1000;
                    end
                endcase
            end
        end
    end
endmodule
