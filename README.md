# Digital Systems Course Project: i281 CPU

Group Members: Shridhar Patil, Jai Bellare, Visharad Srivastava

An 8-bit CPU based on the course project of [CprE 2810](https://www.ece.iastate.edu/~alexs/classes/2024_Fall_2810/), taught by Prof. Alexander Stoytchev at Iowa State University.

References: 
1. [i281 CPU Architecture Slides](https://www.ece.iastate.edu/~alexs/classes/2024_Fall_2810/slides_PDF/41_i281_CPU_Architecture.pdf)
2. [i281 Hardware Desciption Video](https://www.youtube.com/watch?v=WbbeK8TZ0AM)
3. [i281 Simulator](https://www.ece.iastate.edu/~alexs/classes/i281_simulator/index.html)

## Overview:

<img width="1000" height="700" alt="image" src="https://github.com/user-attachments/assets/dbc8d160-78f1-4d66-be11-330c1e32d582" />

The outputs of the CPU are entirely determined by the current state and the inputs, which makes this approach fundamental to general-purpose computing.

Diagram Conventions: Lines entering from the left of a module represent inputs, lines exiting from the right are outputs, and lines coming from the top indicate control bits.

The CPU is composed of several key components. Data memory stores the current state and any intermediate data. In this implementation, it is organized as 16 bytes (16x8 bits). Code memory stores the CPU instructions in the form [8-bit OpCode | 8-bit operands]. The OpCode specifies the operation to perform, and the operands define the data or registers involved. Code memory in this design is 64x16 bits (128 bytes). Together, the CPU uses a total of 144 bytes of memory.

The OpCode decoder reads instructions from code memory and generates the control signals needed to operate the CPU. OpCode aliasing can be used here to reduce complexity: different OpCode patterns can map to the same control signals if they are distinguishable through outputs, flags, or context. These control signals are sent to the Control Box, which manages the flow of operations across all computational components.

User input is provided through 16 switches, which can modify both code and data memory. These switches can be mapped to actual FPGA switches to interactively control the CPU. The operands involved in computations are loaded into four registers (A, B, C, D), which store temporary values required for dynamic calculations. Computation itself is performed by the ALU (Arithmetic Logic Unit), a purely combinational circuit capable of executing arithmetic, logic, and comparison operations. By combining these basic operations, larger FSM computations can be achieved.

The Flags register stores important status flags such as Zero, Negative, or Overflow. The Program Counter (PC) update logic determines the next instruction to execute based on the current instruction and the flags. It can move sequentially, jump, or loop instructions in the Code Memory to implement different FSM behaviors.

Finally, combinational logic is used to determine the next state of the FSM, with ALU computations and register values. By building larger structures from these basic units, complex FSM state computations can be implemented.

Memory Summary: Data memory uses 16 bytes, code memory uses 128 bytes, total 144 bytes.

OpCode Aliasing: When multiple OpCodes produce identical control signals, this is known as OpCode aliasing. It is a useful technique to reduce decoder complexity. Aliased instructions can still be distinguished using output behavior, flags, or operand context.
