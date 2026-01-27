# 5-Stage Pipelined RISC-V (RV32I) CPU

This project implements a **32-bit 5-stage pipelined RISC-V (RV32I) CPU** in **Verilog**, designed and verified using **Xilinx Vivado**.

The processor follows the classic pipeline stages:
**Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB)**, with explicit pipeline registers between stages.

---

## Features

- RV32I base instruction set (subset)
- 5-stage pipeline: IF → ID → EX → MEM → WB
- Pipeline registers: IF/ID, ID/EX, EX/MEM, MEM/WB
- Modular Verilog design
- Instruction-level verification using waveform analysis
- Implemented and simulated in Xilinx Vivado

---

## Architecture Overview

The CPU follows a standard textbook 5-stage pipelined datapath.  
A conceptual block diagram of the architecture is provided below.

 **Diagrams**
- `diagrams/pipeline_block_diagram.png` – Conceptual 5-stage pipeline architecture
- `diagrams/rtl_schematic_vivado.png` – Vivado-generated RTL schematic (tool-generated)

---

## Verification & Waveforms

Functional correctness is verified using **Vivado behavioral simulation**.

The waveforms demonstrate:
- Correct instruction flow through pipeline stages
- One-cycle delay between IF/ID, ID/EX, EX/MEM, MEM/WB
- Correct propagation of destination register (`rd`)
- Correct write-back of ALU results

 **Waveforms**
- `waveforms/` contains screenshots showing pipeline behavior and write-back verification

---

## Project Structure

src/
├── cpu_top.v # Top-level pipelined CPU
├── pc.v # Program Counter
├── imem.v # Instruction Memory
├── regfile.v # Register File
├── alu.v # ALU
├── imm_gen.v # Immediate Generator

diagrams/
├── pipeline_block_diagram.png
├── rtl_schematic_vivado.png

waveforms/
├── README.md # Waveform explanation + screenshots

sim/
├── cpu_tb.v # Testbench


---

## Notes

- This implementation focuses on **pipeline structure and data flow**
- Hazard detection, forwarding, and branch prediction are **not implemented**
- The design is intended for **educational and architectural demonstration**

---

## Tools Used

- Verilog HDL
- Xilinx Vivado (Simulation & RTL analysis)

---

## Author

**Abhineet Singh**  
Electronics & Communication Engineering  
Interest areas: Computer Architecture, VLSI, Digital Design
