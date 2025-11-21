/*
Code memory (64 instuctions, 16 bits each)

Specifications: 
c1: write enable bit
write_select: 6 bit register to select which address to write into
inp: input instruction for said address
read_select: 6 bit register to read from
curr_instruction: output 16 bit instruction 
clock and reset: clock input and reset

code_memory_reg: internal 64 registers of 16 bits 
*/

module codemem (
    input run,
    input clock,
    input reset,
    input c1,
    input [5:0] write_select,
    input [15:0] inp,
    input [5:0] read_select,
    output reg [16:0] curr_instruction,
    output reg multicycle_flag
);

  integer i;  //for loops 

  reg [16:0] code_memory_reg[63:0]; //MSB is multicycle flag

  always @(posedge clock or posedge reset) begin

      i = 0;  // infers latch
      if (reset) begin
        for (i = 0; i < 64; i = i + 1) code_memory_reg[i] <= 17'b0;  //reset all to 0
      end else begin
        if(run) begin
        curr_instruction <= code_memory_reg[read_select];
        multicycle_flag <= code_memory_reg[read_select][16];
        if (c1) begin
          code_memory_reg[write_select] <= inp;
        end
        end
    end

  end

endmodule
