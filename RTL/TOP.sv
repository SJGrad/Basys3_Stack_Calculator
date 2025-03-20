`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : SJGrad
File   : TOP.sv
Create : 03/15/2025
Revise : 03/15/2025
Function:
Serves as the top module for the stack calculator
-----------------------------------------------------------------------------*/
module TOP(
    input clk_in, 
    input[3:0] btns, 
    input[7:0] swtchs, 
    output[7:0] leds, 
    output[6:0] segs, 
    output[3:0] an
);

    // Use onboard PLL for stepping down the frequency to 50MHz //
    clk_wiz_0 clk_divider(.clk_out(clk), .clk(clk_in));
    

    // Debouncer
    parameter num_of_buttons = 4;
    parameter max_bounce_time = 100*(10**(-3)); // Assume 100ms
    parameter input_frequency = 50*(10**6); // 50 MHz

    
    wire cs;
    wire we;
    wire[6:0] addr;
    wire[7:0] data_out_mem;
    wire[7:0] data_out_ctrl;
    

    //CHANGE THESE TWO LINES
    wire[7:0] data_bus;
    assign data_bus = we ? data_out_ctrl : 8'hzz;
    assign data_bus = !cs ? data_out_mem : 8'hzz;
    ///


    // Reset signal //
    wire reset;
    assign reset = &(!(BTN_v ^ 4'b1010));

    // Button Debouncer Signals //
    wire [1:0] btn_v;
    wire [3:0] BTN_v;
    assign BTN_v = {btns[3:2], btn_v};

    // Debounce Button 1 & 2 //
    debouncer #(.frequency(input_frequency), .max_bounce_time(max_bounce_time)) debounce0 (.CLK(clk), .RESET(reset), .BUTTON_PRESS(btns[0]), .SP(btn_v[0]));
    debouncer #(.frequency(input_frequency), .max_bounce_time(max_bounce_time)) debounce1 (.CLK(clk), .RESET(reset), .BUTTON_PRESS(btns[1]), .SP(btn_v[1]));

    /////////////////////////////

    controller ctrl(
        .clk(clk),
        .data_in(data_bus),
        .btns(BTN_v),
        .swtchs(swtchs),
        .cs(cs),
        .we(we),
        .address(addr),
        .data_out(data_out_ctrl),
        .leds(leds),
        .segs(segs),
        .an(an),
        .reset(reset)
    );

    memory mem(
        .clock(clk),
        .cs(cs),
        .we(we),
        .address(addr),
        .data_in(data_bus),
        .data_out(data_out_mem)
    );

endmodule
