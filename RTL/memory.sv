`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : UT Austin
File   : memory.sv
Create : 03/15/2025
Revise : 03/15/2025
Function:
Serves as the block memory for the stack calculator. It takes 1 cycle to
read/write data. There should be zero changes to the module.
-----------------------------------------------------------------------------*/
module memory(clock, cs, we, address, data_in, data_out);
    input clock;
    input cs;
    input we;
    input[6:0] address;
    input[7:0] data_in;
    output[7:0] data_out;
    
    reg[7:0] data_out;
    reg[7:0] RAM[0:127];

    always @ (negedge clock)
    begin
        if((we == 1) && (cs == 1))
            RAM[address] <= data_in[7:0];

        data_out <= RAM[address];
    end
endmodule
