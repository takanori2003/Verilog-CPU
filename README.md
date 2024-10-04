# Verilog-CPU
// Pipelined CPU Design Overview
// Optimizes instruction throughput by processing multiple instructions concurrently
// Effectively handles data and control hazards, ensuring robust performance and correctness.

/////////////////////////////////////////////////////
// Key Pipeline Stages
/////////////////////////////////////////////////////

// 1. Instruction Fetch (IF)
/////////////////////////////////////////////////////
// - Retrieves instructions from memory using the program counter (PC).
// - Handles branching by modifying the PC based on branch instructions.


// 2. Instruction Decode (ID)
/////////////////////////////////////////////////////
// - Decodes instructions to determine operation types.
// - Identifies source and destination registers.
// - Generates control signals.
// - Manages data hazards through forwarding and stalling.


// 3. Execute (EX)
/////////////////////////////////////////////////////
// - Performs arithmetic and logic operations using the ALU.
// - Resolves data dependencies with forwarding logic.
// - Determines branching results.


// 4. Memory Access (MEM)
/////////////////////////////////////////////////////
// - Executes load and store operations.
// - Reads from or writes to memory as needed.
// - Ensures correct memory interactions using control signals.


// 5. Write Back (WB)
/////////////////////////////////////////////////////
// - Writes results of ALU operations or memory reads back to destination registers.

/////////////////////////////////////////////////////
// Pipeline Control & Hazard Handling
/////////////////////////////////////////////////////

// Data Hazards:
// - Managed through forwarding, allowing values from previous instructions to be used without stalling.

// Control Hazards:
// - Mitigated using branch prediction and pipeline flushing when necessary.

// Stalling Logic:
// - Included to maintain the correct sequence of operations.
