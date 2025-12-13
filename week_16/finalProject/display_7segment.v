module display_7segment(
    clk, rst, state,
    output_watch, output_watch_world, output_timer, output_stopwatch,
    seg_data, seg_com,
    world_dip);
    
    input clk, rst;
    input world_dip;
    input [31:0] output_watch, output_watch_world, output_timer, output_stopwatch;

    output reg [7:0] seg_data, seg_com;
    reg [3:0] h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one;
    wire [7:0] seg_h_ten, seg_h_one, seg_m_ten, seg_m_one, seg_s_ten, seg_s_one, seg_ms_ten, seg_ms_one;
    
    input [1:0] state;
    parameter   WATCH     = 2'b00,
                TIMER     = 2'b01,
                STOPWATCH = 2'b10;
                
    seg_decoder_ten a2(h_ten, seg_h_ten);
    seg_decoder_one a3(h_one, seg_h_one);
    seg_decoder_ten a4(m_ten, seg_m_ten);
    seg_decoder_one a5(m_one, seg_m_one);
    seg_decoder_ten a6(s_ten, seg_s_ten);
    seg_decoder_one a7(s_one, seg_s_one);
    seg_decoder_ten a8(ms_ten, seg_ms_ten);
    seg_decoder_one a9(ms_one, seg_ms_one);
                
    reg [2:0] s_cnt;
    
    // go to next segment
    always @(posedge clk or posedge rst) begin
        if (rst) s_cnt <= 0;
        else s_cnt <= s_cnt + 1;        // overflow
    end
    
    // which data?
    always @(posedge clk or posedge rst) begin
        if (rst) {h_ten, h_one, m_ten, m_one, s_ten, s_one, ms_ten, ms_one} <= 32'd0;
        else begin
            case (state)
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
    
    // seg_com -> control which segment?
    always @(posedge clk or posedge rst) begin
        if (rst) seg_com = 8'b1111_1111;
        else begin
            case (s_cnt)
                2'd0: seg_com <= 8'b0111_1111;   // 0_______
                2'd1: seg_com <= 8'b1011_1111;   // _0______
                2'd2: seg_com <= 8'b1101_1111;   // __0_____
                2'd3: seg_com <= 8'b1110_1111;   // ___0____
                3'd4: seg_com <= 8'b1111_0111;   // ____0___
                3'd5: seg_com <= 8'b1111_1011;   // _____0__
                3'd6: seg_com <= 8'b1111_1101;   // ______0_
                3'd7: seg_com <= 8'b1111_1110;   // _______0
            endcase
        end
    end
    
    // display segment
    always @(posedge clk or posedge rst) begin
        if (rst) seg_data = 8'b0000_0000;
        else begin
            case (s_cnt)
                3'd0: seg_data = seg_h_ten;     // 0_.__.__.__. > hour at ten
                3'd1: seg_data = seg_h_one;     // _0.__.__.__. > hour at one
                3'd2: seg_data = seg_m_ten;     // __.0_.__.__. > minute at ten
                3'd3: seg_data = seg_m_one;     // __._0.__.__. > minute at one
                3'd4: seg_data = seg_s_ten;     // __.__.0_.__. > second at ten
                3'd5: seg_data = seg_s_one;     // __.__._0.__. > second at one
                3'd6: seg_data = seg_ms_ten;    // __.__.__.0_. > millisecond at ten
                3'd7: seg_data = seg_ms_one;    // __.__.__._0. > millisecond at one
            endcase
        end
    end
endmodule
