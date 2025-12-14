/*
ALU out register

Specifications:
sequential input controls (clock,reset,run)
Stores ALU output value when read enable c22 is high.
*/

module aluoutreg (
    input clock,
    input reset,
    input run,
    input c22,
    input [7:0] alu_output,
    output reg [7:0] alu_out_register
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      alu_out_register <= 8'b0;
    end else if (c22 && run) begin
      alu_out_register <= alu_output;
    end
  end

endmodule
