/*
Left Input Register

Specifications:
sequential input controls (clock,reset,run)
Takes 8 bit select left operand from Registers, stores it. Updates on c11 readselect.
*/

module leftinputreg (
    input clock,
    input reset,
    input run,
    input c11,
    input [7:0] reginputleft,
    output reg [7:0] leftinputreg_register
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      leftinputreg_register <= 8'b0;
    end else if (c11 && run) begin
      leftinputreg_register <= reginputleft;
    end
  end

endmodule
