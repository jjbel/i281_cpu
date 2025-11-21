/*
Control Logic: Uses the input opcodes and generates control signals.

op_in[26:25] = RX
op_in[24:23] = RY

Specifications:
Inputs: op_in (27-wide), flag_in (4-wide)
Outputs: ctrl_out (18-wide)
*/

module controllogic (
    input  wire [26:0] op_in,
    input  wire [3:0] flag_in,
    output reg  [1:18] ctrl_out
);

  always @(op_in, flag_in) begin
    ctrl_out = 18'b0;

    //c1
    if (|op_in[2:1]) ctrl_out[1] = 1;

    //c2
    if (op_in[22]) ctrl_out[2] = flag_in[0] ~^ flag_in[1];
    else if (op_in[21]) ctrl_out[2] = (~flag_in[2]) & (flag_in[0] ~^ flag_in[1]);
    else if (op_in[20]) ctrl_out[2] = ~flag_in[2];
    else if (op_in[19]) ctrl_out[2] = flag_in[2];
    else if (op_in[18]) ctrl_out[2] = 1;

    //c3
    ctrl_out[3] = 1;

    //c4,c5
    if (|{op_in[17:15], op_in[10:7], op_in[4], op_in[2]}) ctrl_out[4:5] = op_in[26:25];
    else if (op_in[12] | op_in[5]) ctrl_out[4:5] = op_in[24:23];

    //c6,c7
    if (|op_in[14:13]) ctrl_out[6:7] = op_in[26:25];
    else if (|{op_in[17], op_in[9], op_in[7]}) ctrl_out[6:7] = op_in[24:23];

    //c8,c9
    if (|{op_in[16:15], op_in[12:5]}) ctrl_out[8:9] = op_in[26:25];

    //c10
    if (|{op_in[16:15], op_in[12:5]}) ctrl_out[10] = 1;

    //c11
    if (|{op_in[14], op_in[12], op_in[10], op_in[8], op_in[5:4], op_in[2]}) ctrl_out[11] = 1;

    //c12
    if (|{op_in[17], op_in[14], op_in[12], op_in[10:7], op_in[5:4], op_in[2]}) ctrl_out[12] = 1;

    //c13
    if (|{op_in[17:16], op_in[10:9]}) ctrl_out[13] = 1;

    //c14
    if (|{op_in[17:15], op_in[10:7]}) ctrl_out[14] = 1;

    //c15
    if (|{op_in[13], op_in[11], op_in[6], op_in[3], op_in[1]}) ctrl_out[15] = 1;

    //c16
    if (|op_in[4:3]) ctrl_out[16] = 1;

    //c17
    if (|{op_in[14:13], op_in[4:3]}) ctrl_out[17] = 1;

    //c18
    if (|op_in[12:11]) ctrl_out[18] = 1;
  end

endmodule
