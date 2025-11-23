/*
Computational Registers ABCD, 8 bits each

Specifications:
inp: 8 bit input
c8,c9: write select for regiters ABCD
c10: write enable for each register
c4,c5,c6,c7: Read select for mux

output_one: first mux output port
output_two: second mux output port
*/

module register (
    input run,
    input clock,
    input reset,
    input c8,
    c9,
    c10,
    c4,
    c5,
    c6,
    c7,
    input [7:0] inp,
    output reg [7:0] output_one,
    output reg [7:0] output_two
);

  reg [7:0] A;
  reg [7:0] B;
  reg [7:0] C;
  reg [7:0] D;


  always @(posedge clock or posedge reset) begin

    if (reset) begin
      A <= 8'b0;
      B <= 8'b0;
      C <= 8'b0;
      D <= 8'b0;

    end else if (run & c10)
      case ({
        c8, c9
      })
        2'b00: A <= inp;
        2'b01: B <= inp;
        2'b10: C <= inp;
        2'b11: D <= inp;
      endcase

  end

  always @(c4, c5, c6, c7) begin

    case ({
      c4, c5
    })
      2'b00: output_one = A;
      2'b01: output_one = B;
      2'b10: output_one = C;
      2'b11: output_one = D;
    endcase

    case ({
      c6, c7
    })
      2'b00: output_two = A;
      2'b01: output_two = B;
      2'b10: output_two = C;
      2'b11: output_two = D;
    endcase

  end

endmodule
