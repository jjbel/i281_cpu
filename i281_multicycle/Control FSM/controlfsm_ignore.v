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
    output reg [23:1] c
);
  // LSB 23 of opcode_in are 1 hot encoded opcode_in[22:0]
  // opcode_in[26:25] are RX
  // opcode_in[24:23] are RY


  reg [4:0] instruction;

  reg [5:0] state;

  always @(opcode_in) begin
    encoder23to5 ENC (
        opcode_in[22:0],
        instruction
    );
    state = 0;  // Instruction fetch state
    c = 23'b0;
  end

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      state <= 0;
      instruction <= 5'd0;
    end else begin
      case (instruction)
        c <= 23'b0;
        5'd0: begin  //NOOP
          case (state)
            5'b0: begin
              c[16] <= 1'b1;
              c[19] <= 1'b0;
              c[20] <= 1'b1;
              c[21] <= 1'b0;
              c[12] <= 1'b1;
              c[13] <= 1'b0;
              c[22] <= 1'b1;
              state <= 5'b1
            end
            5'b1: begin
                            c[16] <= 1'b1;
              c[19] <= 1'b0;
              c[20] <= 1'b1;
              c[21] <= 1'b0;
              c[12] <= 1'b1;
              c[13] <= 1'b0;
              c[22] <= 1'b1;
              c[2] <= 1'b0;
              c[3] <= 1'b1;
            end
          endcase
        end
      endcase
    end
  end

endmodule

module encoder23to5 (
    input  wire [22:0] in,  // 23 one-hot inputs
    output reg  [ 4:0] out
);

  always @(*) begin
    casez (in)
      23'b00000000000000000000001: out = 5'd0;
      23'b00000000000000000000010: out = 5'd1;
      23'b00000000000000000000100: out = 5'd2;
      23'b00000000000000000001000: out = 5'd3;
      23'b00000000000000000010000: out = 5'd4;
      23'b00000000000000000100000: out = 5'd5;
      23'b00000000000000001000000: out = 5'd6;
      23'b00000000000000010000000: out = 5'd7;
      23'b00000000000000100000000: out = 5'd8;
      23'b00000000000001000000000: out = 5'd9;
      23'b00000000000010000000000: out = 5'd10;
      23'b00000000000100000000000: out = 5'd11;
      23'b00000000001000000000000: out = 5'd12;
      23'b00000000010000000000000: out = 5'd13;
      23'b00000000100000000000000: out = 5'd14;
      23'b00000001000000000000000: out = 5'd15;
      23'b00000010000000000000000: out = 5'd16;
      23'b00000100000000000000000: out = 5'd17;
      23'b00001000000000000000000: out = 5'd18;
      23'b00010000000000000000000: out = 5'd19;
      23'b00100000000000000000000: out = 5'd20;
      23'b01000000000000000000000: out = 5'd21;
      23'b10000000000000000000000: out = 5'd22;
      default: out = 5'd0;
    endcase
  end

endmodule
