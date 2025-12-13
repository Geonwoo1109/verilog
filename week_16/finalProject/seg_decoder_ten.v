// sub module
// input bcd data, output segment display data

module seg_decoder_ten(bcd, seg_data);
    input [3:0] bcd;
    output reg [7:0] seg_data;
    
    always @(bcd) begin
        case (bcd)
            4'h0: seg_data = 8'b1111_1100;
            4'h1: seg_data = 8'b0110_0000;
            4'h2: seg_data = 8'b1101_1010;
            4'h3: seg_data = 8'b1111_0010;
            4'h4: seg_data = 8'b0110_0110;
            4'h5: seg_data = 8'b1011_0110;
            4'h6: seg_data = 8'b1011_1110;
            4'h7: seg_data = 8'b1110_0000;
            4'h8: seg_data = 8'b1111_1110;
            4'h9: seg_data = 8'b1111_0110;
            4'ha: seg_data = 8'b1110_1110;
            4'hb: seg_data = 8'b0011_1110;
            4'hc: seg_data = 8'b1001_1100;
            4'hd: seg_data = 8'b0111_1010;
            4'he: seg_data = 8'b1001_1110;
            4'hf: seg_data = 8'b1000_1110;
        endcase
    end
endmodule
