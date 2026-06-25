# Week 2 (Friday): Architecture, Bare Metal, and the Software-Hardware Bridge

## Objective
> Trace the execution path of embedded firmware from high-level abstractions down to physical voltage changes. The ultimate, foundational rule of this domain established today is: **Every hardware component is controlled by writing to memory.** 

## System Architecture & Low-Level Execution
To write effective firmware, we must understand the silicon executing it.

### 1. Instruction Sets: RISC vs. CISC
RISC (Reduced Instruction Set Computer) and CISC (Complex Instruction Set Computer) are **Instruction Set Architectures (ISAs)**, not physical hardware layouts. They define the vocabulary of commands the processor understands. ARM chips (like our Raspberry Pi Pico) use RISC, focusing on simple, highly optimized instructions that execute in a single clock cycle.

### 2. CPU Registers (32-bit vs. 64-bit)
Registers are the fastest, smallest memory locations directly inside the CPU. A 32-bit vs. 64-bit architecture simply dictates the width of these registers—how much data the CPU can process or point to in a single operation. When we want to turn on an LED, we are ultimately writing a `1` or a `0` to a specific bit inside a hardware register mapped to that physical pin.

## The Software Pipeline
How does code written on a laptop run on a microcontroller?

### 1. Language Models
* **Compiled (C/C++):** Code is translated entirely into machine code before running. Fast, efficient, and deterministic.
* **Interpreted (Python):** Code is translated line-by-line during runtime. Slower and requires an interpreter program running on the chip.
* **Hybrid:** Compiles to an intermediate bytecode (like Java or MicroPython's `.mpy` files) before interpretation.

### 2. Cross-Compilation & GCC
**Cross-compilation** is the process of building executable code for a platform other than the one you are writing on. 
**The Benefit:** Microcontrollers lack the RAM and processing power to run complex compilers like GCC (GNU Compiler Collection). By cross-compiling, we use our powerful x86/64 laptops to do the heavy lifting, generating an optimized ARM binary that we simply flash (port) onto the Pico.

## Operating Environments
* **Bare Metal:** The firmware runs directly on the hardware with absolute, unrestricted access to memory and peripherals. 
* **Operating Systems (OS):** Uses a **Device Tree** (a data structure describing the hardware) so the OS kernel can manage resources abstractly. 
* **RTOS (Real-Time Operating Systems):** Critical for embedded systems. An RTOS guarantees **deterministic behavior**—tasks are guaranteed to execute within a strict, predictable microsecond deadline. 

> **Case Study: The Toyota Camry Unintended Acceleration**
> We discussed the dangers of poorly designed embedded software. A stack overflow and task starvation issue in Toyota's engine control firmware caused unintended acceleration. It perfectly highlights why **deterministic behavior** and robust RTOS architectures are non-negotiable in life-critical systems. 

## Electronics & Communication Theory
* **Power:** A component's required voltage and the current it draws dictate our circuit design.
* **LEDs (Light Emitting Diodes):** Because they are diodes, they only allow current to flow in one direction and have a specific "forward voltage" drop that must be accounted for with resistors.
* **PWM (Pulse Width Modulation):** Simulating an analog voltage by toggling a digital pin ON and OFF incredibly fast. This is exactly how we achieve screen brightness or dim LEDs.

* **Communication (Sync vs. Async):** Synchronous communication shares a clock line between devices to coordinate data transfer. Asynchronous relies on both devices agreeing on a strict timing speed (baud rate). 
* **Timing Diagrams:** Found in component datasheets, these visual graphs map out exactly how data bits align with clock pulses. They are the ultimate source of truth for communication debugging.


## Code Implementation: The "Hello World"
The embedded equivalent of "Hello World" is blinking an LED. 

While C/C++ is the industry standard, we evaluated **MicroPython** and **CircuitPython** (a beginner-friendly fork created by Adafruit).

```python
# Accessing the board via REPL or VSCode extension
import board

# The board module holds the software representation of the physical pins
# Running dir(board) in the REPL lists all accessible hardware pins
print(dir(board))
```