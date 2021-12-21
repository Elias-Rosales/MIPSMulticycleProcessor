module Data_Memory(
  input clk,reset,
  input wire MemWrite,
  input wire [31:0] addr, WD,
  output reg [31:0] RD );
  
  reg [31:0] ram[99:0];
  
  initial begin
    $readmemh("data_memory.list",ram);
  end
  
  always @(*)
    begin
      if(reset)
        RD = 32'b0;
      else if((addr==WD) && MemWrite)
        RD = WD;
      else
        RD = ram[addr];
    end
  
  always @(posedge clk)
    begin
      if(MemWrite)
        ram[addr][31:0] <= WD;
    end
  
  always @(*)
    begin
      $writememh("data_memory.list",ram);
    end
  
endmodule