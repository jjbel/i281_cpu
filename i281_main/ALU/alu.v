/*
ALU: purely combinational, no clock, reset

Specifications:
c12,c13: c12 is alu select 1, c13 is alu select 0
alu_in_one, alu_in_two: input values to ALU for computation
alu_flags: flags register input 
alu_result: output result of ALU

Flags: 3 = carry, 2 = overflow, 1 = negative, 0 = zero
*/

module alu (
    input c12,
    input c13,
    input [7:0] alu_in_one,
    input [7:0] alu_in_two,
    output reg [3:0] alu_flags,
    output reg [7:0] alu_result
);

  reg [8:0] catch_flags;

  always @(*) begin

    // default value
    alu_result  = 8'b0;
    alu_flags   = 4'b0;
    catch_flags = 9'b0;

    case ({
      c12, c13
    })
      2'b00: begin
        alu_result   = alu_in_one << 1;
        alu_flags[0] = (alu_result == 0);  //zero flag
        alu_flags[1] = alu_result[7];  //negative flag
        alu_flags[2] = 1'b0;  //overflow flag 0
        alu_flags[3] = alu_in_one[7];  //carry is shift out
      end
      2'b01: begin
        alu_result   = alu_in_one >> 1;
        alu_flags[0] = (alu_result == 0);  //zero flag
        alu_flags[1] = alu_result[7];  //negative flag
        alu_flags[2] = 1'b0;  //overflow flag 0
        alu_flags[3] = alu_in_one[0];  //carry is shift out
      end
      2'b10: begin
        catch_flags = {1'b0, alu_in_one} + {1'b0, alu_in_two};  //9 bit padded addition
        alu_result = catch_flags[7:0];
        alu_flags[0] = (alu_result == 0);  //zero flag
        alu_flags[1] = alu_result[7];  //negative flag
        alu_flags[2] = catch_flags[8] ^ (alu_result[7] ^ alu_in_one[7] ^ alu_in_two[7]); //overflow flag
        alu_flags[3] = catch_flags[8];  //carry flag
      end
      2'b11: begin
        catch_flags  = {1'b0, alu_in_one} + {1'b0, ~alu_in_two} + 1;  //9 bit padded subtraction
        alu_result   = catch_flags[7:0];
        alu_flags[0] = (alu_result == 0);  //zero flag
        alu_flags[1] = alu_result[7];  //negative flag
        alu_flags[2] = catch_flags[8] ^ (alu_result[7] ^ alu_in_one[7] ^ ~alu_in_two[7]); //overflow flag
        alu_flags[3] = catch_flags[8];  //carry flag
      end
    endcase
  end

endmodule
