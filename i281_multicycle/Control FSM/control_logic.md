# Changes single_cycle -> multicycle

5 new registers: IMEM, DMEM, ALU Left Input, ALU Right Input, ALU Out
5 new control signals: one write select for each

## New/renamed control signals

c11: ALU source mux -> left input write sel 
c15: ALU result mux -> right input write sel
c16: DMEM input mux -> IMEM reg write sel

c19: ALU left mux: left_reg | pc
c20, c21: ALU right mux: instr[8:0] | right_reg | 1 | 0
c22: ALU out reg write sel
c23: DMEM reg write sel

# Output Logic

> ctrl sig = g(present_state, X1X0 etc)

## Fetch:
c16=1 IMEM reg write

c12,c13 = 10 (add)
c19=0: select pc
c20,c21 = 10 (1)
c22=1: write ALU out ?confirm

c2=0
c3=1: pc write ?confirm ?or on next cycle since alu reg out has delay
memwrite=1?




### Decode:
c11,c15=1 : load ABCD registers into input regs

c12,c13=10 (add)
c19=0: select pc
c20,c21 = 00 (branch address)
c22=1: write ALU out

c2=0
c3=1 ??????

shdnt we set c4,c5,c6,c7??
also c8,c9,c10?


### Ex-ALU
c12,c13: from opcode
c19=1:choose left input
c20,c21 = 01: choose right input
c22=1: write ALU out
c14=1: write flags


### Ex-ADDR
c12,c13=10 (add)
c19=1 (for A reg) ??but this is left input, not A reg
c20,c21=00 (immediate address)
c22=1: write ALU out
c12,c13=10 (add)


### Ex-BRANCH
???


### Ex-JUMP
c3=1 pc write
c2=0: write to PC from ALU


### MEM-READ
c23=1: write DMEM reg


### MEM-WRITE
c17=1: write DMEM


### WB-ALU
c10=1: reg write en
c8,c9: from opcode
c18=0: writeback from ALU out reg


### WB-LOAD
c18=1: writeback from DMEM reg



### WB-LOADI ???
