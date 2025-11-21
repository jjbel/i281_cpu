/*
Testbench for the OpCode decoder.
*/

`timescale 1ns / 1ps

module opcodedec_tb ();

  // signal instantiation
  reg [7:0] opcode_in;
  wire dec_en;
  wire [26:0] opcode_out;

  // UUT instantiation
  opcodedec uut (
      .opcode_in(opcode_in),
      .dec_en(dec_en),
      .opcode_out(opcode_out)
  );

  // Stimulus
  integer i;
  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      opcode_in = i;
      #10;
    end
    $finish;
  end
  assign dec_en = 1;

  // Variable Dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, opcodedec_tb);
  end

endmodule
