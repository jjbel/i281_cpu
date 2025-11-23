/*
Control FSM

Specifications:
sequential input controls (clock,reset,run)
input 27 bits from opcode decoder
input flags register
output c[23:1] control bits
*/

module controlfsm (
    input clock,
    input reset,
    input run,
    input [26:0] opcode_in,
    input [3:0] flags_reg,
    output reg [23:1] c
);

  always @(posedge clock or posedge reset) begin

  end

endmodule
