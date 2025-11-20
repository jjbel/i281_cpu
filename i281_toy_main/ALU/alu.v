/*
ALU: purely combinational, no clock, reset

Specifications:
c12,c13: c12 is alu select 1, c13 is alu select 0
alu_in_one, alu_in_two: input values to ALU for computation
alu_flags: flags register input 
alu_result: output result of ALU
*/

module alu (
    input c12,c13,
    input [7:0] alu_in_one,
    input [7:0] alu_in_two,
    output reg [3:0] alu_flags,
    output reg [7:0] alu_result
);

reg [8:0] catch_flags;

always@(*)
begin

    // default value
    alu_result = 8'b0;
    alu_flags  = 4'b0;
    catch_flags = 9'b0;
    
    case({c13,c12})
        2'b00: 
        begin
            alu_result = alu_in_one << 1; 
            alu_flags[3] = alu_in_one[7]; //carry is shift out
            alu_flags[2] = (alu_result == 0); //zero flag
            alu_flags[1] = alu_result[7]; //negative flag
            alu_flags[0] = 1'b0; //overflow flag 0
        end
        2'b01: 
        begin
            catch_flags = {1'b0, alu_in_one} + {1'b0, alu_in_two}; //9 bit padded addition
            alu_result = catch_flags[7:0];
            alu_flags[3] = catch_flags[8]; //carry flag
            alu_flags[2] = (alu_result == 0); //zero flag
            alu_flags[1] = alu_result[7]; //negative flag
            alu_flags[0] = (~(alu_in_one[7] ^ alu_in_two[7]) & (alu_result[7] ^ alu_in_one[7])); 
            //overflow flag (operand same sign, result diff sign)
        end
        2'b10: 
        begin
            alu_result = alu_in_one >> 1;
            alu_flags[3] = alu_in_one[0]; //carry is shift out
            alu_flags[2] = (alu_result == 0); //zero flag
            alu_flags[1] = alu_result[7]; //negative flag
            alu_flags[0] = 1'b0; //overflow flag 0
        end
        2'b11: 
        begin
            catch_flags = {1'b0, alu_in_one} - {1'b0, alu_in_two}; //9 bit padded subtraction
            alu_result =  catch_flags[7:0]; 
            alu_flags[3] = catch_flags[8]; //carry flag
            alu_flags[2] = (alu_result == 0); //zero flag
            alu_flags[1] = alu_result[7]; //negative flag
            alu_flags[0] = ((alu_in_one[7] ^ alu_in_two[7]) & (alu_result[7] ^ alu_in_one[7]));
            //overflow flag (operand different sign, result sign differs from alu_in_one)
        end
    endcase
end

endmodule