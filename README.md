# ALU Verification Project (Verilog/SystemVerilog/VHDL/UVM)

## Objective
Design a **32-bit ALU** (RTL in Verilog + VHDL) and verify it using a **SystemVerilog UVM-style testbench** with directed and random tests, assertions, functional coverage, and automation infrastructure.  
This project demonstrates **digital design and verification workflows** used in CPU/GPU and SoC development.

## Features
- **RTL Design**
  - 32-bit ALU (ADD, SUB, AND, OR, XOR, SLT)
  - Status flags: Zero (Z), Negative (N), Carry (C), Overflow (V)
  - Implemented in both **Verilog** and **VHDL**
- **Verification Environment**
  - SystemVerilog **UVM-lite** testbench
  - Directed + random functional tests
  - Assertions to check design invariants (e.g., SLT outputs only {0,1})
  - Functional coverage on operations and flags
- **Automation & Infrastructure**
  - `Makefile` for build/run/clean targets
  - **Perl** script for parsing simulation logs (PASS/FAIL summary)
  - **TCL** wave configuration for GTKWave/Verdi
  - Works on **Linux** with open-source tools (Icarus Verilog + GTKWave)

## Tools & Technologies
- **Languages**: Verilog, SystemVerilog, VHDL, UVM-lite, Perl, TCL, Make
- **Simulation**: Icarus Verilog (`iverilog`), VVP runtime
- **Waveforms**: GTKWave (open-source), Verdi (optional)
- **OS/Infra**: Linux shell, Git/GitHub

## Usage
```bash
# Clone repo
git clone https://github.com/<your-username>/alu-verification-uvm.git
cd alu-verification-uvm

# Run simulation
make sim

# View waveforms
make waves
