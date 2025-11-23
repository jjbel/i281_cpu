/*
Data Memory Register

Specifications:
sequential input controls (clock,reset,run)
When read select c23 is high, Read from data memory and store in register.
*/

module dmemregister (
    input clock,
    input reset,
    input run,
    input c23,
    input [7:0] datamemory,
    output reg [7:0] dmem_register
);

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      dmem_register <= 8'b0;
    end else if (c23 && run) begin
      dmem_register <= datamemory;
    end
  end

endmodule
