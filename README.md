# 8-Bit Central Processing Unit (FPGA)

A synthesizable 8-bit CPU architecture designed using VHDL, featuring a modular ALU, a Moore-machine control unit, and digital logic circuit components.
Designed in Quartus II 13.0 to be implemented on an Altera Cyclone II FPGA (EP2C35F672C6).

## Block Diagram using the first ALU
<img width="1293" height="519" alt="image" src="https://github.com/user-attachments/assets/5d6da782-6ed6-492f-a608-a4757a0cb2c8" />

## Table of Contents
- [What is this Project?](#what-is-this-project)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
  - [The Datapath](#the-datapath)
  - [Registers (D Flip-flops)](#registers-d-flip-flops)
  - [3-to-8 Decoder](#3-to-8-decoder)
  - [Finite State Machine (FSM)](#finite-state-machine-fsm)
  - [The Arithmetic Logic Units (ALU)](#the-arithmetic-logic-units-alu)
    - [ALU 1: Standard Arithmetic & Logic](#alu-1-standard-arithmetic--logic)
    - [ALU 2: Advanced Operations](#alu-2-advanced-operations)
    - [ALU 3: Status & Parity](#alu-3-status--parity)
- [Technical Implementation Details](#technical-implementation-details)
  - [Design Decisions](#design-decisions)
  - [Toolchain](#toolchain)
- [Building the Project](#building-the-project)
- [Appendix: Calculations & Conversions](#appendix-calculations--conversions)



## What is this Project?

This project is a custom 8-bit CPU. I used **VHDL** to define the actual logic gates, flip-flops, and wires. It's composed of decoders, registers, multiple versions of an ALU, sseg displays, and an FSM.

The main purpose of this project is to gain a fundamental understanding of how computers work, a better grasp of digital logic, clock cycles, and data movement.

## Key Features

### Core Structure
- **8-Bit Data Bus:** All registers and arithmetic operations handle 8-bit standard logic vectors.
- **Modular ALU:** Swappable ALU designs allowing for different instruction sets (Arithmetic, Logic, Shifting).
- **Global Behaviour:** Operates on a positive edge-triggered clock signal and active-low asynchronous reset signal.

### Control System
- **Moore Machine FSM:** An 8-state Finite State Machine that feeds into a decoder allowing control of the ALU based on certain opcodes.
- **One-Hot Decoding:** A 3-to-8 decoder converts binary states into control signals for the datapath.

### Verification/Testing
- **Waveform Simulations:** `.vwf` Timing diagrams for every component.
- **Testing:** Register inputs "A" and "B" will be arbitrarily set to `0x61` and `0x48` respectively for all simulations.

## Project Structure

```text
Simple_CPU_design/
├── src/
│   ├── ALU_designs/       # VHDL source for ALU1, ALU2, ALU3
│   ├── components/        # VHDL source for FSM, Decoder, Registers, etc
│   └── block_diagrams/    # Graphical block diagram schematics (.bdf)
├── sim/                   # Waveform Files (.vwf) for verification
├── project/               # Quartus project file and settings (.qpf, .qsf)
└── README.md
```

## How It Works

### The Datapath

1.  **Input:** Data enters through the registers.
2.  **Storage:** 8-bit registers (latches) hold the current operands.
3.  **Processing:** The ALU processes the data based on the current Opcode.
4.  **Output:** The result is placed on the bus, ready to be displayed on 7-segment displays.

---

### Registers (D Flip-flops)

The registers operate as storage units with the purpose of storing binary values, which it will then pass onto the ALU as input for processing on a positive edge triggered clock signal.

#### Register Operation Logic:
| Input | Clk | Reset | Output |
| :--- | :---: | :---: | :--- |
| Q(t) | 0 | 0 | 0 |
| Q(t) | 0 | 1 | Q(t) |
| Q(t) | 1 | 0 | 0 |
| Q(t) | 1 | 1 | Q(t+1) |

<details>
<summary><strong>Click to expand for the block component</strong></summary>

<img width="249" height="152" alt="image" src="https://github.com/user-attachments/assets/93280105-6896-416f-9e4f-df1295fda9a6" />

</details>

#### Waveform Simulation:
<img width="1669" height="512" alt="Screenshot 2026-02-01 011116" src="https://github.com/user-attachments/assets/88bfa937-08fc-40c7-aa12-682b8efda096" />

---

### 3-to-8 Decoder

The 3-to-8 decoder acts as a translator for the FSM, outputting instructions as 1-out-of-8 operation codes (opcode). 
These opcodes feed into the ALU, serving to determine what function is to be used by the ALU at the current state. The main input to the decoder is the 3-bit state input from the FSM.

#### Decoder Truth Table:
| Current State | Opcode |
| :---: | :---: |
| 000 | 00000001 |
| 001 | 00000010 |
| 010 | 00000100 |
| 011 | 00001000 |
| 100 | 00010000 |
| 101 | 00100000 |
| 110 | 01000000 |
| 111 | 10000000 |

<details>
<summary><strong>Click to expand for the block component</strong></summary>

<img width="255" height="146" alt="image" src="https://github.com/user-attachments/assets/8822a1a8-b701-4f36-8d9b-6ae04b52d0f0" />

</details>

#### Waveform Simulation:
<img width="1594" height="394" alt="image" src="https://github.com/user-attachments/assets/d3eb49ba-f8aa-4853-8a4b-2aa0f4e08652" />

---

### Finite State Machine (FSM)

The FSM functions as a 3-bit program up-counter, supplying the addresses of instructions
to the decoder based on the clock and its current state. The FSM outputs the 3-bit current state
when clocked and moves on the next state. It's an 8 state cycle, from 0 to 7 then
back to 0 and so on. The FSM also outputs the numbers “01236148” as binary in sequence
referring to the digits of my student number corresponding to states 0 to 7. For ALU 1 and 2,
the student number output is not used.

#### FSM Transition Table:
| Current State | Next State (data_in = 0) | Next State (data_in = 1) | Student # Output |
| :---: | :---: | :---: | :---: |
| 000 | 000 | 001 | 0000 |
| 001 | 001 | 010 | 0001 |
| 010 | 010 | 011 | 0010 |
| 011 | 011 | 100 | 0011 |
| 100 | 100 | 101 | 0110 |
| 101 | 101 | 110 | 0001 |
| 110 | 110 | 111 | 0100 |
| 111 | 111 | 000 | 1000 |

<details>
<summary><strong>Click to expand for details</strong></summary>
  
| State # | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Student # Output** | 0 | 1 | 2 | 3 | 6 | 1 | 4 | 8 |

<img width="297" height="456" alt="image" src="https://github.com/user-attachments/assets/0421548a-3717-4a54-b51d-fbfd333475c3" />

</details>

#### Waveform Simulation:
<img width="1685" height="437" alt="image" src="https://github.com/user-attachments/assets/41d36b84-eefb-4ec3-bc1d-2e1906bc8644" />

---

### The Arithmetic Logic Units (ALU)

The ALU is the main component of the CPU, where it performs one of its arithmetic functions based on the provided opcode which is fetched from the decoder. 
The values in which it performs the specified functions on, is based on the input values it receives from the registers. 
In the case of this project, the FSM cycles through the 8 states in order, and accordingly, the ALU performs the 8 functions one by one in the same order. 

> **Note:** For a detailed breakdown of the manual verification calculations used to validate these ALUs, please see the [Appendix: Calculations & Conversions](#appendix-calculations--conversions).

#### ALU 1: Standard Arithmetic & Logic
The foundational unit handling basic math and bitwise logic.
- **Math:** Addition (`+`), Subtraction (`-`)
- **Logic:** `AND`, `OR`, `XOR`, `NAND`, `NOR`, `NOT`
- **Output:** Pure 8-bit result.

<details open>
<summary><strong>Click to expand for the ALU1 function table</strong></summary>

| Function # | Opcode | Function | Operation |
| :---: | :---: | :---: | :--- |
| 1 | 00000001 | Sum(A, B) | Addition |
| 2 | 00000010 | Diff(A, B) | Subtraction |
| 3 | 00000100 | $\overline{A}$ | NOT A |
| 4 | 00001000 | $\overline{A \cdot B}$ | NAND |
| 5 | 00010000 | $\overline{A + B}$ | NOR |
| 6 | 00100000 | $A \cdot B$ | AND |
| 7 | 01000000 | $A \oplus B$ | XOR |
| 8 | 10000000 | $A + B$ | OR |
</details>

#### ALU1 Waveform Simulation:
<img width="1541" height="409" alt="image" src="https://github.com/user-attachments/assets/b1eb3f30-c6a7-45a0-8530-df2a9eb29598" />


The ALU receives and performs the calculations above on two 8-bit operands (`Reg1`, `Reg2`).

#### ALU 2: Advanced Operations
This unit introduces more complex bit manipulation.
- **Barrel Shifting:** Rotate Left (ROL) and Shift Right (SHR).
- **Comparison:** `Max(A, B)` returns the larger of two values.
- **Conditional Swaps:** Swapping upper and lower nibbles (4-bit chunks).

<details open>
<summary><strong>Click to expand for the ALU2 function table</strong></summary>

| Function # | Opcode | Operation | Description |
| :---: | :---: | :--- | :--- |
| 1 | 00000001 | A SHR 2 | Shift A right by 2 bits (input bit = 1) |
| 2 | 00000010 | Sum(Diff(A, B), 4) | (A - B) + 4 |
| 3 | 00000100 | Max(A, B) | Output the larger value |
| 4 | 00001000 | B[3..0] & A[3..0] | Concatenate lower nibbles of B and A |
| 5 | 00010000 | Sum(A, 1) | Increment A by 1 |
| 6 | 00100000 | $A \cdot B$ | Bitwise AND |
| 7 | 01000000 | $\overline{A[7..4]}$ & $A[3..0]$ | Invert upper nibble of A, keep lower nibble |
| 8 | 10000000 | B ROL 3 | Rotate B left by 3 bits |
</details>

#### ALU2 Waveform Simulation:
<img width="1670" height="457" alt="image" src="https://github.com/user-attachments/assets/ad7180a7-6bc6-4a90-9b72-01b2ffc08e3a" />


#### ALU 3: Status & Parity
A specialized unit designed for flag checking rather than raw calculation.
- **Parity Check:** Analyzes a Student ID input to determine Even/Odd status.
- **Output:** Returns specific hex codes (`0xE` for even, `0xF` for odd).

<details open>
<summary><strong>Click to expand for the ALU3 function table</strong></summary>

| Function # | Opcode | Student # Digit | Function |
| :---: | :---: | :---: | :--- |
| 1 | 00000001 | 0 | Check even/odd : y/n |
| 2 | 00000010 | 1 | Check even/odd : y/n |
| 3 | 00000100 | 2 | Check even/odd : y/n |
| 4 | 00001000 | 3 | Check even/odd : y/n |
| 5 | 00010000 | 6 | Check even/odd : y/n |
| 6 | 00100000 | 1 | Check even/odd : y/n |
| 7 | 01000000 | 4 | Check even/odd : y/n |
| 8 | 10000000 | 8 | Check even/odd : y/n |
</details>

#### ALU3 Waveform Simulation:
<img width="1750" height="516" alt="image" src="https://github.com/user-attachments/assets/42957337-f5ab-4c6e-8d7b-febcda9f00cb" />


## Technical Implementation Details

### Design Decisions

**Directory Structure:**
I implemented a separation of file types to keep the repository clean:
- Source code (VHDL files and block diagrams) are in `src/`.
- Simulation waveforms are in `sim/` to prevent auto-deletion by the IDE.
- Quartus build outputs are contained in `project/`.

**Toolchain:**
- **IDE:** Altera Quartus II (v13.0sp1). *latest version compatible with Cyclone II FPGAs*
- **Simulation:** Quartus Built-in Simulator / ModelSim.
- **Language:** VHDL

**Additional note:**
- I didn't include details about the binary to SSEG converter modules here, but they're simply converting hex values to sseg equivalents. They're connected to the outputs of the various components to be seen on the FPGA board 7-segment displays.

## Building the Project

### Compiling and Simulating

Follow these steps to get the project running on your local machine:

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/TerryChen05/Simple_CPU_design.git
    ```

2.  **Open the Project**
    * Launch **Quartus II 13.0sp1**, and go to `File -> Open Project`.
    * Navigate to the `project/` folder and select **`CPU_design.qpf`**.

3.  **Compile the Design**
    * Using the `Project Navigator`, set a design as 'Top-level Entity'
    * Go to the menu bar and select `Processing -> Start Compilation`.
    * Wait for the "Full Compilation was successful" message.

4.  **Run a Simulation**
    * Go to `File -> Open` and enter the `sim/` folder.
    * Select a Waveform Vector File (e.g., **`ALU1.vwf`** or **`CPU_design1.vwf`**).
    * In the Simulation Waveform Editor, click **`Simulation -> Run Functional Simulation`** (ensure you set the corresponding file as the Top-level Entity first).
    * A new window will pop up showing the timing diagram results.

## Appendix: Calculations & Conversions

The following tables document the manual verification calculations used to validate the simulation waveforms.

### ALU Verification

**Test Vectors Used:**
* **Input A:** `0x61` (binary `0110 0001`)
* **Input B:** `0x48` (binary `0100 1000`)

<details>
<summary><strong>ALU 1 Calculations (Standard Arithmetic & Logic)</strong></summary>

| Function # | Function | Expected Output (Binary) | Hex Representation |
| :---: | :---: | :---: | :---: |
| 1 | Sum(A, B) | 1010 1001 | A 9 |
| 2 | Diff(A, B) | 0001 1001 | 1 9 |
| 3 | $\overline{A}$ | 1001 1110 | 9 E |
| 4 | $\overline{A \cdot B}$ | 1011 1111 | B F |
| 5 | $\overline{A + B}$ | 1001 0110 | 9 6 |
| 6 | $A \cdot B$ | 0100 0000 | 4 0 |
| 7 | $A \oplus B$ | 0010 1001 | 2 9 |
| 8 | $A + B$ | 0110 1001 | 6 9 |

_Return to [ALU1: Standard Arithmetic & Logic](#alu-1-standard-arithmetic--logic)_

</details>

<details>
<summary><strong>ALU 2 Calculations (Advanced Operations)</strong></summary>

| Function # | Function | Expected Output (Binary) | Hex Representation |
| :---: | :---: | :---: | :---: |
| 1 | A SHR 2 | 1101 1000 | D 8 |
| 2 | Sum(Diff(A, B), 4) | 0001 1101 | 1 D |
| 3 | Max(A, B) | 0110 0001 | 6 1 |
| 4 | B[3..0] & A[3..0] | 1000 0001 | 8 1 |
| 5 | Sum(A, 1) | 0110 0010 | 6 2 |
| 6 | $A \cdot B$ | 0100 0000 | 4 0 |
| 7 | $\overline{A[7..4]}$ & $A[3..0]$ | 1001 0001 | 9 1 |
| 8 | B ROL 3 | 0100 0010 | 4 2 |

_Return to [ALU 2: Advanced Operations](#alu-2-advanced-operations)_
</details>

<details>
<summary><strong>ALU 3 Calculations (Status/Parity)</strong></summary>

| Function # | Function | Student # Digit | Output | SSEG Output |
| :---: | :---: | :---: | :---: | :---: |
| 1 | Check even/odd | 0 | y | 1110 |
| 2 | Check even/odd | 1 | n | 1111 |
| 3 | Check even/odd | 2 | y | 1110 |
| 4 | Check even/odd | 3 | n | 1111 |
| 5 | Check even/odd | 6 | y | 1110 |
| 6 | Check even/odd | 1 | n | 1111 |
| 7 | Check even/odd | 4 | y | 1110 |
| 8 | Check even/odd | 8 | y | 1110 |

_Return to [ALU 3: Status & Parity](#alu-3-status--parity)_
</details>

---

### Reference Charts

<details>
<summary><strong>Hex to 7-Segment Conversion Chart (Active Low)</strong></summary>

| SSEG Input | SSEG Output ("ABCDEFG") | Hex Representation |
| :---: | :---: | :---: |
| 0000 | 0000001 | 0 |
| 0001 | 1001111 | 1 |
| 0010 | 0010010 | 2 |
| 0011 | 0000110 | 3 |
| 0100 | 1001100 | 4 |
| 0101 | 0100100 | 5 |
| 0110 | 0100000 | 6 |
| 0111 | 0001111 | 7 |
| 1000 | 0000000 | 8 |
| 1001 | 0001100 | 9 |
| 1010 | 0001000 | A |
| 1011 | 1100000 | B |
| 1100 | 0110001 | C |
| 1101 | 1000010 | D |
| 1110 | 0110000 | E |
| 1111 | 0111000 | F |

</details>

<details>
<summary><strong>Custom Status Output Chart </strong></summary>

| SSEG Input | SSEG Output ("ABCDEFG") | Representation |
| :---: | :---: | :---: |
| 1110 (0xE) | 1000100 | y (yes/even) |
| 1111 (0xF) | 1101010 | n (no/odd) |

</details>
