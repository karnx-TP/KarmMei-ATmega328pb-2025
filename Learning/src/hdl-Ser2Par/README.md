# 📂 Ser2Par

This folder contains a **Serial-to-Parallel (Ser2Par)** design written in **SystemVerilog**, along with its testbench and simulation scripts.  

---

## 📄 Files

1. **`ser2par.sv`**  
   - RTL design of a **Serial-to-Parallel converter**.  
   - Converts serial input data (from SerDataIn) into parallel output (to ParDataOut[7:0])
   - **Ports:**
     - `RstB` : Active-low reset (clears register).  
     - `Clk` : Clock input.  
     - `SerDataIn` : Serial data input.  
     - `SerDataEn` : Serial data enable.
     - `ParDataOut[7:0]` : 8-bit parallel output.  
   - **Behavior:**  
     - On reset, output is cleared (`0x00`).  
     - On every rising clock edge, the serial input is shifted into the MSB, while the previous bits shift right.  
     - Example: If `SerDataIn` streams bits `[b0->b1->b2 ... b3]` sequentially (b0 in first), `ParDataOut` will eventually hold `[b7 b6 ... b0]` (right shift register).  


2. **`ser2par_tb.sv`**  
   - Testbench for verifying `ser2par.sv`.  
   - Currently, Have only **BASIC case testing**
3. **`/sim/`**  
   - Contains simulation-related files.  
   - **`run.do`** – A ModelSim/QuestaSim script for compiling and running the simulation.  

---

## ▶️ How to Run Simulation

1. Open **ModelSim/QuestaSim**.  
2. Navigate to the `/sim/` folder.  
3. Run the script: do run.do
4. see timing diagram