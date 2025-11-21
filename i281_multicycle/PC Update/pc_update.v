/*
PC Update lo
OpCode Decoder. Same OpCodes have been followed as the original i281.
Consists of one 4-16 decoder, two 2-4 decoders and one 1-2 decoder.

opcode_in [7:4] = decoder input
opcode_in [3:2] = RX
opcode_in [1:0] = RY
opcode_out [26:25] = RX
opcode_out [24:23] = RY
opcode_out [22:0] = one-hot encoded opcode

Specifications --
Inputs: opcode_in (8-bit), dec_en (1-bit)
Outputs: opcode_out (27-bit)
*/

module pc_update (
    input [5:0] current_pc,
    input [5:0] offset,  // lower 6 bits of instruction
    input c2,
    output [5:0] next_pc
);
  wire [5:0] current_pc_plus_1;
  assign current_pc_plus_1 = current_pc + 1'b1;
  assign next_pc = c2 ? (current_pc_plus_1 + offset) : current_pc_plus_1;
endmodule
