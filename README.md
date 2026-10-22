# APB Protocol Verification Using SystemVerilog and UVM

## 1. Project Overview

This project verifies an Advanced Peripheral Bus (APB) slave using SystemVerilog and the Universal Verification Methodology (UVM).

The testbench was simulated using QuestaSim 10.7c with UVM 1.1d. It generates APB read and write transactions, drives bus signals through a virtual interface, monitors completed transfers, checks read data using a scoreboard, and measures functional coverage.

## 2. Design Features

- APB slave with four memory-mapped 8-bit registers.
- Register addresses: `0x00`, `0x04`, `0x08`, and `0x0C`.
- Read and write transactions.
- Ready and error response signals.

## 3. UVM Testbench Architecture

The verification environment is organized using standard UVM components.

- **Sequence Item:** Defines randomized APB transactions.
- **Sequence:** Generates 100 transactions.
- **Sequencer:** Sends transactions to the driver.
- **Driver:** Drives APB signals through the virtual interface.
- **Monitor:** Observes completed APB transfers.
- **Scoreboard:** Compares read data with the reference model.
- **Functional Coverage:** Tracks the read/write and address bins defined in the covergroup.
- **Agent and Environment:** Connect the verification components.
- **Test:** Starts the sequence and manages the simulation.

### Verification Flow

```text id="g5b2cz"
       UVM Test
           |
           v
        Sequence
           |
           v
        Sequencer
           |
           v
         Driver
           |
           v
        APB Slave
           |
           v
         Monitor
           |
           v
       Scoreboard
           |
           v
    Expected vs Actual

   Functional Coverage
   tracks defined covergroup bins
```

## 4. Simulation Results

The simulation was performed using QuestaSim 10.7c and UVM 1.1d.

| Metric | Result |
|---|---:|
| Transactions observed | 100 |
| Scoreboard PASS count | 54 |
| Scoreboard FAIL count | 0 |
| Functional coverage | 100% |
| UVM warnings | 0 |
| UVM errors | 0 |
| UVM fatal errors | 0 |

**Note:** The scoreboard PASS count represents successful read comparisons; writes are logged separately. The 100% functional coverage applies to the covergroup bins defined in this testbench, not every possible APB scenario.

## 5. Simulation Waveform

The waveform shows the APB clock, reset, control signals, address, write data, read data, and response signals during simulation.

![APB UVM Simulation Waveform](APB_Verification_UVM_waveform.jpeg)

[**View Full-Size APB UVM Waveform**](APB_Verification_UVM_waveform.jpeg)

## 6. Tools and Technologies

- SystemVerilog
- Universal Verification Methodology (UVM 1.1d)
- QuestaSim 10.7c
- Class-Based Verification
- Sequence and Sequencer
- Driver and Monitor
- Scoreboard-Based Checking
- Functional Coverage

## 7. Repository Structure

```text id="5vb5xp"
APB-Verification-With-UVM/
├── rtl/
├── tb/
├── simulation/
├── APB_Verification_UVM_waveform.jpeg
└── README.md
```

## 8. Future Improvements

- Add protocol assertions.
- Test invalid-address and error-response scenarios.
- Extend coverage for additional APB protocol scenarios.
- Add more directed tests for boundary conditions.

## Author

**Kethana Rakshitha**

Electronics and Communication Engineering Student | VLSI Design Verification

GitHub: [kethana-rakshitha](https://github.com/kethana-rakshitha)
