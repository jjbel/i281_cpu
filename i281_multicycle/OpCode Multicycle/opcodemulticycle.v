    /*
Multicycle Opcode Creater FSM (Sequential)

Specifications:
input clock, reset
input instruction[7:0] from multicycle decoder
output output_from_multicycle_opcode
*/

/*
Multicycle 8 bit instruction set:
XXXX XXXX
0001 c4c5c6c7 : GCD of (c4,c5 select) and (c6,c7 select)
0010 c4c5c6c7 : Multiply of (c4,c5 select) and (c6,c7 select)
0011 c4c5c6c7 : Divide of (c4,c5 select) and (c6,c7 select)
0100 c4c5c6c7 : Modulus of (c4,c5 select) and (c6,c7 select)
0101 abcd : Random Number generate < abcd 
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

reg [3:0] instruction;
reg [3:0] state;

always@(*)
begin
    instruction = output_to_multicycle_opcode[7:4];
    state = 0;
end


always@(posedge clock or posedge reset)
begin

    opcode_next_instruction_trigger <= 0;

    if(reset)
    begin
        output_from_multicycle_opcode <= 8'b0;
        opcode_next_instruction_trigger <= 0;
    end
    
    else 
    begin
        //add FSM logic here for each input instruction possible
        // output_from_multicycle_opcode <= output_to_multicycle_opcode;
        // opcode_next_instruction_trigger <= 0;
        
        case(instruction)
        4'b0001:
        begin
            //GCD: 
            case(state)
            0: begin
                output_from_multicycle_opcode <= 8'b0;
                opcode_next_instruction_trigger <= 0;
            end
            endcase
        end
        4'b0010:
        begin
            //Multiply: (shift addition multiplier)
            case(state)
            0: begin
                output_from_multicycle_opcode <= 8'b0;
                opcode_next_instruction_trigger <= 0;
            end
            endcase
        end
        4'b0011:
        begin
            //Divider: (shit subtract divider)
            case(state)
            0: begin 
                output_from_multicycle_opcode <= 8'b0;
                opcode_next_instruction_trigger <= 0;
            end
            endcase
        end
        4'b0100:
        begin
            //Modulus: (Divider FSM but record modulus)
            case(state)
            0: begin
                output_from_multicycle_opcode <= 8'b0;
                opcode_next_instruction_trigger <= 0;
            end
            endcase
        end
        4'b0101:
        begin
            //Random Number: (time counter, iterate x_(n+1) = (a*x_n + b)%(abcd))
            case(state)
            0: begin
                output_from_multicycle_opcode <= 8'b0;
                opcode_next_instruction_trigger <= 0;
            end
            endcase
        end
        endcase
    end
end

endmodule