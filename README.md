# i281 CPU

![Architecture Diagram](docs/Multicycle%20Datapath.png)

A multicycle CPU, with GCD instruction implemented.

### Read the full report here: [report.pdf](report.pdf)

### Read the multicycle control FSM state tables here: [state_tables.xlsx](state_tables.xlsx) and [src/Control FSM/controlfsm.v](src/Control%20FSM/controlfsm.v)

---

Group Members: Shridhar Patil, Jai Bellare, Visharad Srivastava

An 8-bit multicycle CPU, made for the course project of IITB's EE224: Digital Systems, guided by Prof. Sachin Patkar.

Based on the course project of [CprE 2810](https://www.ece.iastate.edu/~alexs/classes/2024_Fall_2810/), taught by Prof. Alexander Stoytchev at Iowa State University:
1. [i281 CPU Architecture Slides](https://www.ece.iastate.edu/~alexs/classes/2024_Fall_2810/slides_PDF/41_i281_CPU_Architecture.pdf)
2. [i281 Hardware Desciption Video](https://www.youtube.com/watch?v=WbbeK8TZ0AM)
3. [i281 Simulator](https://www.ece.iastate.edu/~alexs/classes/i281_simulator/index.html)

We converted the single-cycle CPU to a multicycle one by removing the PC update block, adding a Control FSM for state update, and adding registers to store the Control FSM state.

We implemented the GCD instruction by drawing the FSM, assigning new states, and then filling the state update tables.

## GCD

Run the example using 
```
in src: $ .\run.bat
```

The GCD instruction computes the Greatest Common Divisor of Datamem[0], Datamem[1] and stores it in Datamem[2]

Here are the register values while `gcd(187, 119) = 17` is calculated in 44 cycles:

```
Cycle  Instr    State       A   B   C   D    Flags   Datamem[2]
    1: NOOP     IF          0   0   0   0    0000    0
    2: NOOP     IF          0   0   0   0    0000    0
    3: LOAD     ID          0   0   0   0    0000    0
    4: LOAD     ExLOAD      0   0   0   0    0000    0
    5: LOAD     MemREAD     0   0   0   0    0000    0
    6: LOAD     WbLOAD      0   0   0   0    0000    0
    7: LOAD     IF        187   0   0   0    0000    0
    8: LOAD     ID        187   0   0   0    0000    0
    9: LOAD     ExLOAD    187   0   0   0    0000    0
   10: LOAD     MemREAD   187   0   0   0    0000    0
   11: LOAD     WbLOAD    187   0   0   0    0000    0
   12: LOAD     IF        187 119   0   0    0000    0
   13: GCD      ID        187 119   0   0    0000    0
   14: GCD      ExCMP     187 119   0   0    0000    0
   15: GCD      WAIT      187 119   0   0    1100    0
   16: GCD      WbALU_RX  187 119   0   0    1100    0
   17: GCD      ExLR       68 119   0   0    1100    0
   18: GCD      ExCMP      68 119   0   0    1100    0
   19: GCD      WAIT       68 119   0   0    0010    0
   20: GCD      ExSWAPREG  68 119   0   0    0010    0
   21: GCD      ExCOMPUTE  68 119   0   0    0010    0
   22: GCD      WbALU_RY   68 119   0   0    0010    0
   23: GCD      ExLR       68  51   0   0    0010    0
   24: GCD      ExCMP      68  51   0   0    0010    0
   25: GCD      WAIT       68  51   0   0    1000    0
   26: GCD      WbALU_RX   68  51   0   0    1000    0
   27: GCD      ExLR       17  51   0   0    1000    0
   28: GCD      ExCMP      17  51   0   0    1000    0
   29: GCD      WAIT       17  51   0   0    0010    0
   30: GCD      ExSWAPREG  17  51   0   0    0010    0
   31: GCD      ExCOMPUTE  17  51   0   0    0010    0
   32: GCD      WbALU_RY   17  51   0   0    0010    0
   33: GCD      ExLR       17  34   0   0    0010    0
   34: GCD      ExCMP      17  34   0   0    0010    0
   35: GCD      WAIT       17  34   0   0    0010    0
   36: GCD      ExSWAPREG  17  34   0   0    0010    0
   37: GCD      ExCOMPUTE  17  34   0   0    0010    0
   38: GCD      WbALU_RY   17  34   0   0    0010    0
   39: GCD      ExLR       17  17   0   0    0010    0
   40: GCD      ExCMP      17  17   0   0    0010    0
   41: GCD      WAIT       17  17   0   0    1001    0
   42: GCD      ExMEMJUMP  17  17   0   0    1001    0
   43: GCD      MemWRITE   17  17   0   0    1001    0
   44: GCD      IF         17  17   0   0    1001   17
```
