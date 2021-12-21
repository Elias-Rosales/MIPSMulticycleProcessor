`timescale 1ns/1ns

`include "Mux4.sv"
`include "Mux2.sv"
`include "Control_Unit.sv"
`include "Register.sv"
`include "Instruction_Memory.sv"
`include "Register_Memory.sv"
`include "Sign_Extend.sv"
`include "ALU.sv"
`include "Data_Memory.sv"

module MIPS_MC_TB();
  reg clk,reset;
  
  MIPS_MC DUT(clk,reset);
  
  always
    begin
      clk <= 1'b0; #2; clk <= 1'b1; #2;
    end
  
  initial begin
    $dumpfile("MIPS_MC.vcd");
    $dumpvars(0,MIPS_MC_TB);
    
    clk = 1'b0; reset=1'b1;#3
    reset=1'b0;//#200
    #2415
    
    
    $finish;
  end
  
endmodule