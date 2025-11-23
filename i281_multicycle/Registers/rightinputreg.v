/*
Right Input Register

Specifications:
sequential input controls (clock,reset,run)
Takes 8 bit select right operand from Registers, stores it. Updates on c15 readselect.
*/

module rightinputreg (
    input clock,
    input reset,
    input run,
    input c15,
    input [7:0] reginputright,
    output reg [7:0] rightinputreg_register
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      rightinputreg_register <= 8'b0;
    end else if (c15 && run) begin
      rightinputreg_register <= reginputright;
    end
  end

endmodule
