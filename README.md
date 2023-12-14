Project Title: The Time Machine

Names: Cole Shaigec, Henry Bega, Alex Melnick, Macy Bryer-Charette
UIDs: U38987069 (Cole), U27797675 (Henry),  and U11534484 (Macy)
TF name: Shiva Raja

GitHub Repository Link:
Demonstration Video Link:


PROJECT DESCRIPTION
	We have constructed a multifunctional programmable stopwatch on the NEXYS A7-100t board with a Xilinx ARTIX-7 FPGA. It counts up from zero or counts down, either from a hard-coded time or a time programmed by the user. The user can adjust the countdown time, reset the stopwatch,.  using switches and buttons on the board


Submission contents (see discussion for more details on functionality):
 **Zip file containing the following Verilog files:
 --> Design source code files:
	- moore_FSM.v 			// corrected Moore machine for problem 1
	- mealy_FSM.v			// Mealy machine for problem 2
	- RCA_Nbit.v			// uses generate logic to produce an N-bit ripple carry adder
	- RCA_Nbit_verification.v	// verification logic for N-bit ripple carry adder generation
	- hamming_memory.v		// implementation of Hamming code for problem 4
	- debounced_moore_FSM.v		// modified Moore FSM used in problem 5
	- debouncer.v			// debouncer module used in problem 5. See code attributions

--> Simulation source code files:
	- tb_moore_FSM.v		// used to test Moore machine in problem 1
	- tb_mealy_FSM.v		// used to test Mealy machine in problem 2
	- tb_RCA_Nbit.v			// used to test adder generation and verification logic in problem 3
	- tb_debounced_Moore_fsm.v	// used to test debounced Moore machine in problem 5
	
	Note: we are not submitting the Hamming memory testbench, as this was provided by the instructors and was not modified in this lab.

Code attributions:
--> Code for debouncer was obtained from TF Fadi Kidess.

Discussion:

--> Our code for problems 1-4 functioned correctly in simulation. 

--> The modified Moore machine for problem 5 worked in simulation, but it was not successfully pushed to the board. We suspected that the clock frequency in the debouncer was the issue, but we did not find the right value to make it work.

--> We also wish to discuss our interpretation of the instructions in Problem 4. The instructions specified that "if the corrupted bit is a data bit, you should flip it before writing it to the output ReadData
register. If the corrupted bit is a parity bit you calculated, then you don’t need to do anything". We took this to mean that errors in parity bits were not to be corrected, so our error correction mechanism sits inside a logic block that only flips the broken bit if that bit is not a parity bit.
 full_adder.v
