/* 
 * Joseph Krambeer
 * ENGR 330 
 * Verilog implementation of Homework 1
 * -Ran on edaplayground.com with Icarus Verilog 0.9.7 
 *  simulator and testbench+design as SystemVerilog/Verilog
 */
 
`timescale 1ns/1ps

module test;

    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg GO;
    wire [7:0] PRODUCT;
    wire DONE;
    
    FourBitMult test(PRODUCT,DONE,A,B,clk,GO);
    
    initial begin
        $dumpfile ("dump.vcd"); 
        $dumpvars; 
    end 
    
    always begin
        #5 clk = !clk;
    end
    
    initial begin
        #500 $finish;//stop simulation after 500 ticks
    end 
    
    initial begin
        //initialize variables and wait a bit of time, then set GO to high to start
        clk=0; GO=0; A=8; B=3; #10; //24
        GO = 1; #60;
        
        //Test repeated use of the system
        clk=0; GO=0; A=9; B=4; #10; //36
        GO = 1; #60;
        
        clk=0; GO=0; A=1; B=13; #10; //13
        GO = 1; #60;
        
        clk=0; GO=0; A=15; B=15; #10; //255
        GO = 1; #60;
      
        clk=0; GO=0; A=0; B=7; #10; //0
        GO = 1; #60;
      
        clk=0; GO=0; A=10; B=11; #10; //110
        GO = 1; #60;
      
        clk=0; GO=0; A=4; B=4; #10; //16
        GO = 1; #60;
    end
    
    always @(DONE) begin
      if(DONE==1) begin
        //Because the design initially starts with done==1, the first PRODUCT it will
        //display is the state of PRODUCT before the first multiplication has begun 
        $display("Product is %d",PRODUCT);//display PRODUCT when DONE indicated multiplication was finished
        end
    end
endmodule//end test