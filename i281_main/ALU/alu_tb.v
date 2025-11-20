/*
Testbench for the ALU
*/

`timescale 1ns/1ps

module alu_tb();

//signals
reg[7:0] alu_in_one, alu_in_two;
reg c12,c13;
wire [7:0] alu_result;
wire [3:0] alu_flags;

alu dut (
    .alu_in_one (alu_in_one),
    .alu_in_two (alu_in_two),
    .c12 (c12),
    .c13 (c13),
    .alu_result (alu_result),
    .alu_flags (alu_flags)
);

//stimulus

initial begin
    // Test 1: SHIFT LEFT (opcode 00)
    c13 = 0; c12 = 0;
    alu_in_one = 8'b0101_1010; // 0x5A
    alu_in_two = 8'b0000_0000;
    #10;

    // Test 2: ADD (opcode 01)
    c13 = 0; c12 = 1;
    alu_in_one = 8'd120;
    alu_in_two = 8'd10;
    #10;

    // Test 3: SHIFT RIGHT (opcode 10)
    c13 = 1; c12 = 0;
    alu_in_one = 8'b1000_0001;
    alu_in_two = 8'b0000_0000;
    #10;

    // Test 4: SUB (opcode 11)
    c13 = 1; c12 = 1;
    alu_in_one = 8'd20;
    alu_in_two = 8'd50;
    #10;

    // End simulation
    #20;
    $finish;
end


//variable dump
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, alu_tb);
end

endmodule