`timescale 1ns / 1ps

module main_tb();
    reg clk, rst;
    reg [2:0] mode_btn, fn_btn;
    reg [5:0] set_btn;
    
    // watch
    reg ampm_dip, world_dip;
    
    // main m1(clk, rst, mode_btn);
    // main m1(clk, rst, mode_btn, set_btn, fn_btn, ampm24_dip, world_dip, LED_ampm24, LED_world);
    // main m1(clk, rst, seg_data, seg_com, mode_btn, set_btn, fn_btn, ampm24_dip, world_dip, LED_ampm24, LED_world);
    // main m1(clk, rst, seg_data, seg_com, mode_btn, set_btn, fn_btn, ampm_dip, world_dip, LED_ampm24, LED_world);
    // main m1(clk, rst, seg_data, seg_com, mode_btn, set_btn, fn_btn, ampm_dip, world_dip, LED_mode, LED_ampm24, LED_world);
    // main m1(clk, rst, led, seg_data, seg_com, mode_btn, set_btn, fn_btn, ampm_dip, world_dip, LED_mode, LED_ampm24, LED_world);
    /*main m1(clk, rst,
            seg_data, seg_com,
            mode_btn, set_btn, fn_btn,
            ampm_dip, world_dip,
            LED_mode, LED_ampm24, LED_world);*/
    main m1(clk, rst,
            seg_data, seg_com,
            LCD_E, LCD_RS, LCD_RW, LCD_DATA,
            mode_btn, set_btn, fn_btn,
            ampm_dip, world_dip,
            LED_mode, LED_ampm24, LED_world);
    
    initial begin
        clk <= 0;
        rst <= 1;
        mode_btn <= 3'b000;
        set_btn <= 6'b000_000;
        fn_btn <= 3'b000;
        
        ampm_dip <= 0;      // time: 24h from
        world_dip <= 0;     // world: Korea
        
        #1 rst <= 0;
        
        #15 mode_btn <= 3'b100; #5 mode_btn <= 3'b000;  // mode: watch
            #15 set_btn <= 6'b100_000;   #5 set_btn <= 6'b000_000;    // num1, -1 hour  (00:00:00 -> 23:00:00)
                #15 ampm_dip <= 1;      // time: 12h form
            #15 set_btn <= 6'b100_000;   #5 set_btn <= 6'b000_000;    // num1, -1 hour  (23:00:00 -> 22:00:00)
            #15 set_btn <= 6'b000_001;   #5 set_btn <= 6'b000_000;    // num8, +1 sec   (23:01:01)
                #15 ampm_dip <= 0;      // time: 24h form
            #15 set_btn <= 6'b100_000;   #5 set_btn <= 6'b000_000;    // num1, -1 hour  (00:00:00 -> 23:00:00)
                
            #15 world_dip <= 1;     // world: Another contry
            #15 set_btn <= 6'b000_001;   #5 set_btn <= 6'b000_000;    // num8, +1 sec   (23:01:01)
        
        #15 mode_btn <= 3'b010; #5 mode_btn <= 3'b000;  // mode: timer
            #15 set_btn <= 6'b100_000;   #5 set_btn <= 6'b000_000;    // num1, -1 hour (nothing happend)
            #15 set_btn <= 6'b000_100;   #5 set_btn <= 6'b000_000;    // num5, +1 min
            #15 set_btn <= 6'b000_001;   #5 set_btn <= 6'b000_000;    // num8, +1 sec
            
                #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> start
                                                                // check timer work start
                #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> stop
                                                                // check timer stop
                #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> start
            
            #15 set_btn <= 6'b001_000;   #5 set_btn <= 6'b000_000;    // num6, -1 min
                #15 fn_btn <= 3'b010;   #5 fn_btn <= 3'b000;    // mode: reset
            #100;      // wait timer end
        
        #15 mode_btn <= 3'b001; #5 mode_btn <= 3'b000;  // mode: stopwatch
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> start
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> stop
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> start
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> stop
            
            #15 fn_btn <= 3'b010;   #5 fn_btn <= 3'b000;    // mode: reset
            
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> start
            #15 fn_btn <= 3'b100;   #5 fn_btn <= 3'b000;    // mode: start & stop -> stop
            
            #15 fn_btn <= 3'b001;   #5 fn_btn <= 3'b000;    // mode: record
            
            

        
        #150;
        
        $stop;
        
    end
    
    always begin
        #0.5 clk <= ~clk;
    end
endmodule
