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
    #100000;
    $finish;
  end

  function [8*8-1:0] instr_name;
    input [4:0] instruction;
    begin
      case (instruction)
        5'd0: instr_name = "NOOP    ";
        5'd1: instr_name = "INPUTC  ";
        5'd2: instr_name = "INPUTCF ";
        5'd3: instr_name = "INPUTD  ";
        5'd4: instr_name = "GCD     ";
        5'd5: instr_name = "MOVE    ";
        5'd6: instr_name = "LOADIP  ";
        5'd7: instr_name = "ADD     ";
        5'd8: instr_name = "ADDI    ";
        5'd9: instr_name = "SUB     ";
        5'd10: instr_name = "SUBI    ";
        5'd11: instr_name = "LOAD    ";
        5'd12: instr_name = "LOADF   ";
        5'd13: instr_name = "STORE   ";
        5'd14: instr_name = "STOREF  ";
        5'd15: instr_name = "SHIFTL  ";
        5'd16: instr_name = "SHIFTR  ";
        5'd17: instr_name = "CMP     ";
        5'd18: instr_name = "JUMP    ";
        5'd19: instr_name = "BRE_BRZ ";
        5'd20: instr_name = "BRNEBRNZ";
        5'd21: instr_name = "BRG     ";
        5'd22: instr_name = "BRGE    ";
        default: instr_name = "UNKNOWN ";
      endcase
    end
  endfunction

  function [8*8-1:0] state_name;
    input [7:0] op;
    begin
      case (op)
        8'd0: state_name = "IF      ";  // pad to 8 chars
        8'd1: state_name = "ID      ";
        8'd10: state_name = "ExLOAD  ";
        8'd6: state_name = "MemREAD ";
        8'd9: state_name = "WbLOAD  ";
        default: state_name = "UNKNOWN ";
      endcase
    end
  endfunction

  integer cycle = 0;
  always @(posedge clock) begin
    cycle = cycle + 1;
    #1;
    $display("%5d: %s %s %1d %1d %1d %1d    %4b", cycle, instr_name(dut.CONTROL_LOGIC.instruction),
             state_name(dut.CONTROL_LOGIC.state), dut.REGISTERS.A, dut.REGISTERS.B,
             dut.REGISTERS.C, dut.REGISTERS.D, dut.FLAGS.flag_reg);
  end

  //variable dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, i281_toplevel_tb);
  end

endmodule
