/*
i281 Top Level Entity
*/

//module includes
module i281_toplevel (
    input clock,
    input reset
);
  //internal wiring
  wire [15:0] instruction;

  wire [1:18] ctrl_out;
  wire [26:0] op_in;
  wire [ 3:0] flag_in;

  wire [ 7:0] alu_input_one;
  wire [ 7:0] alu_input_two;
  wire [ 7:0] alu_result;
  wire [ 3:0] alu_flags;

  wire [ 7:0] alu_result_mux_out;
  wire [ 7:0] register_output_two;

  //interconnections

  codemem CODE_MEMORY (
      clock,
      reset,
      ctrl_out[1],
      alu_result_mux_out[5:0],
      switches,
      code_read_select,
      instruction
  );

  opcodedec OPCODE_DECODER (
      instruction[15:8],
      1'b1,
      op_in
  );

  controllogic CONTROL_LOGIC (
      op_in,
      flag_in,
      ctrl_out
  );

  alu ALU (
      ctrl_out[12],
      ctrl_out[13],
      alu_in_one,
      alu_in_two,
      alu_flags,
      alu_result
  );


  flags FLAGS (
      clock,
      reset,
      ctrl_out[14],
      alu_flags,
      flag_in
  );

  register REGISTERS (
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
      alu_input_one,
      register_output_two
  );

  mux #(8) ALU_Source_Mux (
      ctrl_out[11],
      instruction[15:8],
      register_output_two,
      alu_input_two
  );

  mux #(8) ALU_Result_Mux (
      ctrl_out[15],
      alu_result,
      instruction[7:0],
      write_select
  );

  mux #(8) REG_Writeback_Mux (
      ctrl_out[18],
      alu_result_mux_out,
      data_memory_out,
      reg_in
  );
endmodule

module mux (
    input wire s,
    input wire [n-1 : 0] a,
    input wire [n-1 : 0] b,
    output wire [n-1 : 0] out
);
  parameter n = 1;
  assign out = s ? b : a;
endmodule
