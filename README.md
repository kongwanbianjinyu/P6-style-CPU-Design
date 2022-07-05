# README #


## A 3-way superscalar Out-of-Order Processor with P6 style register renaming. ##

### Introduction ###

This is the project of a 3-way out-of-order RSIC-V CPU using P6 style register renaming, from Group2 in EECS470 course, University of Michigan, Ann Arbor. In final project, we implemented a P6 style register renaming architecture CPU. It works as a 3-way out-of-order superscalar machine and all the other features of it will be described in detail as follows. 

### Design Overview ###
All the modules we implemented are as listed in the flowchart. In fetch stage, we can fetch at most 3 instructions in order. But the fetch number would be less than 3 due to data dependence between the instructions and structure hazard of ROB(Reorder-Buffer), RS(Reservation Station) or CDB.

In the dispatch stage, The decoder would decode the information of the instruction and read the register value from register file. Then it would put them in ROB and RS, record the rob_tag in map table. RS would use a MUX to choose T1/T2 and V1/V2 from other place in pipeline or RRF.

In the issue stage, instructions in RS with zero T1/T2 would request to issue. If more than 3 instructions request, we would use 16-to-3 priority selector to choose which one can go to pipeline register.

In the execute stage, we have 3 ALUs with 1 cycle latency and 3 8-stage multiplier. If more than 3 insns complete at one cycle, a priority selector would choose 3 results to EX/IC pipeline register. For those haven’t been chosen, we would stall the whole pipeline and wait for them.

In the complete stage, load/store instructions would go to the in-order LSQ（Load Store Queue) and wait for the valid data from d-cache. The head of the LSQ would go to CDB and broadcast the rob_tag and value in all modules.

In the retire stage, the head of the rob would be written into register file. If exception bit detected, all pipeline register and module would be cleared.

### Run ###
To run the code, open the terminal in the folder and run:
```
./run.sh
```
Then the processor would run all assembly files and put all output result in the ./Outputs folder.

### Check Output Result ###
* ./Outputs/program_name.program.out
* ./Outputs/program_name.cpi.out
* ./Outputs/program_name.pipeline.out
* ./Outputs/program_name.program.out



### Who do I talk to? ###

* Jiachen Jiang jiachenj@umich.edu
