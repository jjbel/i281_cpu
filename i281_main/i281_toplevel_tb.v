/*
Testbench for the Toplevel
*/

`timescale 1ns / 1ps

module i281_toplevel_tb ();

  //signals
  reg run;
  reg clock;
  reg reset;
  wire [15:0] switches;

  i281_toplevel dut (
      run,
      clock,
      reset,
      switches
  );

  // clock
  initial begin
    clock = 0;
    forever #10 clock = ~clock;
  end

  //stimulus
  assign switches = 0;
  initial begin
    reset = 1;
    run   = 0;
    #40;
    reset = 0;
    #5;
    run = 1;
    #1000;
    $finish;
  end

  //variable dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(4, i281_toplevel_tb);
  end

endmodule
