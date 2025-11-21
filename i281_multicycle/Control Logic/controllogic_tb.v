/*
Testbench for Control Logic Generator.
*/

`timescale 1ns / 1ps

module controllogic_tb ();

  // signal instantiation
  reg  [26:0] op_in;
  reg  [ 3:0] flag_in;
  wire [1:18] ctrl_out;

  // UUT instantiation
  controllogic uut (
      .op_in(op_in),
      .flag_in(flag_in),
      .ctrl_out(ctrl_out)
  );

  // Stimulus
  integer i, j, k;
  initial begin

    for (i = 0; i < 23; i = i + 1) begin
      op_in[22:0] = 23'b0;
      op_in[i] = 1;
      for (j = 0; j < 16; j = j + 1) begin
        op_in[26:23] = j;
        for (k = 0; k < 16; k = k + 1) begin
          flag_in = k;
          #10;
        end
      end
    end
    $finish;
  end

  // Variable Dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, controllogic_tb);
  end

endmodule
