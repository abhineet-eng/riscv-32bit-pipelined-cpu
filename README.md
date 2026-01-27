# riscv-32bit-pipelined-cpu

5-stage pipelined RISC-V (RV32I) CPU implemented in Verilog.

## Pipeline Stages
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory (MEM)
- Write Back (WB)

## Supported Instructions
- ADD
- ADDI
- BEQ

## Verification
Verified using Vivado behavioral simulation.
Pipeline timing and correct write-back are validated via waveform analysis.

## Tools
- Verilog HDL
- Xilinx Vivado
