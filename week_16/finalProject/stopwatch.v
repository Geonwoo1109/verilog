module stopwatch(clk, rst, state,
                    output_stopwatch,
                    stopwatch_start, stopwatch_reset, stopwatch_record);
    input clk, rst;
    input [1:0] state;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;
                
    input stopwatch_start, stopwatch_reset, stopwatch_record;
    
    output reg [32:0] output_stopwatch;
    
    // 1MHz clock: 1,000clock = 1ms
    reg [39:0] timeStamp, remain;
    reg [6:0] h, m, s;
    reg [9:0] ms;
    
    reg [3:0] h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one;
    
    always @(posedge clk or posedge rst) begin
        if (rst) output_stopwatch <= 32'd0;
        else begin
            h_ten = h/10;
            h_one = h%10;
            m_ten = m/10;
            m_one = m%10;
            s_ten = s/10;
            s_one = s%10;
            ms_ten = ms/10;
            ms_one = ms%10;
            
            output_stopwatch <= {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one};
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst || stopwatch_reset) begin
            timeStamp <= 0;
        end
        else if (stopwatch_start) timeStamp <= timeStamp + 1;
    end
    
    // translate timestamp to hh:mm:ss
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 0;
            m <= 0;
            s <= 0;
            ms <= 0;
            remain <= 0;
        end
        else begin
            // default timer
            remain = timeStamp / 1000 / 10;
            
            ms = remain;
            remain = remain / 100;
            
            s = remain % 60;
            remain = remain / 60;
            
            m = remain % 60;
            remain = remain / 60;
            
            h = remain;
        end
    end
endmodule
