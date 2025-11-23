/*
PC register

Specifications:
6 bit register to store PC address
Has a read select c3
*/

module pc (
    input clock,
    input reset,
    input run,
    input c3,
    input [5:0] pc_new,
    output reg [5:0] pc
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      pc <= 5'b0;
    end else if (c3) begin
      pc <= pc_new;
    end
  end

endmodule
