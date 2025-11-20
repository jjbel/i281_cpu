/*
Data memory (16 registers, 8 bits each)

Specifications: 
c17: write enable bit
write_select: 4 bit register to select which address to write into
inp: input data for said address
read_select: 4 bit register to read from
data_memory_output: output 8 bit 
clock and reset: clock input and reset

data_memory_reg: internal 16 registers of 8 bits 
*/

module datamem (
    input clock,
    input reset,
    input c17,
    input [3:0] write_select,
    input [7:0] inp,
    input [3:0] read_select,
    output reg [7:0] data_memory_output
);

integer i; //for loops

reg [7:0] data_memory_reg[15:0];

always@(posedge clock or posedge reset)
begin
    if(reset)
    begin
        for(i = 0; i < 16; i = i+1)
            data_memory_reg[i] <= 8'b0; //reset all to 0
    end
    else 
    begin
        data_memory_output <= data_memory_reg[read_select];
        if(c17)
        begin
            data_memory_reg[write_select] <= inp;
        end
    end
end

endmodule