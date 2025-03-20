`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : SJGrad
File   : debouncer.sv
Create : 03/12/2025
Revise : 03/12/2025
Function:
To take in your operating frequency and estimated max_bounce time for your button
to create a debouncing module
-----------------------------------------------------------------------------*/


module debouncer#(parameter frequency, max_bounce_time)(
    input CLK,
    input RESET,
    input BUTTON_PRESS,
    output SP
    );

    parameter cycles = frequency*max_bounce_time;
    parameter WIDTH = $clog2(cycles);

    reg [WIDTH + 1:0] bounce_counter; //

    reg sync_ff0, sync_ff1, pulse_ff, temp_ff;

    wire detected_edge;
    assign detected_edge = sync_ff0 ^ sync_ff1;

    always@(posedge CLK)begin
        if(RESET) begin
            sync_ff0 <= 0;
            sync_ff1 <= 0;
        end
        else begin
            sync_ff0 <= BUTTON_PRESS;
            sync_ff1 <= sync_ff0;
        end
    end

    always @(posedge CLK) begin

        if(RESET) begin
            bounce_counter <= 0;
        end
        else begin
            if(detected_edge)
                bounce_counter <= 0;
            else if(bounce_counter < cycles)
                bounce_counter <= bounce_counter + 1;
        end
    end

    always @(posedge CLK) begin
        if(RESET) begin
            pulse_ff <= 0;
            temp_ff <= temp_ff;
        end
        else if(bounce_counter == cycles) begin
            pulse_ff <= sync_ff1;
            temp_ff <= pulse_ff;
        end
    end

    assign SP = !temp_ff && pulse_ff;
endmodule
