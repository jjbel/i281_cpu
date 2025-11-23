/*
Testbench for the Toplevel
*/

`timescale 1ns / 1ps

module i281_toplevel_tb ();

  //signals
  reg run;
  reg clock;
  reg reset;
  wire [7:0] datamem0;
  wire [7:0] datamem1;
  wire [7:0] datamem2;
  wire [7:0] datamem3;
  wire [7:0] datamem4;
  wire [7:0] datamem5;
  wire [7:0] datamem6;
  wire [7:0] datamem7;
  wire [7:0] datamem8;
  wire [7:0] datamem9;
  wire [7:0] datamem10;
  wire [7:0] datamem11;
  wire [7:0] datamem12;
  wire [7:0] datamem13;
  wire [7:0] datamem14;
  wire [7:0] datamem15;

  i281_toplevel dut (
      run,
      clock,
      reset,
      datamem0,
      datamem1,
      datamem2,
      datamem3,
      datamem4,
      datamem5,
      datamem6,
      datamem7,
      datamem8,
      datamem9,
      datamem10,
      datamem11,
      datamem12,
      datamem13,
      datamem14,
      datamem15
  );

  // clock
  initial begin
    clock = 0;
    forever #10 clock = ~clock;
  end

  //stimulus
  initial begin
    reset = 1;
    run   = 0;
    #40;
    reset = 0;
    #5;
    run = 1;
    #10000;
    $finish;
  end

  //variable dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, i281_toplevel_tb);
  end

endmodule
