# make          <- runs simv (after compiling simv if needed)
# make all      <- runs simv (after compiling simv if needed)
# make simv     <- compile simv if needed (but do not run)
# make syn      <- runs syn_simv (after synthesizing if needed then
#                                 compiling synsimv if needed)
# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be
# similar to the information in those scripts but that seems hard to avoid.
#
#

#SOURCE = test_progs/rv32_mult_no_lsq.s
#SOURCE = test_progs/haha.s
SOURCE = test_progs/rv32_copy.s
#SOURCE = test_progs/rv32_mult.s
#SOURCE = test_progs/rv32_copy_long.s
#SOURCE = test_progs/rv32_evens.s
#SOURCE = test_progs/rv32_evens_long.s

CRT = crt.s
LINKERS = linker.lds
ASLINKERS = aslinker.lds

DEBUG_FLAG = -g
CFLAGS =  -mno-relax -march=rv32im -mabi=ilp32 -nostartfiles -std=gnu11 -mstrict-align -mno-div
OFLAGS = -O0
ASFLAGS = -mno-relax -march=rv32im -mabi=ilp32 -nostartfiles -Wno-main -mstrict-align
OBJFLAGS = -SD -M no-aliases
OBJDFLAGS = -SD -M numeric,no-aliases

##########################################################################
# IF YOU AREN'T USING A CAEN MACHINE, CHANGE THIS TO FALSE OR OVERRIDE IT
CAEN = 1
##########################################################################
ifeq (1, $(CAEN))
	GCC = riscv gcc
	OBJDUMP = riscv objdump
	AS = riscv as
	ELF2HEX = riscv elf2hex
else
	GCC = riscv64-unknown-elf-gcc
	OBJDUMP = riscv64-unknown-elf-objdump
	AS = riscv64-unknown-elf-as
	ELF2HEX = elf2hex
endif

#VCS = SW_VCS=2017.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 -cm line+tgl

VCS = vcs -V -sverilog +vc -Mupdate -line -full64 +vcs+vcdpluson -debug_acc+pp+dmptf -debug_region+cell+encrypt#-debug_pp#
LIB = /afs/umich.edu/class/eecs470/lib/verilog/lec25dscc25.v

# For visual debugger
VISFLAGS = -lncurses

# SIMULATION CONFIG

HEADERS     = $(wildcard *.svh)
TESTBENCH   = $(wildcard testbench/*.sv)
TESTBENCH  += $(wildcard testbench/*.c)
PIPEFILES   = $(wildcard Pipeline/*.sv)
PIPEFILES  += $(wildcard ROB/*.sv)
PIPEFILES  += $(wildcard RS/*.sv)
PIPEFILES  += $(wildcard MapTable/*.sv)
PIPEFILES  += $(wildcard psel_gen/*.v)
PIPEFILES  += $(wildcard num_ones/*.sv)
PIPEFILES  += $(wildcard Mult/*.v)
PIPEFILES  += $(wildcard LSQ/*.sv)
PIPEFILES  += $(wildcard Cache/*.sv)


SIMFILES    = $(PIPEFILES)

VTUBER = sys_defs.svh	\
		ISA.svh         \
		testbench/mem.sv  \
		testbench/visual_testbench.v \
		testbench/visual_c_hooks.cpp \
		testbench/pipe_print.c

# SYNTHESIS CONFIG
SYNTH_DIR = ./synth
	
export HEADERS
export PIPEFILES

export PIPELINE_NAME = pipeline

PIPELINE  = $(SYNTH_DIR)/$(PIPELINE_NAME).vg
SYNFILES  = $(PIPELINE) $(SYNTH_DIR)/$(PIPELINE_NAME)_svsim.sv

# Passed through to .tcl scripts:
export CLOCK_NET_NAME = clock
export RESET_NET_NAME = reset
export CLOCK_PERIOD   = 10	# TODO: You will need to make match SYNTH_CLOCK_PERIOD in sys_defs
                                #       and make this more aggressive

################################################################################
## RULES
################################################################################

# Default target:
all:    simv
	./simv | tee program.out

.PHONY: all

# Simulation:

sim:	simv
	./simv | tee sim_program.out

simv:	$(HEADERS) $(SIMFILES) $(TESTBENCH)
	$(VCS) $^ -o simv

.PHONY: sim

# Programs

compile: $(CRT) $(LINKERS)
	$(GCC) $(CFLAGS) $(OFLAGS) $(CRT) $(SOURCE) -T $(LINKERS) -o program.elf
	$(GCC) $(CFLAGS) $(DEBUG_FLAG) $(CRT) $(SOURCE) -T $(LINKERS) -o program.debug.elf
assemble: $(ASLINKERS)
	$(GCC) $(ASFLAGS) $(SOURCE) -T $(ASLINKERS) -o program.elf
	cp program.elf program.debug.elf
disassemble: program.debug.elf
	$(OBJDUMP) $(OBJFLAGS) program.debug.elf > program.dump
	$(OBJDUMP) $(OBJDFLAGS) program.debug.elf > program.debug.dump
	rm program.debug.elf
hex: program.elf
	$(ELF2HEX) 8 8192 program.elf > program.mem

program: compile disassemble hex
	@:

debug_program:
	gcc -lm -g -std=gnu11 -DDEBUG $(SOURCE) -o debug_bin
assembly: assemble disassemble hex
	@:



# For visual debugger
vis_simv:	$(SIMFILES) $(VTUBER)
			$(VCS) $(VISFLAGS) $(VTUBER) $(SIMFILES) -o vis_simv 
			./vis_simv
# Synthesis

$(PIPELINE): $(SIMFILES) $(SYNTH_DIR)/$(PIPELINE_NAME).tcl
	cd $(SYNTH_DIR) && dc_shell-t -f ./$(PIPELINE_NAME).tcl | tee $(PIPELINE_NAME)_synth.out
	echo -e -n 'H\n1\ni\n`timescale 1ns/100ps\n.\nw\nq\n' | ed $(PIPELINE)

syn:	syn_simv
	./syn_simv | tee syn_program.out

syn_simv:	$(HEADERS) $(SYNFILES) $(TESTBENCH)
	$(VCS) $^ $(LIB) +define+SYNTH_TEST -o syn_simv

.PHONY: syn

# Debugging

dve:	sim
	./simv -gui &

dve_syn: syn_sim
	./syn_simv -gui &

.PHONY: dve dve_syn

clean:
	rm -rf *simv *simv.daidir csrc vcs.key program.out *.key
	rm -rf vis_simv vis_simv.daidir
	rm -rf dve* inter.vpd DVEfiles
	rm -rf syn_simv syn_simv.daidir syn_program.out
	rm -rf synsimv synsimv.daidir csrc vcdplus.vpd vcs.key synprog.out pipeline.out writeback.out vc_hdrs.h
	rm -f *.elf *.dump *.mem debug_bin

nuke:	clean
	rm -rf synth/*.vg synth/*.rep synth/*.ddc synth/*.chk synth/*.log synth/*.syn
	rm -rf synth/*.out command.log synth/*.db synth/*.svf synth/*.mr synth/*.pvl