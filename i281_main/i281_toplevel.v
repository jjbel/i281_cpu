/*
i281 Top Level Entity
*/

//module includes
module i281_toplevel (
    input clock,
    input reset
);

//internal wiring
wire [7:0] alu_input_one;
wire [7:0] alu_input_two;
wire [7:0] alu_result;
wire [3:0] alu_flags;
wire [1:18] ctrl_out;
wire [26:0] op_in;
wire [3:0] flag_in;

//interconnections
alu ALU_instance (
    ctrl_out[12],
    ctrl_out[13],
    alu_in_one, 
    alu_in_two,
    alu_flags,
    alu_result
);

controllogic CONTROL_LOGIC (
    op_in,
    flag_in,
    ctrl_out
);

endmodule