module MIPS_MC(
  input clk, reset);
  
  reg [3:0] p_state;
  //PC Register
  wire PCEn;
  wire [31:0] Next_PC;
  reg  [31:0] PC;
  //Instructor memory
  wire [31:0] Instr,InstrReg;
  wire IRWrite;
  //Register memory, Sign Extend and JTA
  wire [4:0] A1,A2,A3,Mux15_11;
  wire [5:0] Op, Funct;
  wire [15:0] Imm;
  wire [25:0] JTA;
  wire [31:0] RD1,RD2,WD3,SignImm;
  
  //Control Unit
  wire RegDst,MemtoReg,RegWrite,MemWrite,ALUSrcA;
  wire [1:0] ALUSrcB, PCSrc;
  wire [2:0] ALUControl;
  
  //ALU and ALUReg
  wire [31:0] A,B,ALUOut,ReadData,SrcA,SrcB,ALUResult;
  wire zero;
  wire [31:0] PCJump;
  
  //Instruction partition
  assign A1 = InstrReg[25:21];
  assign A2 = InstrReg[20:16];
  assign Mux15_11 = InstrReg[15:11];
  assign Imm = InstrReg[15:0];
  assign JTA = InstrReg[25:0];
  assign Op = InstrReg[31:26];
  assign Funct = InstrReg[5:0];
  assign PCJump = {PC[31:26],JTA};
  
  //Control Unit
  Control_Unit CU(clk,reset,zero,Funct,Op,IRWrite,RegDst,MemtoReg,RegWrite,
                  ALUSrcA,MemWrite,PCEn,ALUSrcB,PCSrc,ALUControl,p_state);
  //PC
  Register R1(clk,reset,PCEn,Next_PC,PC);
  //Instruction Memory
  Instruction_Memory IM(PC,Instr);
  Register R2(clk,reset,IRWrite,Instr,InstrReg);
  //Muxes before RegMem
  mux2 M1(A2,Mux15_11,RegDst,A3);
  mux2 M2(ALUOut,ReadData,MemtoReg,WD3);
  //Register Memory
  Register_Memory RM(clk,RegWrite,reset,A1,A2,A3,WD3,RD1,RD2);
  Register R3(clk,reset,1'b1,RD1,A);
  Register R4(clk,reset,1'b1,RD2,B);
  //Sign Extend
  Sign_Extend SE(Imm,SignImm);
  //Muxes before ALU
  mux2 M3(PC,A,ALUSrcA,SrcA);
  mux4 M4(B,32'b1,SignImm,SignImm,ALUSrcB,SrcB);
  //ALU
  ALU Alu(SrcA,SrcB,ALUControl,zero,ALUResult);
  Register R5(clk,reset,1'b1,ALUResult,ALUOut);
  //Data Mem
  Data_Memory DM(clk,reset,MemWrite,ALUOut,B,ReadData);
  mux4 M5(ALUResult,ALUOut,PCJump,32'bX,PCSrc,Next_PC);
  
endmodule