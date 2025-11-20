/*
PC register

Specifications:
6 bit register that updates every clock cycle where c14 is on, asynch reset
*/

module pc (
    input clock,
    input reset,
    input c3,
    input [5:0] pc_input,
    output reg [5:0] pc_reg
);

always@(posedge clock or posedge reset)
begin
    if(reset)
    begin
        pc_reg <= 6'b0;
    end
    else
    begin
        if(c3)
        begin
            pc_reg <= pc_input;
        end
    end
end

endmodule