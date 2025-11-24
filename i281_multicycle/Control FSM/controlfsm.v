/*
Control FSM

Specifications:
sequential input controls (clock,reset,run)
input 27 bits from opcode decoder
input flags register
output c[23:1] control bits
*/

module controlfsm (
    input clock,
    input reset,
    input run,
    input [26:0] opcode_in,
    input [3:0] flags_reg,
    output reg [24:1] c
);
  // LSB 23 of opcode_in are 1 hot encoded opcode_in[22:0]
  // opcode_in[26:25] are RX
  // opcode_in[24:23] are RY

  localparam IF = 5'd0,
  ID = 5'd1,
  ExALU = 5'd2,
  ExADDR = 5'd3,
  ExBRANCH = 5'd4,
  ExJUMP = 5'd5,
  MemREAD = 5'd6,
  MemWRITE = 5'd7,
  WbALU = 5'd8,
  WbLOAD = 5'd9,
  ExLOAD = 5'd10,
  ExLOADI = 5'd11,
  ExLIR = 5'd12,
  ExMOVE = 5'd13,
  ExSWAPREG = 5'd14;

  reg [4:0] instruction;

  always @(*) begin
    case (opcode_in[22:0])
      23'b00000000000000000000001: instruction = 5'd0;  //NOOP
      23'b00000000000000000000010: instruction = 5'd1;  //INPUTC
      23'b00000000000000000000100: instruction = 5'd2;  //INPUTCF
      23'b00000000000000000001000: instruction = 5'd3;  //INPUTD
      23'b00000000000000000010000: instruction = 5'd4;  //INPUTDF
      23'b00000000000000000100000: instruction = 5'd5;  //MOVE .
      23'b00000000000000001000000: instruction = 5'd6;  //LOADI/LOAP
      23'b00000000000000010000000: instruction = 5'd7;  //ADD
      23'b00000000000000100000000: instruction = 5'd8;  //ADDI
      23'b00000000000001000000000: instruction = 5'd9;  //SUB
      23'b00000000000010000000000: instruction = 5'd10;  //SUBI
      23'b00000000000100000000000: instruction = 5'd11;  //LOAD
      23'b00000000001000000000000: instruction = 5'd12;  //LOADF . 
      23'b00000000010000000000000: instruction = 5'd13;  //STORE .
      23'b00000000100000000000000: instruction = 5'd14;  //STOREF .
      23'b00000001000000000000000: instruction = 5'd15;  //SHIFTL
      23'b00000010000000000000000: instruction = 5'd16;  //SHIFTR
      23'b00000100000000000000000: instruction = 5'd17;  //CMP
      23'b00001000000000000000000: instruction = 5'd18;  //JUMP
      23'b00010000000000000000000: instruction = 5'd19;  //BRE/BRZ
      23'b00100000000000000000000: instruction = 5'd20;  //BRNE/BRNZ
      23'b01000000000000000000000: instruction = 5'd21;  //BRG
      23'b10000000000000000000000: instruction = 5'd22;  //BRGE
      default: instruction = 5'd0;
    endcase
  end

  reg [5:0] state, next_state;

  always @(*) begin
    next_state = state;  //default

    casez ({
      state, instruction
    })
      {
        IF, 5'bzzzzz  //instruction is reg[4:0], any instruction has next ID
      } : begin
        next_state = ID;
      end
      // NOOP OPERATION
      {
        ID, 5'd0
      } : begin
        next_state = IF;
      end
      //MOVE OPERATION
      {
        ID, 5'd5
      } : begin
        next_state = ExMOVE;
      end
      {
        ExALU, 5'd5
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd5
      } : begin
        next_state = IF;
      end
      //LOADI/LOADP 
      {
        ID, 5'd6
      } : begin
        next_state = ExLOADI;
      end
      {
        ExLOADI, 5'd6
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd6
      } : begin
        next_state = IF;
      end
      //ADD
      {
        ID, 5'd7
      } : begin
        next_state = ExALU;
      end
      {
        ExALU, 5'd7
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd7
      } : begin
        next_state = IF;
      end
      //ADDI
      {
        ID, 5'd8
      } : begin
        next_state = ExADDR;
      end
      {
        ExADDR, 5'd8
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd8
      } : begin
        next_state = IF;
      end
      //SUB
      {
        ID, 5'd9
      } : begin
        next_state = ExALU;
      end
      {
        ExALU, 5'd9
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd9
      } : begin
        next_state = IF;
      end
      //SUBI
      {
        ID, 5'd10
      } : begin
        next_state = ExADDR;
      end
      {
        ExADDR, 5'd10
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd10
      } : begin
        next_state = IF;
      end
      //LOAD
      {
        ID, 5'd11
      } : begin
        next_state = ExLOAD;
      end
      {
        ExLOAD, 5'd11
      } : begin
        next_state = MemREAD;
      end
      {
        MemREAD, 5'd11
      } : begin
        next_state = WbLOAD;
      end
      {
        WbLOAD, 5'd11
      } : begin
        next_state = IF;
      end
      //CMP
      {
        ID, 5'd17
      } : begin
        next_state = ExALU;
      end
      {
        ExALU, 5'd17
      } : begin
        next_state = IF;
      end
      //JUMP
      {
        ID, 5'd17
      } : begin
        next_state = ExJUMP;
      end
      {
        ExJUMP, 5'd17
      } : begin
        next_state = IF;
      end
      //BRG
      {
        ID, 5'd21
      } : begin
        if (!flags_reg[0] && !flags_reg[1]) begin
          next_state = ExJUMP;
        end else begin
          next_state = IF;
        end
      end
      {
        ExJUMP, 5'd21
      } : begin
        next_state = IF;
      end
      //BRGE
      {
        ID, 5'd22
      } : begin
        if (!flags_reg[1]) begin
          next_state = ExJUMP;
        end else begin
          next_state = IF;
        end
      end
      {
        ExJUMP, 5'd22
      } : begin
        next_state = IF;
      end
      //LOADF
      {
        ID, 5'd12
      } : begin
        next_state = ExLOAD;
      end
      {
        ExLOAD, 5'd12
      } : begin
        next_state = WbALU;
      end
      {
        WbALU, 5'd12
      } : begin
        next_state = ExLIR;
      end
      {
        ExLIR, 5'd12
      } : begin
        next_state = ExALU;
      end
      {
        ExALU, 5'd12
      } : begin
        next_state = MemREAD;
      end
      {
        MemREAD, 5'd12
      } : begin
        next_state = WbLOAD;
      end
      {
        WbLOAD, 5'd12
      } : begin
        next_state = IF;
      end
      //STORE
      {
        ID, 5'd13
      } : begin
        next_state = ExLOAD;
      end
      {
        ExLOAD, 5'd13
      } : begin
        next_state = MemWRITE;
      end
      {
        MemWRITE, 5'd13
      } : begin
        next_state = IF;
      end
      //STOREF
      {
        ID, 5'd14
      } : begin
        next_state = ExSWAPREG;
      end
      {
        ExSWAPREG, 5'd14
      } : begin
        next_state = ExLOADI;
      end
      {
        ExLOADI, 5'd14
      } : begin
        next_state = MemWRITE;
      end
      {
        MemWRITE, 5'd14
      } : begin
        next_state = IF;
      end
    endcase
  end

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      state <= IF;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    c = 23'b0;
    case (state)
      IF: begin
        c[3]  = 1'b1;
        c[12] = 1'b1;
        c[16] = 1'b1;
        c[20] = 1'b1;
        c[22] = 1'b1;
      end
      ID: begin
        c[3]  = 1'b1;
        c[11] = 1'b1;
        c[12] = 1'b1;
        c[15] = 1'b1;
        c[22] = 1'b1;
        if (instruction == 5'd5 | instruction == 5'd12 | instruction == 5'd13 | instruction == 5'd14) begin
          c[4] = opcode_in[24];
          c[5] = opcode_in[23];
          c[6] = opcode_in[26];
          c[7] = opcode_in[25];
        end else begin
          c[4] = opcode_in[26];
          c[5] = opcode_in[25];
          c[6] = opcode_in[24];
          c[7] = opcode_in[23];
        end
      end
      ExALU: begin
        c[12] = |{opcode_in[17], opcode_in[14], opcode_in[12], opcode_in[10:7], opcode_in[5:4], opcode_in[2]};
        c[13] = |{opcode_in[17:16], opcode_in[10:9]};
        c[14] = 1'b1;
        c[24] = 1'b1;
        c[21] = 1'b1;
        c[22] = 1'b1;
      end
      ExADDR: begin
        c[12] = |{opcode_in[17], opcode_in[14], opcode_in[12], opcode_in[10:7], opcode_in[5:4], opcode_in[2]};
        c[13] = |{opcode_in[17:16], opcode_in[10:9]};
        c[24] = 1'b1;
        c[22] = 1'b1;
        c[14] = 1'b1;
      end
      ExLOAD: begin
        c[12] = 1'b1;
        c[19] = 1'b1;
        c[24] = 1'b1;
        c[22] = 1'b1;
        c[14] = 1'b1;
      end
      ExMOVE: begin
        c[14] = 1'b1;
        c[22] = 1'b1;
        c[20] = 1'b1;
        c[19] = 1'b1;
        c[24] = 1'b1;
        c[12] = 1'b1;
      end
      ExJUMP: begin
        c[2] = 1'b1;
        c[3] = 1'b1;
      end
      ExLIR: begin
        c[4]  = opcode_in[26];
        c[5]  = opcode_in[25];
        c[11] = 1'b1;
      end
      ExSWAPREG: begin
        c[6]  = opcode_in[26];
        c[7]  = opcode_in[25];
        c[4]  = opcode_in[24];
        c[5]  = opcode_in[23];
        c[11] = 1'b1;
        c[15] = 1'b1;
      end
      ExLOADI: begin
        c[19] = 1'b1;
        c[12] = 1'b1;
        c[22] = 1'b1;
        c[24] = 1'b1;
      end
      MemREAD: begin
        c[23] = 1'b1;
      end
      MemWRITE: begin
        c[17] = 1'b1;
      end
      WbALU: begin
        c[10] = 1'b1;
        c[8]  = opcode_in[26];
        c[9]  = opcode_in[25];
      end
      WbLOAD: begin
        c[18] = 1'b1;
        c[10] = 1'b1;
        c[8]  = opcode_in[26];
        c[9]  = opcode_in[25];
      end
    endcase
  end


endmodule
