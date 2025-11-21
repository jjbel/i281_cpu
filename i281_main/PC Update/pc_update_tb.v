/*
Testbench for the PC Update logic.
*/

`timescale 1ns / 1ps

module pc_update_tb ();

  // signal instantiation
  reg [5:0] current_pc, offset;
  reg c2;
  wire [5:0] next_pc;

  // UUT instantiation
  pc_update uut (
      current_pc,
      offset,
      c2,
      next_pc
  );

  // Stimulus
  initial begin
    current_pc = 6'b010000;
    offset = 6'b110100;
    c2 = 0;
    #10;

    current_pc = 6'b010000;
    offset = 6'b110100;
    c2 = 1;
    #10;
    $finish;
  end

  // Variable Dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, pc_update_tb);
  end

endmodule
