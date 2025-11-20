/*
ALU: purely combinational, no clock, reset

Specifications:

*/

module alu (
    input c12,c13,
    input [7:0] alu_in_one,
    input [7:0] alu_in_two,
    output reg [3:0] alu_flags,
    output reg [7:0] alu_result
);



always@(*)
begin
    case(c13)
        0: 
    endcase
end

endmodule