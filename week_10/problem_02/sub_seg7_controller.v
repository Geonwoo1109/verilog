// sub module

module seg7_controller(clk, rst, bin, seg_data, seg_sel);
    input clk, rst;
    input [7:0] bin;
    
    wire [11:0] bcd;        // {0~9}, {0~9}, {0~9}
    reg [3:0] display_bcd;  // select segment
    
    output reg [7:0] seg_data, seg_sel;
    
    bin2bcd b1(clk, rst, bin, bcd);
    
    always @(posedge clk or posedge rst) begin
        if (rst) seg_sel <= 8'b11111110;        // default: most left segment
        else begin
             seg_sel <= {seg_sel[6:0], seg_sel[7]};
        end
    end
    
    // display digit at each segment
    always @(*) begin
        case (display_bcd[3:0])
                0: seg_data <= 8'b11111100;
                1: seg_data <= 8'b01100000;
                2: seg_data <= 8'b11011010;
                3: seg_data <= 8'b11110010;
                4: seg_data <= 8'b01100110;
                5: seg_data <= 8'b10110110;
                6: seg_data <= 8'b10111110;
                7: seg_data <= 8'b11100000;
                8: seg_data <= 8'b11111110;
                9: seg_data <= 8'b11110110;
                default: seg_data <= 8'b00000000;
        endcase
    end
    
    // select segment
    always @(*) begin
        case (seg_sel)
            8'b11111110: display_bcd = bcd[3:0];
            8'b11111101: display_bcd = bcd[7:4];
            8'b11111011: display_bcd = bcd[11:8];
            8'b11110111: display_bcd = 4'b0000;
            8'b11101111: display_bcd = 4'b0000;
            8'b11011111: display_bcd = 4'b0000;
            8'b10111111: display_bcd = 4'b0000;
            8'b01111111: display_bcd = 4'b0000;
            default: display_bcd  = 4'b0000;
        endcase
    end
endmodule
