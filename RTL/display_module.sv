`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : SJGrad
File   : display_module.sv
Create : 03/15/2025
Revise : 03/15/2025
Function:
To display data to the Basys3 7-segment display. Operating frequency must
be stepped down to ~1KHz due to ghosting
-----------------------------------------------------------------------------*/
module display_module#(parameter frequency, parameter display_frequency)(
    input CLK,
    input [7:0] HEX,
    input [6:0] SPR,
    input RESET,
    output reg [6:0] segs,
    output [3:0] an
    );

    reg AN0, AN1, AN2, AN3;

    wire [15:0] bcd_out;
    wire slow_clock;
    reg [1:0] digit_cycle;
    reg [3:0] dd;

    clock_divider #(frequency, display_frequency) clock_1KHz(.CLK(CLK), .RESET(RESET), .SLOWER_CLK(slow_clock));

    always @(posedge slow_clock) begin
        if(RESET)
            digit_cycle <= 0;
        else
            digit_cycle <= digit_cycle + 1;
    end

    always @(*) begin
        case(digit_cycle)
            0: begin AN0 = 0; AN1 = 1; AN2 = 1; AN3 = 1; end
            1: begin AN0 = 1; AN1 = 0; AN2 = 1; AN3 = 1; end
            2: begin AN0 = 1; AN1 = 1; AN2 = 0; AN3 = 1; end
            3: begin AN0 = 1; AN1 = 1; AN2 = 1; AN3 = 0; end
        endcase
    end

    wire [3:0] mux1, mux2;

    assign mux1 = digit_cycle[0] ? HEX[7:4] : HEX[3:0];
    assign mux2 = digit_cycle[0] ? {0, SPR[6:4]} : SPR[3:0];

    assign dd = digit_cycle[1] ? mux2 : mux1;

    always @(*) begin
        case(dd)
            0: segs = 7'b0000001;
            1: segs = 7'b1001111;
            2: segs = 7'b0010010;
            3: segs = 7'b0000110;
            4: segs = 7'b1001100;
            5: segs = 7'b0100100;
            6: segs = 7'b0100000;
            7: segs = 7'b0001111;
            8: segs = 7'b0000000;
            9: segs = 7'b0000100;
            10: segs = 7'b0001000;
            11: segs = 7'b1100000;
            12: segs = 7'b0110001;
            13: segs = 7'b1000010;
            14: segs = 7'b0110000;
            15: segs = 7'b0111000;
        endcase
    end

    assign an = {AN3, AN2, AN1, AN0};
endmodule
