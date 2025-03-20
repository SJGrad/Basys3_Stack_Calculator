`timescale 1ns / 1ps
/*-----------------------------------------------------------------------------
Author : SJGrad
File   : controller.sv
Create : 03/15/2025
Revise : 03/15/2025
Function:
To serve as the control logic for the stack calculator. Can be optimized
more to save on Basys3 utilization.
-----------------------------------------------------------------------------*/
module controller(
    input clk, 
    input [7:0] data_in,
    input [3:0] btns,
    input [7:0] swtchs,
    input reset,
    output reg cs,
    output reg we,
    output reg [6:0] address,
    output reg [7:0] data_out,
    output [7:0] leds,
    output [6:0] segs,
    output [3:0] an
);
    parameter EMPTY = 8'h7F;
    parameter input_frequency = 50*(10**6); // 50 MHz
    parameter display_frequency = 1*(10**3); // 1KHz

    display_module #(.frequency(input_frequency), .display_frequency(display_frequency)) display(.CLK(clk), .HEX(DVR), .SPR(SPR), .RESET(reset), .segs(segs), .an(an));

    // Instructions / States
    parameter STANDBY = 0;
    parameter LOADDVR = 3;
    parameter PUSH = 1;
    parameter POP = 2;
    parameter ADDTEMP = 7;
    parameter ADD = 5;
    parameter SUB = 6;
    parameter SUBTEMP = 15;
    parameter TOP = 9;
    parameter CLEAR = 10;
    parameter INC = 13;
    parameter DEC = 14;
    //
    wire [4:0] instruction;
    assign instruction = btns;

    reg arith_flag, second_pass_add, second_pass_sub, update_DVR;
    reg [3:0] State;
    reg [6:0] DAR, SPR;
    reg [7:0] DVR;

    reg [7:0] temp;

    always @(posedge clk) begin

        if(reset) begin
            DAR <= 0;
            State <= CLEAR;
            DVR <= 0;
            arith_flag <= 0;
            temp <= 0;
            second_pass_add <= 0;
            second_pass_sub <= 0;
            data_out <= 0;
            SPR <= 0;
        end
        case(State)
            STANDBY:    standby();
            LOADDVR:    load_dvr();
            PUSH:       push();
            POP:        pop();
            ADD:        add();
            ADDTEMP:    add_temp();
            SUB:        sub();
            SUBTEMP:    sub_temp();
            CLEAR:      clear();
            TOP:        top();
            DEC:        dec();
            INC:        inc();
            default:    standby();
        endcase
    end

    assign leds = (SPR == EMPTY) ? 8'b10000000: {0, DAR};

    // Each State's Actions //

    // STANBY //
    task standby();
        we <= 0; cs <= 0;
        if(update_DVR) begin
            address <= DAR;
            State <= LOADDVR;
        end
        else
            State <= instruction;  
    endtask

    // LOAD DVR //
    task load_dvr();
        DVR <= data_in;
        State <= STANDBY;
        update_DVR <= 0;
    endtask

    // PUSH //
    task push();
        we <= 1; cs <= 1;

        if(arith_flag) begin
            data_out <= temp;
            arith_flag <= 0;
        end
        else begin
            data_out <= swtchs;
        end
        DAR <= SPR;
        address <= SPR;
        SPR <= SPR - 1;
        State <= STANDBY;
        update_DVR <= 1;
    endtask

    // POP //
    task pop();
        we <= 1; cs <= 1;
        data_out <= 0;
        address <= SPR + 1;
        SPR <= SPR + 1;
        DAR <= SPR + 2;
        update_DVR <= 1;
        if(arith_flag) begin

            if(second_pass_add)
                State <= ADD;
            else
                State <= SUB;
        end
        else
            State <= STANDBY;
    endtask

    // ADD //
    task add();
        we <= 0; cs <= 0;
        address <= SPR + 1;
        SPR = SPR;
        State <= ADDTEMP;
    endtask

    // ADD TEMP //
    task add_temp();
        if(second_pass_add) begin
            temp <= temp + data_in;
            second_pass_add <= 0;
            SPR <= SPR + 1;
            State <= PUSH;
        end
        else begin
            State <= POP;
            temp <= data_in;
            arith_flag <= 1;
            second_pass_add <= 1;
        end
    endtask

    // SUB //
    task sub();
        we <= 0; cs <= 0;
        address <= SPR + 1;
        SPR = SPR;
        State <= SUBTEMP;
    endtask

    // SUB TEMP //
    task sub_temp();
        if(second_pass_sub) begin
            temp <= data_in - temp;
            second_pass_sub <= 0;
            SPR <= SPR + 1;
            State <= PUSH;
        end
        else begin
            State <= POP;
            temp <= data_in;
            arith_flag <= 1;
            second_pass_sub <= 1;
        end
    endtask

    // CLEAR //
    task clear();
        we <= 1; cs <= 1;
        if(SPR == EMPTY) begin
            State <= STANDBY;
            data_out <= 0;
            address <= SPR;
            SPR <= SPR;
        end
        else begin
            data_out <= 0;
            address <= SPR;
            SPR <= SPR + 1;
            State <= CLEAR;
        end
        update_DVR <= 1;
    endtask

    // TOP //
    task top();
        DAR <= SPR + 1;
        State <= STANDBY;
        update_DVR <= 1;
    endtask

    // DEC //
    task dec();
        DAR <= DAR - 1;
        State <= STANDBY;
        update_DVR <= 1;
    endtask

    // INC //
    task inc();
        DAR <= DAR + 1;
        State <= STANDBY;
        update_DVR <= 1;
    endtask
endmodule

