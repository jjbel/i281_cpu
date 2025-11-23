/*
Multicycle Decoder

Specification:
Takes in the multicycle flag, if off then forwards instruction[7:0] to opcode decoder, else to multicycle FSM
multicycle_flag: input flag
curr_instruction: input current instruction set
output_opcode: relay output to opcode decoder if flag zero
output_multicycle_opcode: relay output to multicycle opcode decoder if flag one
*/

module multicycledecoder (
    input multicycle_flag,
    input [8:0] curr_instruction,
    output reg[7:0] output_to_opcode,
    output reg[7:0] output_to_multicycle_opcode
);

always@(*)
begin
    //default value
    output_to_opcode = 8'b0;
    output_to_multicycle_opcode = 8'b0;

    case(multicycle_flag)
        0: output_to_opcode = curr_instruction[7:0];
        1: output_to_multicycle_opcode = curr_instruction[7:0];
    endcase
end
endmodule