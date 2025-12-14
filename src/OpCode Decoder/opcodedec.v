/*
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

module opcodedec (
    input wire [7:0] opcode_in,
    input wire dec_en,
    output wire [26:0] opcode_out
);

  wire y1, y12, y15;

  assign opcode_out[26:25] = opcode_in[3:2];  // RX
  assign opcode_out[24:23] = opcode_in[1:0];  // RY

  dec_4to16 decoder1 (
      .dec_in (opcode_in[7:4]),
      .dec_en (dec_en),
      .dec_out({y15, opcode_out[18:17], y12, opcode_out[14:5], y1, opcode_out[0]})
  );
  dec_2to4 decoder2 (
      .dec_in (opcode_in[1:0]),
      .dec_en (y1),
      .dec_out(opcode_out[4:1])
  );
  dec_1to2 decoder3 (
      .dec_in (opcode_in[0]),
      .dec_en (y12),
      .dec_out(opcode_out[16:15])
  );
  dec_2to4 decoder4 (
      .dec_in (opcode_in[1:0]),
      .dec_en (y15),
      .dec_out(opcode_out[22:19])
  );

endmodule

/*
4 to 16 decoder. Specifications --
Inputs: dec_in (4-bit), dec_en (1-bit)
Outputs: dec_out (16-bit)
*/
module dec_4to16 (
    input wire [3:0] dec_in,
    input wire dec_en,
    output wire [15:0] dec_out
);
  assign dec_out = dec_en ? (16'b1 << dec_in) : 16'b0;
endmodule

/*
2 to 4 decoder. Specifications --
Inputs: dec_in (2-bit), dec_en (1-bit)
Outputs: dec_out (4-bit)
*/
module dec_2to4 (
    input wire [1:0] dec_in,
    input wire dec_en,
    output wire [3:0] dec_out
);
  assign dec_out = dec_en ? (4'b1 << dec_in) : 4'b0;
endmodule

/*
1 to 2 decoder. Specifications --
Inputs: dec_in (1-bit), dec_en (1-bit)
Outputs: dec_out (2-bit)
*/
module dec_1to2 (
    input wire dec_in,
    input wire dec_en,
    output wire [1:0] dec_out
);
  assign dec_out = dec_en ? (2'b1 << dec_in) : 2'b0;
endmodule
