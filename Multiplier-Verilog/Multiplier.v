/* 
 * Joseph Krambeer
 * ENGR 330 
 * Verilog implementation of Homework 1
 */
 
`timescale 1ns/1ps

////////////////////////////
//2 bit up counter module
////////////////////////////

module upCounter(
input clk,
input reset,
output reg [1:0] count
);

always @(posedge clk) begin
    if(reset) begin
        count <= 1'b0;
    end else begin
        count <= count + 1;
    end
end

endmodule//upCounter

//////////////////////////////////////////////////////////////////////////////////
//8 bit parallel load, 8 bit parallel out, 1 bit serial out shift register module
//////////////////////////////////////////////////////////////////////////////////

//Defines for different shift directions of shift registers
`define RIGHT 0
`define LEFT 1

module shiftReg(
input [7:0] dataIn,
input clk,
input reset,
input load,
input shiftEn,
output [7:0] dataOut,
output shiftOut
);

//Parameter used to decide which direction the data is shifted
parameter shiftDir = `LEFT;

//Registers
reg [7:0] data;

assign shiftOut = data[0];
assign dataOut = data;

always @(posedge clk) begin 
    if(reset) begin
        data <= 0;
    end else if(load) begin
        data <= dataIn;
    end else if(shiftEn) begin
        if(shiftDir == 1) begin
            data <= (data << 1);
        end else begin
            data <= (data >> 1);
        end
    end
end

endmodule//8 bit shifter

///////////////////////////////////////
//4 bit unsigned multiplier module
///////////////////////////////////////

//Defines for different states of the multiplier
`define DONE_STATE 0
`define LOAD_STATE 1
`define MULT_STATE 2

module FourBitMult(
output [7:0] PRODUCT,
output DONE,
input [3:0] A,
input [3:0] B,
input C,
input GO
);

//State for State Machine
reg [1:0] State = `DONE_STATE;//initially set to be done

//Wires
wire [7:0] adderInput;
wire [7:0] adder;

//Counter logic declaration
reg clear;
wire [1:0] count;
upCounter Counter(.clk(C), .reset(clear), .count(count) );//2 bit up counter

//Shift Register logic
reg reset, shiftEn, ABload, SumLoad=1;//control signals for reset, shifting, and loading
wire BShiftOut;//Shift out bit for B's shift register
wire [7:0] AIn;//Input to A's shift register
wire [7:0] BIn;//Input to B's shift register
wire [7:0] AOut;//Parallel output of A's shift register
wire [7:0] SumOut;//Parallel output of Sum's shift register

//Shift Registers
shiftReg #(`LEFT)  AShiftReg(.dataIn(AIn), .clk(C), .reset(reset), .load(ABload), .shiftEn(shiftEn), .dataOut(AOut), .shiftOut( ) );
shiftReg #(`RIGHT) BShiftReg(.dataIn(BIn), .clk(C), .reset(reset), .load(ABload), .shiftEn(shiftEn), .dataOut( ), .shiftOut(BShiftOut) );
shiftReg #(`LEFT)  SumShiftReg(.dataIn(adder), .clk(C), .reset(reset), .load(SumLoad), .shiftEn( ), .dataOut(SumOut), .shiftOut( ) );

//Wire Assignments
assign AIn = {4'b0,A};//Make A into 8 bits by concatenating four 0's onto it's most significant bits
assign BIn = {4'b0,B};//Make B into 8 bits by concatenating four 0's onto it's most significant bits
assign adderInput = {8{BShiftOut}} & AOut;//Logical AND the output of A shift reg with BShiftOut replicated 8x
assign adder = adderInput + SumOut;//8 bit adder of the previous sum of the multiplier and the next input to the adder
assign DONE = !(State ^ `DONE_STATE);//XOR and NOT the current state and the done state to output done=1 only when in done state
assign PRODUCT = SumOut;//assign PRODUCT the value that is stored in the SumShiftReg

always @(posedge C) begin
 // $display("State: %d, Count: %d, Bout: %b, Aout: %b, Adder: %b, Adder input: %d, SumOut: %d",State,count,BShiftOut,AOut,adder,adderInput,SumOut);
  if(State == `DONE_STATE) begin  
        clear <= 1;
        reset <= 1;
        ABload <= 0;
        shiftEn <= 0;
        if(GO) begin
            State <= `LOAD_STATE;
        end 
  end else if(State == `LOAD_STATE) begin
        clear <= 1;
        reset <= 0;
        ABload <= 1;
        shiftEn <= 0;
        State <= `MULT_STATE;
  end else if(State == `MULT_STATE) begin
        clear <= 0;
        reset <= 0;
        ABload <= 0;
        shiftEn <= 1;
        if(count == 3) begin 
            State <= `DONE_STATE;
        end
    end
end

endmodule// 4 bit multiplier