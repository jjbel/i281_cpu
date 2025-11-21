/*
Flags register

Specifications:
4 bit register that updates every clock cycle where c14 is on, asynch reset
*/

module flags (
    input clock,
    input reset,
    input c14,
    input [3:0] flag_input,
    output reg [3:0] flag_reg
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      flag_reg <= 4'b0;
    end else begin
      if (c14) begin
        flag_reg <= flag_input;
      end
    end
  end

endmodule
