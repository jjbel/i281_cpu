/*
Data memory (16 registers, 8 bits each)

Specifications: 
c17: write enable bit
write_select: 4 bit register to select which address to write into
inp: input data for said address
read_select: 4 bit register to read from
data_memory_output: output 8 bit 
clock and reset: clock input and reset

data_memory_reg: internal 16 registers of 8 bits 
*/

module datamem (
    input run,
    input clock,
    input reset,
    input c17,
    input [3:0] write_select,
    input [7:0] inp,
    input [3:0] read_select,
    output wire [7:0] data_memory_output,
    output wire [7:0] datamem0,
    output wire [7:0] datamem1,
    output wire [7:0] datamem2,
    output wire [7:0] datamem3,
    output wire [7:0] datamem4,
    output wire [7:0] datamem5,
    output wire [7:0] datamem6,
    output wire [7:0] datamem7,
    output wire [7:0] datamem8,
    output wire [7:0] datamem9,
    output wire [7:0] datamem10,
    output wire [7:0] datamem11,
    output wire [7:0] datamem12,
    output wire [7:0] datamem13,
    output wire [7:0] datamem14,
    output wire [7:0] datamem15
);

  wire [7:0] d[15:0];
  // Module Instantiation
  User_Data addr (
      d[0],
      d[1],
      d[2],
      d[3],
      d[4],
      d[5],
      d[6],
      d[7],
      d[8],
      d[9],
      d[10],
      d[11],
      d[12],
      d[13],
      d[14],
      d[15]
  );

  integer i;  //for loops

  reg [7:0] data_memory_reg[15:0];

  always @(posedge clock or posedge reset) begin

    i = 0;  // else infers latch
    if (reset) begin
      for (i = 0; i < 16; i = i + 1) data_memory_reg[i] <= d[i];  //reset all to 0
    end else if (run & c17) begin
      data_memory_reg[write_select] <= inp;
    end

  end

  assign data_memory_output = data_memory_reg[read_select];

  assign datamem0 = data_memory_reg[0];
  assign datamem1 = data_memory_reg[1];
  assign datamem2 = data_memory_reg[2];
  assign datamem3 = data_memory_reg[3];
  assign datamem4 = data_memory_reg[4];
  assign datamem5 = data_memory_reg[5];
  assign datamem6 = data_memory_reg[6];
  assign datamem7 = data_memory_reg[7];
  assign datamem8 = data_memory_reg[8];
  assign datamem9 = data_memory_reg[9];
  assign datamem10 = data_memory_reg[10];
  assign datamem11 = data_memory_reg[11];
  assign datamem12 = data_memory_reg[12];
  assign datamem13 = data_memory_reg[13];
  assign datamem14 = data_memory_reg[14];
  assign datamem15 = data_memory_reg[15];


endmodule
