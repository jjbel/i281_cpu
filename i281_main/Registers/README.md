## Registers

There are 4 registers **A,B,C,D** used for storing current operands for computation. They feed into the ALU and other computational units. The register unit has the following capabilities:

1. 4 registers of 8 bit length
2. 2 output ports of 8 bits each
3. 4 control select lines to select one of the registers for each output
4. Write enable port, when on it allows new values to be written onto the registers
5. Two write select lines which choose one of the registers to write into
6. Input stream of 8 bits, which is the data to write when write enable is high

All the selection conditions have been handled with case statements. 

