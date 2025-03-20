`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : SJGrad
File   : clock_divider.sv
Create : 03/15/2025
Revise : 03/15/2025
Function:
To take in an operating frequency and output frequency to create a 
corresponding clock divider
-----------------------------------------------------------------------------*/


module clock_divider#(parameter in_frequency, parameter out_frequency)(
    input CLK,
    input RESET,
    output reg SLOWER_CLK
    );
    
    parameter count = in_frequency/out_frequency;
    parameter WIDTH = $clog2(count);
    
    reg [WIDTH-1:0] counter;
    
    always @(posedge CLK) begin
       
        if(RESET) begin
            counter <= 0;
            SLOWER_CLK <= 0;
        end
        else begin
            
            if(counter == count) begin
                counter <= 0;
                SLOWER_CLK <= ~SLOWER_CLK;
            end
            else
                counter <= counter + 1;
        end      
    end
endmodule
