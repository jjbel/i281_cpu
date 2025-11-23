/*
i281 Top Level Entity
*/


//module includes
module i281_toplevel (
    input run,
    input clock,
    input reset,
    output [7:0] datamem0,
    output [7:0] datamem1,
    output [7:0] datamem2,
    output [7:0] datamem3,
    output [7:0] datamem4,
    output [7:0] datamem5,
    output [7:0] datamem6,
    output [7:0] datamem7,
    output [7:0] datamem8,
    output [7:0] datamem9,
    output [7:0] datamem10,
    output [7:0] datamem11,
    output [7:0] datamem12,
    output [7:0] datamem13,
    output [7:0] datamem14,
    output [7:0] datamem15
);
  //internal wiring
  wire [15:0] instruction;
  wire [15:0] imem_register;

  wire [24:1] ctrl_out;
  wire [26:0] op_in;
  wire [ 3:0] flag_in;

  wire [ 7:0] alu_in_one;
  wire [ 7:0] alu_in_two;
  wire [ 7:0] alu_result;
  wire [ 3:0] alu_flags;

  wire [ 7:0] alu_out_register;
  wire [ 7:0] leftinputreg;
  wire [ 7:0] rightinputreg;

  wire [ 7:0] leftinputreg_register;
  wire [ 7:0] rightinputreg_register;

  wire [ 7:0] reg_in;

  wire [5:0] pc, pc_new;

  wire [7:0] data_memory_out, dmem_register;

  //interconnections

  codemem CODE_MEMORY (
      run,
      clock,
      reset,
      ctrl_out[1],
      pc,
      instruction
  );

  imemregister IMEM_REG (
      clock,
      reset,
      run,
      ctrl_out[16],
      instruction,
      imem_register
  );

  opcodedec OPCODE_DECODER (
      imem_register[15:8],
      1'b1,
      op_in
  );

  controlfsm CONTROL_LOGIC (
      clock,
      reset,
      run,
      op_in,
      flag_in,
      ctrl_out
  );

  mux_n_4 #(8) PC_REG_TO_ALU_MUX (
      ctrl_out[19],
      ctrl_out[24],
      {2'b00, pc},
      leftinputreg_register,
      8'b00000001,
      8'b00000000,
      alu_in_one
  );

  mux_n_4 #(8) IMEM_REG_TO_ALU_MUX (
      ctrl_out[20],  //MSB in select line
      ctrl_out[21],
      imem_register[7:0],
      rightinputreg_register,
      8'b00000001,
      8'b00000000,
      alu_in_two
  );

  alu ALU (
      ctrl_out[12],
      ctrl_out[13],
      alu_in_one,
      alu_in_two,
      alu_flags,
      alu_result
  );

  aluoutreg ALU_OUT_REG (
      clock,
      reset,
      run,
      ctrl_out[22],
      alu_result,
      alu_out_register
  );

  flags FLAGS (
      run,
      clock,
      reset,
      ctrl_out[14],
      alu_flags,
      flag_in
  );

  register REGISTERS (
      run,
      clock,
      reset,
      ctrl_out[8],
      ctrl_out[9],
      ctrl_out[10],
      ctrl_out[4],
      ctrl_out[5],
      ctrl_out[6],
      ctrl_out[7],
      reg_in,
      leftinputreg,
      rightinputreg
  );

  leftinputreg LEFT_REG (
      clock,
      reset,
      run,
      ctrl_out[11],
      leftinputreg,
      leftinputreg_register
  );

  rightinputreg RIGHT_REG (
      clock,
      reset,
      run,
      ctrl_out[15],
      rightinputreg,
      rightinputreg_register
  );

  mux_n #(8) DMEM_MUX_TO_REG (
      ctrl_out[18],
      alu_out_register,
      data_memory_out,
      reg_in
  );

  dmemregister DMEM_REGISTER (
      clock,
      reset,
      run,
      ctrl_out[23],
      data_memory_out,
      dmem_register
  );

  datamem DATA_MEMORY (
      run,
      clock,
      reset,
      ctrl_out[17],
      alu_out_register[3:0],
      rightinputreg_register,
      alu_out_register[3:0],
      data_memory_out,
      datamem0,
      datamem1,
      datamem2,
      datamem3,
      datamem4,
      datamem5,
      datamem6,
      datamem7,
      datamem8,
      datamem9,
      datamem10,
      datamem11,
      datamem12,
      datamem13,
      datamem14,
      datamem15
  );

  mux_n #(6) PC_IN_MUX (
      ctrl_out[2],
      alu_out_register[5:0],
      imem_register[5:0],
      pc_new
  );

  pc PROGRAM_COUNTER (
      .clock(clock),
      .reset(reset),
      .run(run),
      .c3(ctrl_out[3]),
      .pc_new(pc_new),
      .pc(pc)
  );
endmodule

module mux_n (
    s,
    a,
    b,
    out
);
  parameter n = 1;
  input wire s;
  input wire [n-1 : 0] a;
  input wire [n-1 : 0] b;
  output wire [n-1 : 0] out;

  assign out = s ? b : a;

endmodule

module mux_n_4 (
    s1,
    s2,
    a,
    b,
    c,
    d,
    out
);
  parameter n = 1;
  input wire s1, s2;
  input wire [n-1:0] a;
  input wire [n-1:0] b;
  input wire [n-1:0] c;
  input wire [n-1:0] d;
  output reg [n-1:0] out;

  always @(*) begin
    case ({
      s1, s2
    })
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      2'b11: out = d;
    endcase
  end
endmodule
