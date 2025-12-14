## ALU 

The ALU consists of the following specifications:
1. Input of two 8 bit strings
2. 2 control bits to choose operation 
3. Ability to do right shift, left shift of first input string
4. Ability to add/subtract the input strings
5. Generate overflow, negative, zero and carry flags 

The ALU circuit is:

<img src = "images/alu_circuit_diagram.png" width = "70%">

Since there are 2 input select lines there are 4 total selection cases. We implement this through a case statement. At each case we have a different operation implemented and the carry, overflow, zero and negative flag values are calculated accordingly. 

00: left shift
01: right shift
10: add
11: subtract

The flags register has the following interpretation:
`3`: carry
`2`: overflow
`1`: negative
`0`: zero

We write a testbench for the ALU with the following simple testcases:
1. Left shift 0x5A
2. Add 120 + 10
3. Right shift 0x81
4. Subtract 20 - 50

<img src = "images/testbench_waveform.png" width = "80%">
