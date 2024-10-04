# Verilog-CPU
This pipelined CPU design optimizes instruction throughput by processing multiple instructions concurrently while effectively handling data and control hazards, ensuring robust performance and correctness.
The design features five key stages:

Instruction Fetch (IF):

Retrieves instructions from memory using the program counter (PC).
Handles branching by modifying the PC based on branch instructions.
Instruction Decode (ID):

Decodes instructions to determine operation types and identifies source/destination registers.
Generates control signals and manages data hazards through forwarding and stalling.
Execute (EX):

Performs arithmetic and logic operations using the ALU.
Resolves data dependencies with forwarding logic and determines branching results.
Memory Access (MEM):

Executes load and store operations, reading from or writing to memory as needed.
Control signals ensure correct memory interactions.
Write Back (WB):

Writes results of ALU operations or memory reads back to the destination registers.
Pipeline Control & Hazard Handling
Data hazards are managed through forwarding, allowing values from previous instructions to be used without stalling.
Control hazards are mitigated using branch prediction and pipeline flushing when necessary.
Stalling logic is included to maintain the correct sequence of operations.
