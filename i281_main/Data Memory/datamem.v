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
    output wire [7:0] data_memory_output
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

endmodule
