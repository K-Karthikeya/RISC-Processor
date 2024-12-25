# RISC-Processor
A 5-staged pipelined RISC Processor built with custom ISA that can support 16 instructions broadly classified into – instructions, broadly classified into arithmetic, branch and memory instructions, with added L1 instruction and data caches.

The project involves the design and implementation of a 5-stage pipelined processor based on the WISC F24 ISA. The pipelined architecture is divided into the following key stages: 
1.	Instruction Fetch (IF)
2.	Instruction Decode (ID)
3.	Execute (EX)
4.	Memory Access (MEM)
5.	Write Back (WB)

These stages are executed over multiple cycles, enabling concurrent execution of instructions to improve performance.

The processor integrates L1 Instruction and Data caches to minimize memory access latency and improve overall efficiency. Hazard detection, data forwarding, and branch detection mechanisms are incorporated to handle pipeline conflicts and optimize execution flow.

Key Features:
1.	Pipeline Stages:
  Fetch (IF): The program counter (PC) fetches the next instruction from the instruction cache.
  Decode (ID): The instruction is decoded, and operands are read from the register file.
  Execute (EX): The ALU performs the required arithmetic or logic operations.
  Memory (MEM): The data memory is accessed for load/store instructions when Data cache is not implemented. Along with the Data cache implementation, memory is used to load the data in D-cache and write the updated data in memory from cache.
  Write Back (WB): Results are written back to the register file.
2.	Hazard Detection and Resolution:
  The predict-not-taken policy is implemented for branch prediction. The Branch Hazard Detection Unit resolves control hazards by flushing ongoing instructions when a branch is taken.
  The Data Hazard Detection Unit manages stalls to prevent incorrect data propagation and enables stall signal for PC and IF/ID pipeline register.
  Data Forwarding is implemented for faster execution, avoiding unnecessary stalls, and efficient data reuse:
  EX-EX Forwarding: Forwards data directly between execution stages.
  MEM-EX Forwarding: Forwards data from the memory stage to the execution stage.
3.	Control Unit and Branch Handling:
  The control unit generates the required control signals for all pipeline stages.
  Branch Detection ensures correct branch resolution, with instructions flushed from the pipeline if a branch is taken. Branches are resolved in Decode stage.
4.	Cache Integration:
  The processor includes L1 Instruction Cache to store instructions and an L1 Data Cache to store data, reducing latency and enhancing throughput.
  A Cache Miss Handler ensures proper memory access when a cache miss occurs.
5.	Forwarding and Stall Mechanisms:
  The Forwarding Unit enables forwarding paths for EX-EX, MEM-EX, and MEM-to-MEM stages to minimize stalls.
  A stall signal is used to freeze the pipeline when hazards are detected.

This project demonstrates a fully functional pipelined processor capable of mitigating hazards while maintaining optimal performance. The combination of data forwarding, hazard detection, branch handling, and cache integration ensures efficient instruction execution and improved overall performance.

