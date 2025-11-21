## ALU 

The ALU consists of the following specifications:
1. Input of two 8 bit strings
2. 2 control bits to choose operation 
3. Ability to do right shift, left shift of first input string
4. Ability to add/subtract the input strings
5. Generate overflow, negative, zero and carry flags 

The ALU circuit is:

![ALU Diagram](alu_circuit_diagram.png)

Since there are 2 input select lines there are 4 total selection cases. We implement this through a case statement. At each case we have a different operation implemented and the carry, overflow, zero and negative flag values are calculated accordingly. 

We write a testbench for the ALU with the following simple testcases:
1. Left shift 0x5A
2. Add 120 + 10
3. Right shift 0x81
4. Subtract 20 - 50

![ALU Testbench](testbench_waveform.png)
