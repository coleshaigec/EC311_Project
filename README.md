Project Title: The Time Machine  

Names: Cole Shaigec, Alex Melnick, Henry Bega, Macy Bryer-Charette  
TF name: Shiva Raja  

GitHub Repository Link: https://github.com/coleshaigec/EC311_Project/  
Demonstration Video Link: https://youtu.be/bVh82Ra8iLs  


PROJECT OVERVIEW
	 
We have constructed a multifunctional programmable stopwatch on the NEXYS A7-100t board with a Xilinx ARTIX-7 FPGA. It counts up from zero or counts down, either from a hard-coded time or a time programmed by the user. The stopwatch time is displayed on the 7-segment display attached to the FPGA board. The user can adjust the countdown time, reset the stopwatch, and start and stop the time using switches and buttons on the board. The stopwatch has a built-in leaderboard that stores the three smallest times in the count up mode and the three largest times in the count down mode. The 7-segment display can be toggled using switches on the board to display either the stopwatch time count or a user-chosen position on the leaderboard. Additionally, the design includes a sound module that can output sounds when leaderboard milestones are reached or when the countdown timer reaches zero. 

HOW TO RUN THIS PROJECT  

This project can be run using using the XILINX Vivado software package through the module 'top.v'. Setting this as the top-level design source and setting 'tb_top.v' as the top-level simulation source will allow the generation of the simulation waveform for the top-level module, which showcases a broad range of stopwatch design features. The modules 'stopwatch.v' and 'tb_stopwatch.v' can be set as top to undertake a comprehensive simulation of the stopwatch functionality. This design was implemented on the FPGA using the file 'constraints.xdc', though it did not function correctly. See 'Discussion'.

GITHUB REPOSITORY CONTENTS  
	This repository contains the following code files:    
 ==> Design source code files:  
	- beep.v 					// module that produces sound signals  
	- binary_to_BCD.v				// binary to BCD converter used in 7-segment display  
	- button_debounce.v				// debounces signals from FPGA board buttons to generate stable signal pulses for other modules  
	- blinker.v					// verification logic for N-bit ripple carry adder generation  
	- clock_divider.v				// 10ns to 20ns clock divider used in sound module (beep.v)  
 	- D_flip_flop.v					// module implementing a D flip-flop; used in 7-segment display finite state machine  
	- fifty_ms_clock_divider.v			// 10ns to 50ms clock divider used in 7-segment display finite state machine module  
	- leaderboard.v					// module implementing leaderboard logic  
 	- leaderboard_sim.v				// module showcasing the leaderboard for simulation used in demonstration  
 	- one_ms_clock_divider.v			// 10ns to 1ms clock divider used in 7-segment display finite state machine  
  	- seven_seg_decoder.v				// decoder used to produce signals driving anode and cathode of 7-segment display  
   	- seven_seg_fsm.v				// finite state machine used to drive 7-segment display  
    	- stopwatch.v					// module implementing stopwatch finite state machine  
     	- time_conversion.v				// module used to convert 10 nanosecond time signals output from stopwatch into minute/second/millisecond times usable by 7-segment display FSM  
     	- time_MUX.v					// multiplexer used to decide which time should be passed to the 7-segment display (i.e., a leaderboard time or the stopwatch time)  
      	- top.v						// top level module containing instantiations of all other modules in the system  
       	- video_seven_seg_demo.v			// module used to implement 7-segment display on FPGA for demonstration  

==> Simulation source code files:
	- DFF_test.v					// testbench used to verify functionality of D flip-flop module  
 	- binary_to_BCD_test.v				// testbench used to verify functionality of binary-to-BCD converter  
  	- leaderboard_tb.v				// testbench used to verify functionality of leaderboard module  
   	- leaderboard_sim_tb.v				// testbench used to produce simulation waveforms for leaderboard demonstration  
	- one_ms_clock_divider_tester.v 		// testbench used to verify functionality of 10ns to 1ms clock divider  
	- seven_seg_fsm_test.v				// testbench used to verify functionality of 7-segment display finite state machine  
	- tb_stopwatch.v				// testbench used to verify functionality of stopwatch module  
 	- tb_top.v					// testbench used to verify functionality of top-level module  
  	- time_coversion_tb.v				// testbench used to verify functionality of time_conversion module  

==> Constraints files:
 	- constraints.xdc				// constraints file used to implement design on the FPGA  

==> Other files
	- EC 311 Final Project Presentation.pptx	// PowerPoint presentation containing further information about the design  

Code attributions:
==> D_Flip_Flop.v - https://www.fpga4student.com/2017/02/verilog-code-for-d-flip-flop.html  
==> binary_to_BCD.v - https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d  
==> button_debounce.v - FROM https://allaboutfpga.com/vhdl-code-for-debounce-circuit-in-fpga/  

Discussion:

Our design functioned correctly in simulation, and each individual module was successfully implemented on the FPGA. However, implementation of the top-level module on the FPGA was unsuccessful, as we encountered an unforeseen issue with Vivado's synthesis tool that gave rise to a timing violation and caused the 7-segment display to fail. We were unable to troubleshoot this problem even with assistance from the course teaching team. However, correct functionality can be confirmed using the simulation tools provided.

Individual contributions:  
    Alex Melnick  
 	==> built 7-segment display finite state machine and all constituent modules  
  	==> built debouncer modules  
  	==> co-wrote top-level module and constraints file  
   Cole Shaigec  
   	==> built stopwatch module  
    	==> built time_MUX module  
     	==> co-wrote top-level module and constraints file  
   Henry Bega  
	==> built leaderboard module  
 	==> built sound module  
  	==> prepared demonstration video  
   Macy Bryer-Charette  
   	==> built sound module  

