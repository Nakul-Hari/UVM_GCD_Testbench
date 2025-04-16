# GCD SystemVerilog Testbench

## Problem Statement

This repository involves modifying an existing SystemVerilog testbench for a GCD (Greatest Common Divisor) module by introducing a modular architecture. The enhanced testbench includes components such as a generator, driver, monitor, scoreboard, interface, clocking block, and synchronization using mailboxes and events. These components are organized within an environment and controlled through a test module. The complete setup is simulated and validated on EDA Playground.

## Testbench Architecture

The testbench is structured to verify the functionality of the **GCD module** using a modular approach. It includes several SystemVerilog classes and interfaces organized to simulate and validate the **Design Under Test (DUT)**. Below is an overview of the components used:

- **Interface (`gcd_if`)**: Connects the DUT and testbench components, carrying signals such as inputs, outputs, clock, and reset.
- **Package (`gcd_pkg`)**: Encapsulates all class definitions, including the packet, **generator**, **driver**, **monitor**, **scoreboard**, and DUT model.
- **Generator**: Produces randomized input transactions and stores the expected results in a queue.
- **Driver**: Drives input values from the generator to the DUT through the interface.
- **Monitor**: Observes outputs from the DUT and forwards them to the scoreboard.
- **Scoreboard**: Compares DUT outputs with expected results to validate correctness.
- **Mailboxes**: Used for communication between the generator and driver.
- **Clocking**: A 100MHz clock is generated using a simple `always` block.
- **Simulation Flow**: The generator is run first to populate transactions. Then, the driver and monitor run concurrently, and the scoreboard evaluates the outputs.

The simulation is controlled from a **top-level module** (`tb_top`) where components are instantiated, connected, and executed. The simulation logs key events and terminates upon completion of all transactions.

## Components

### GCD Interface (`gcd_if`)

The `gcd_if` is a SystemVerilog interface that groups all the signals used to interact with the GCD hardware module. It includes input signals for the two operands, a signal to indicate when operands are valid, and an acknowledgment signal for the GCD result. The interface also has a clocking block to synchronize signal interaction with the rising edge of the clock.

### Transaction Class (`gcd_packet`)

The `gcd_packet` class holds the data required to test the GCD hardware module. It includes two randomized operands, `A` and `B`, with constraints ensuring that the values fall within a meaningful range. The class also includes a `copy()` function to create deep copies of packets and a `display()` function for debugging.

### Golden Reference Model (`calc_gcd()`)

The `calc_gcd()` function implements the golden reference model to compute the GCD using the Euclidean algorithm. This function is used to verify the correctness of the DUT's output.

### Driver Class

The `driver` class drives input values to the DUT from the generator through a mailbox. It runs in a continuous loop, driving the input operands and ensuring the DUT operates under realistic conditions by adding random delays between transactions.

### Monitor

The `monitor` class observes the DUT's output and verifies the computed GCD. It interacts with the scoreboard to compare the DUT's output against the expected values.

### Scoreboard

The `scoreboard` class tracks the expected results and compares them with the actual output produced by the DUT. It uses a queue to store expected values and checks the DUT's output when the `gcd_valid` signal is asserted.

### Generator

The `generator` class generates random test data for the DUT. It creates randomized `gcd_packet` instances and computes the expected GCD results, which are stored in the scoreboard for validation.

### Package

The `gcd_pkg` package includes the components necessary for testing the GCD functionality. It imports the `gcd_packet`, `generator`, `calc_gcd`, `driver`, `scoreboard`, and `monitor` modules to provide a complete verification environment.

### Testbench Top Module

The `tb_top` module serves as the top-level testbench for the simulation. It generates a 100 MHz clock, initializes the testbench components, and coordinates the interaction between the generator, driver, monitor, and scoreboard. The testbench ensures that all components work together for a comprehensive verification of the GCD functionality.

## Simulation Log & Results

The simulation was executed using **Synopsys VCS**. The terminal output includes:

- Packet generation log:
  ```
  [TB] Generated packet -> A = 15, B = 30, operands_valid = 1
  [TB] Generated packet -> A = 42, B = 187, operands_valid = 1
  ...
  ```

- Verification log:
  ```
  [PASS] Time=95000 | DUT: 15 Expected: 15
  [PASS] Time=365000 | DUT: 1 Expected: 1
  [PASS] Time=625000 | DUT: 1 Expected: 1
  ...
  ```

- All transactions pass, confirming DUT correctness for the tested input range.

---

## How to Run

1. **Setup**
   - Install Synopsys VCS (or other supported SystemVerilog simulators).

2. **Compile**
   ```bash
   vcs -sverilog -debug_all tb_top.sv gcd_if.sv gcd_packet.sv driver.sv monitor.sv calc_gcd.sv top_module.sv
   ```

3. **Simulate**
   ```bash
   ./simv
   ```

4. **Check Results**
   - Verify `[PASS]` messages in the terminal output.

---

## Conclusion
This testbench design demonstrates a structured and scalable approach to hardware verification using **SystemVerilog classes**, **queues**, and **interfaces**. It ensures robust testing through randomized stimulus, reference model checking, and automated scoreboarding.


## Acknowledgments
This implementation is part of the course work for EE5530 Principles of SoC Functional Verification

