/*
IMEM  Register

Specification:
sequential input controls (clock,reset,run)
Takes read select control bit c16, stores instruction memory element.
*/

module imemregister (
    input clock,
    input reset,
    input run,
    input c16,
    input [15:0] instruction,
    output reg [15:0] imem_register
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      imem_register <= 8'b0;
    end else if (c16 && run) begin
      imem_register <= instruction;
    end
  end

endmodule
