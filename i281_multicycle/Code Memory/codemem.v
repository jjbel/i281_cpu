/*
Code memory (64 instuctions, 16 bits each)

Specifications: 
c1: write enable bit
write_select: 6 bit register to select which address to write into
inp: input instruction for said address
read_select: 6 bit register to read from
curr_instruction: output 16 bit instruction 
clock and reset: clock input and reset

code_memory_reg: internal 64 registers of 16 bits 
*/

module codemem (
    input run,
    input clock,
    input reset,
    input c1,
    input [5:0] write_select,
    input [15:0] inp,
    input [5:0] read_select,
    output reg [16:0] curr_instruction,
    output reg multicycle_flag
);

  wire [16:0] c[63:0];

  //Module instantation

  User_Code_High add49to64 (
      c[48],
      c[49],
      c[50],
      c[51],
      c[52],
      c[53],
      c[54],
      c[55],
      c[56],
      c[57],
      c[58],
      c[59],
      c[60],
      c[61],
      c[62],
      c[63]
  );
  User_Code_Low add33to48 (
      c[32],
      c[33],
      c[34],
      c[35],
      c[36],
      c[37],
      c[38],
      c[39],
      c[40],
      c[41],
      c[42],
      c[43],
      c[44],
      c[45],
      c[46],
      c[47]
  );
  BIOS_Hardcoded_High add17to32 (
      c[16],
      c[17],
      c[18],
      c[19],
      c[20],
      c[21],
      c[22],
      c[23],
      c[24],
      c[25],
      c[26],
      c[27],
      c[28],
      c[29],
      c[30],
      c[31]
  );
  BIOS_Hardcoded_Low add1to16 (
      c[0],
      c[1],
      c[2],
      c[3],
      c[4],
      c[5],
      c[6],
      c[7],
      c[8],
      c[9],
      c[10],
      c[11],
      c[12],
      c[13],
      c[14],
      c[15]
  );


  integer i;  //for loops 

  reg [16:0] code_memory_reg[63:0]; //MSB is multicycle flag

  always @(posedge clock or posedge reset) begin

      i = 0;  // infers latch
      if (reset) begin
        for (i = 0; i < 64; i = i + 1) code_memory_reg[i] <= c[i];  //reset all to default code
      end else begin
        if(run) begin
        curr_instruction <= code_memory_reg[read_select];
        multicycle_flag <= code_memory_reg[read_select][16];
        if (c1) begin
          code_memory_reg[write_select] <= inp;
        end
        end
    end

  end

endmodule
