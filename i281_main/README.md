# i281: Baseline CPU

## Structural Modelling: Diagram

<img width="800" height="560" alt="image" src="https://github.com/user-attachments/assets/dbc8d160-78f1-4d66-be11-330c1e32d582" />

Not mentioned in the diagram are the assumed `clock` (positive edge-triggered) and `reset` (asynchronous and active high) nets.

## Folder Structure

There are subfolders for each of the following modules: 
- Combinational: ALU, PC Update Logic, Control Logic, OpCode Decoder
- Registers: Code Memory, Data Memory, Flags, PC, ALU Registers (named "Registers")
- Toplevel: Named i281 Toplevel

Each combinational module folder has a README file, the Verilog file, the Verilog testbench file and a dump file included.
Each register folder only has the Verilog file.

## Testbench Structure

- `timescale 1ns/1ps`: 1 unit = 1 nanosecond, waveform will be generated with 1 picosecond precision.
- It has a signal instantiation block, a UUT (unit-under-test) instantiation block, a stimulus block and a block for dumping variables.

# CPU-Based Finite State Machine Implementation

The outputs of the CPU are entirely determined by the current state and the inputs, which makes this approach fundamental to general-purpose computing.

## Diagram Conventions
- Lines entering from the **left** of a module represent inputs.  
- Lines exiting from the **right** are outputs.  
- Lines coming from the **top** indicate control bits.

## CPU Components

The CPU is composed of several key components. **Data memory** stores the current state and any intermediate data. In this implementation, it is organized as 16 bytes (16x8 bits). **Code memory** stores the CPU instructions in the form `(8-bit OpCode | 8-bit operands)`. The OpCode specifies the operation to perform, and the operands define the data or registers involved. Code memory in this design is 64x16 bits (128 bytes). Together, the CPU uses a total of 144 bytes of memory.

The **OpCode decoder** reads instructions from code memory and generates the control signals needed to operate the CPU. OpCode aliasing can be used here to reduce complexity: different OpCode patterns can map to the same control signals if they are distinguishable through outputs, flags, or context. These control signals are sent to the **Control Box**, which manages the flow of operations across all computational components.

User input is provided through 16 switches, which can modify both code and data memory. These switches can be mapped to actual FPGA switches to interactively control the CPU. The operands involved in computations are loaded into four **registers (A, B, C, D)**, which store temporary values required for dynamic calculations. Computation itself is performed by the **ALU (Arithmetic Logic Unit)**, a purely combinational circuit capable of executing arithmetic, logic, and comparison operations. By combining these basic operations, larger FSM computations can be achieved.

The **Flags register** stores important status flags such as Zero, Negative, or Overflow. The **Program Counter (PC) update logic** determines the next instruction to execute based on the current instruction and the flags. It can move sequentially, jump, or loop instructions in the Code Memory to implement different FSM behaviors.

Finally, **combinational logic** is used to determine the next state of the FSM, with ALU computations and register values. By building larger structures from these basic units, complex FSM state computations can be implemented.

## Memory Summary
- Data memory: 16 bytes  
- Code memory: 128 bytes  
- Total: 144 bytes  

## OpCode Aliasing
When multiple OpCodes produce identical control signals, this is known as OpCode aliasing. It is a useful technique to reduce decoder complexity. Aliased instructions can still be distinguished using output behavior, flags, or operand context.

From the 16 bits supplied to the OpCode decoder, it requires only the first 8 MSB to decide the control bit commands.

## 8 Segment Display
Data memory has 16 registers of 8 bits each = 16 bytes of data. The first 8 bytes (out of 16) of the data memory act as a video card, as they command the 8-7 segment displays what to output. When game mode is off, then only the last 4 bits of the $i^{th}$ register/byte will affect the 0–9 outputs of the $i^{th}$ display. Changing the first 4 bits while keeping the last 4 constant will not affect the displayed digit. (4 bits since least number required to represent digits 0-9). (The remaining 8 bytes act purely as data registers, as they don’t affect the displays).

## Netlist Generated:

<img width="2168" height="458" alt="netlist_i281_main" src="https://github.com/user-attachments/assets/41e4ef61-65c7-4a32-af8c-816ad023ec62" />

