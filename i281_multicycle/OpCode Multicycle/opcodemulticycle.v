/*
Multicycle Opcode Creater FSM (Sequential)

Specifications:
input clock, reset
input instruction[7:0] from multicycle decoder
output output_from_multicycle_opcode
*/

module opcodemulticycle (
    input run,
    input clock,
    input reset,
    input [7:0] output_to_multicycle_opcode,
    input [3:0] flags_reg,
    output reg opcode_next_instruction_trigger,
    output reg [7:0] output_from_multicycle_opcode
);

always@(posedge clock or posedge reset)
begin
    if(reset)
    begin
        output_from_multicycle_opcode <= 8'b0;
        opcode_next_instruction_trigger <= 0;
    end
    
    else 
    begin
        //add FSM logic here for each input instruction possible
        output_from_multicycle_opcode <= output_to_multicycle_opcode;
        opcode_next_instruction_trigger <= 0;
    end
end

endmodule