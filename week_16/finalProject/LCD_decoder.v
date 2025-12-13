// input: bcd data
// output: textLCD display data

module LCD_decoder(bcd, LCD_data);
    input [3:0] bcd;
    output reg [7:0] LCD_data;
    
    always @(bcd) begin
        case (bcd)
            4'd0: LCD_data = {4'b0011, 4'd0};
            4'd1: LCD_data = {4'b0011, 4'd1};
            4'd2: LCD_data = {4'b0011, 4'd2};
            4'd3: LCD_data = {4'b0011, 4'd3};
            4'd4: LCD_data = {4'b0011, 4'd4};
            4'd5: LCD_data = {4'b0011, 4'd5};
            4'd6: LCD_data = {4'b0011, 4'd6};
            4'd7: LCD_data = {4'b0011, 4'd7};
            4'd8: LCD_data = {4'b0011, 4'd8};
            4'd9: LCD_data = {4'b0011, 4'd9};
        endcase
    end
endmodule
