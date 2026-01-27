# 5-Stage Pipelined RISC-V CPU (RV32I)

This repository contains a **5-stage pipelined RISC-V (RV32I) CPU**
implemented in **Verilog HDL** and verified using **Vivado behavioral simulation**.

The design focuses on correct **pipeline structure, timing, and data/control
propagation** across all stages.

---

## Pipeline Stages

1. Instruction Fetch (IF)  
2. Instruction Decode (ID)  
3. Execute (EX)  
4. Memory (MEM)  
5. Write Back (WB)

Each stage is separated using pipeline registers:
- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

---

## Supported Instructions

- ADD (R-type)
- ADDI (I-type)
- BEQ (branch)

---

## Verification

The CPU is verified through a Verilog testbench using
**Vivado behavioral simulation**.

Verification includes:
- Correct pipeline timing (one instruction per cycle after fill)
- Proper propagation of data and control signals
- Correct write-back of results at the WB stage

Waveform screenshots demonstrating pipeline behavior
are included in the `waveforms/` directory.

---

## Project Structure

