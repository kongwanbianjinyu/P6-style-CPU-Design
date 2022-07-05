/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`ifndef __SYS_DEFS_VH__
`define __SYS_DEFS_VH__

/* Synthesis testing definition, used in DUT module instantiation */

`ifdef  SYNTH_TEST
`define DUT(mod) mod``_svsim
`else
`define DUT(mod) mod
`endif

//////////////////////////////////////////////
//
//testbench attribute definitions
//
//////////////////////////////////////////////
`define CACHE_MODE //removes the byte-level interface from the memory mode, DO NOT MODIFY!
`define NUM_MEM_TAGS           15

`define MEM_SIZE_IN_BYTES      (64*1024)
`define MEM_64BIT_LINES        (`MEM_SIZE_IN_BYTES/8)

//you can change the clock period to whatever, 10 is just fine
`define VERILOG_CLOCK_PERIOD   10.0
`define SYNTH_CLOCK_PERIOD     10.0 // Clock period for synth and memory latency

//`define MEM_LATENCY_IN_CYCLES (100.0/`SYNTH_CLOCK_PERIOD+0.49999)
`define MEM_LATENCY_IN_CYCLES (2+0.49999)
//`define MEM_LATENCY_IN_CYCLES 0
// the 0.49999 is to force ceiling(100/period).  The default behavior for
// float to integer conversion is rounding to nearest

// `define NUM_LD_MODULE 3
// `define NUM_ST_MODULE 3
// `define NUM_ALU_MODULE 10
//`define NUM_RS `NUM_LD_MODULE + `NUM_ST_MODULE + `NUM_ALU_MODULE
`define NUM_RS 16

typedef union packed {
    logic [7:0][7:0] byte_level;
    logic [3:0][15:0] half_level;
    logic [1:0][31:0] word_level;
} EXAMPLE_CACHE_BLOCK;

typedef union packed {
	logic [63:0] double;
	logic [1:0][31:0] words;
	logic [3:0][15:0] halves;
	logic [7:0][7:0] bytes;
} CACHE_BLOCK;

//////////////////////////////////////////////
// Exception codes
// This mostly follows the RISC-V Privileged spec
// except a few add-ons for our infrastructure
// The majority of them won't be used, but it's
// good to know what they are
//////////////////////////////////////////////

typedef enum logic [3:0] {
	INST_ADDR_MISALIGN  = 4'h0,
	INST_ACCESS_FAULT   = 4'h1,
	ILLEGAL_INST        = 4'h2,
	BREAKPOINT          = 4'h3,
	LOAD_ADDR_MISALIGN  = 4'h4,
	LOAD_ACCESS_FAULT   = 4'h5,
	STORE_ADDR_MISALIGN = 4'h6,
	STORE_ACCESS_FAULT  = 4'h7,
	ECALL_U_MODE        = 4'h8,
	ECALL_S_MODE        = 4'h9,
	NO_ERROR            = 4'ha, //a reserved code that we modified for our purpose
	ECALL_M_MODE        = 4'hb,
	INST_PAGE_FAULT     = 4'hc,
	LOAD_PAGE_FAULT     = 4'hd,
	HALTED_ON_WFI       = 4'he, //another reserved code that we used
	STORE_PAGE_FAULT    = 4'hf
} EXCEPTION_CODE;


//////////////////////////////////////////////
//
// Datapath control signals
//
//////////////////////////////////////////////

//
// ALU opA input mux selects
//
typedef enum logic [1:0] {
	OPA_IS_RS1  = 2'h0,
	OPA_IS_NPC  = 2'h1,
	OPA_IS_PC   = 2'h2,
	OPA_IS_ZERO = 2'h3
} ALU_OPA_SELECT;

//
// ALU opB input mux selects
//
typedef enum logic [3:0] {
	OPB_IS_RS2    = 4'h0,
	OPB_IS_I_IMM  = 4'h1,
	OPB_IS_S_IMM  = 4'h2,
	OPB_IS_B_IMM  = 4'h3,
	OPB_IS_U_IMM  = 4'h4,
	OPB_IS_J_IMM  = 4'h5
} ALU_OPB_SELECT;

//
// Destination register select
//
typedef enum logic [1:0] {
	DEST_RD = 2'h0,
	DEST_NONE  = 2'h1
} DEST_REG_SEL;

//
// ALU function code input
// probably want to leave these alone
//
typedef enum logic [4:0] {
	ALU_ADD     = 5'h00,
	ALU_SUB     = 5'h01,
	ALU_SLT     = 5'h02,
	ALU_SLTU    = 5'h03,
	ALU_AND     = 5'h04,
	ALU_OR      = 5'h05,
	ALU_XOR     = 5'h06,
	ALU_SLL     = 5'h07,
	ALU_SRL     = 5'h08,
	ALU_SRA     = 5'h09,
	ALU_MUL     = 5'h0a,
	ALU_MULH    = 5'h0b,
	ALU_MULHSU  = 5'h0c,
	ALU_MULHU   = 5'h0d,
	ALU_DIV     = 5'h0e,
	ALU_DIVU    = 5'h0f,
	ALU_REM     = 5'h10,
	ALU_REMU    = 5'h11
} ALU_FUNC;

//////////////////////////////////////////////
//
// Assorted things it is not wise to change
//
//////////////////////////////////////////////

//
// actually, you might have to change this if you change VERILOG_CLOCK_PERIOD
// JK you don't ^^^
//
`define SD #1

`define ROB_SIZE 64
// TODO: modify later
`define LSQ_SIZE 16
`define LQ_SIZE 16
`define RRF_SIZE 32
`define MAP_TABLE_SIZE 32
`define CACHE_LINES 32
`define CACHE_LINE_BITS $clog2(`CACHE_LINES)
//`define	BUS_NONE     2'h0
//`define BUS_LOAD     2'h1
//`define BUS_STORE    2'h2


// the RISCV register file zero register, any read of this register always
// returns a zero value, and any write to this register is thrown away
//
`define ZERO_REG 5'd0

//
// Memory bus commands control signals
//
typedef enum logic [1:0] {
	BUS_NONE     = 2'h0,
	BUS_LOAD     = 2'h1,
	BUS_STORE    = 2'h2
} BUS_COMMAND;

// `ifndef CACHE_MODE
typedef enum logic [1:0] {
	BYTE = 2'h0,
	HALF = 2'h1,
	WORD = 2'h2,
	DOUBLE = 2'h3
} MEM_SIZE;
// `endif
//
// useful boolean single-bit definitions
//
`define FALSE  1'h0
`define TRUE  1'h1

// RISCV ISA SPEC
`define XLEN 32
typedef union packed {
	logic [31:0] inst;
	struct packed {
		logic [6:0] funct7;
		logic [4:0] rs2;
		logic [4:0] rs1;
		logic [2:0] funct3;
		logic [4:0] rd;
		logic [6:0] opcode;
	} r; //register to register instructions
	struct packed {
		logic [11:0] imm;
		logic [4:0]  rs1; //base
		logic [2:0]  funct3;
		logic [4:0]  rd;  //dest
		logic [6:0]  opcode;
	} i; //immediate or load instructions
	struct packed {
		logic [6:0] off; //offset[11:5] for calculating address
		logic [4:0] rs2; //source
		logic [4:0] rs1; //base
		logic [2:0] funct3;
		logic [4:0] set; //offset[4:0] for calculating address
		logic [6:0] opcode;
	} s; //store instructions
	struct packed {
		logic       of; //offset[12]
		logic [5:0] s;   //offset[10:5]
		logic [4:0] rs2;//source 2
		logic [4:0] rs1;//source 1
		logic [2:0] funct3;
		logic [3:0] et; //offset[4:1]
		logic       f;  //offset[11]
		logic [6:0] opcode;
	} b; //branch instructions
	struct packed {
		logic [19:0] imm;
		logic [4:0]  rd;
		logic [6:0]  opcode;
	} u; //upper immediate instructions
	struct packed {
		logic       of; //offset[20]
		logic [9:0] et; //offset[10:1]
		logic       s;  //offset[11]
		logic [7:0] f;	//offset[19:12]
		logic [4:0] rd; //dest
		logic [6:0] opcode;
	} j;  //jump instructions
`ifdef ATOMIC_EXT
	struct packed {
		logic [4:0] funct5;
		logic       aq;
		logic       rl;
		logic [4:0] rs2;
		logic [4:0] rs1;
		logic [2:0] funct3;
		logic [4:0] rd;
		logic [6:0] opcode;
	} a; //atomic instructions
`endif
`ifdef SYSTEM_EXT
	struct packed {
		logic [11:0] csr;
		logic [4:0]  rs1;
		logic [2:0]  funct3;
		logic [4:0]  rd;
		logic [6:0]  opcode;
	} sys; //system call instructions
`endif

} INST; //instruction typedef, this should cover all types of instructions

//
// Basic NOP instruction.  Allows pipline registers to clearly be reset with
// an instruction that does nothing instead of Zero which is really an ADDI x0, x0, 0
//
`define NOP 32'h00000013

//////////////////////////////////////////////
//
// IF Packets:
// Data that is exchanged between the IF and the ID stages
//
//////////////////////////////////////////////

typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    INST  inst;  // fetched instruction out
	logic [`XLEN-1:0] NPC; // PC + 4
	logic [`XLEN-1:0] PC;  // PC
} IF_ID_PACKET;

//////////////////////////////////////////////
//
// ID Packets:
// Data that is exchanged from ID to EX stage
//
//////////////////////////////////////////////

typedef struct packed {
	INST  inst;                 // instruction (eg RS opcode)
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

	logic [$clog2(`RRF_SIZE):0]        source_reg_idx_in_1 ; // source reg rs1 //ID to MapTable,[2:0] when used
    logic [$clog2(`RRF_SIZE):0]        source_reg_idx_in_2 ; // source reg rs2 //ID to MapTable,[2:0] when used
	logic [4:0]                          dest_reg_idx;  // destination (writeback) register index  //ID to ROB,MapTable, make [2:0] when used

	logic [`XLEN-1:0] rs1_value;
	logic [`XLEN-1:0] rs2_value;

	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)//output to Issue or EX?
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)//

	//logic                               dispatch_en;   // ID to ROB,MapTable,RS

	//logic [1:0]                         rob_dispatch_num;//dispatch insn number : {0,1,2,3} //ID to MapTable

	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
} ID_IP_PACKET;

typedef struct packed {
	logic [$clog2(`NUM_RS):0]		RS_tag; 	// insn's RS tag 0-15
	logic [$clog2(`ROB_SIZE):0]     rob_tag;    // insn's rob tag


	// logic [31:0]             	OPA;
	// logic [31:0]            		OPB;
	logic [`XLEN-1:0]				rs1_value;
	logic [`XLEN-1:0]				rs2_value;

	ALU_OPA_SELECT					opa_select;
	ALU_OPB_SELECT					opb_select;
	INST inst;

	ALU_FUNC    					alu_func;         // ALU function select (ALU_xxx *)
	logic       					cond_branch;   // is inst a conditional branch?
	logic       					uncond_branch; // is inst an unconditional branch?
	//INST 							inst;          // instruction
	logic       					halt;          // is this a halt?
	logic 							issue_valid;   // whether the packet is valid
	logic [`XLEN-1:0] 				NPC;
	logic [`XLEN-1:0]				PC;

	// For LSQ
	//logic [$clog2(`SQ_SIZE):0]    	load_pos;
    //logic [$clog2(`LQ_SIZE):0]    	store_pos;
	logic 							rd_mem;
	logic 							wr_mem;
} IS_EX_PACKET;

typedef struct packed {
	logic [`XLEN-1:0] 				NPC;
	INST							inst;
	logic       					halt;          // is this a halt?
	logic [$clog2(`ROB_SIZE):0]     rob_tag;    // insn's rob tag
	logic [`XLEN-1:0] 				alu_result; // alu_result
	logic             				take_branch; // is this a taken branch?
	logic 							exe_valid;// whether the packet is valid

	// For LSQ
	logic [`XLEN-1:0]				rs2_value;
	//logic [$clog2(`SQ_SIZE):0]    	load_pos;
    //logic [$clog2(`LQ_SIZE):0]    	store_pos;
	logic 							rd_mem;
	logic 							wr_mem;
} EX_IC_PACKET;

typedef enum {LD,ST,ALU} FU;

typedef struct packed{
	logic [$clog2(`NUM_RS):0]		RS_tag;
    logic                           already_issue;
    logic                           busy;   // whether FU busy
    logic [$clog2(`ROB_SIZE):0]   T;      // insn's rob tag
    logic [$clog2(`ROB_SIZE):0]   T1;     // rs1,rs2 tags
    logic [$clog2(`ROB_SIZE):0]   T2;
    logic [`XLEN-1:0]                    V1;     // rs1, rs2 values
    logic [`XLEN-1:0]                    V2;
	ALU_OPA_SELECT					opa_select;
	ALU_OPB_SELECT					opb_select;
	ALU_FUNC    					alu_func;   // ALU function select (ALU_xxx *)
	logic       					cond_branch;   // is inst a conditional branch?
	logic       					uncond_branch; // is inst an unconditional branch?
	INST 							inst;      // instruction
	logic       					halt;          // is this a halt?
    //logic [$clog2(`SQ_SIZE):0]     load_pos;
    //logic [$clog2(`LQ_SIZE):0]     store_pos;
	logic 							rd_mem;
	logic 							wr_mem;
	logic [`XLEN-1:0] 	            NPC;
	logic [`XLEN-1:0]				PC;
} RS_ENTRY;


typedef struct packed{
    // Dispatch stage output
    logic [31:0]               dispatch_value_out_1;   // value output to RS if map table ready
    logic [31:0]               dispatch_value_out_2;
    //logic [1:0] 					dispatch_num;              // dispatch # for maptable
    logic [$clog2(`ROB_SIZE):0] 	assigned_rob_tag ;

	// complete stage
	logic [4:0]				complete_reg_idx_out;

    // retire stage output
    logic [4:0]             retire_R_out;
    logic [31:0]            retire_V_out;
	logic [$clog2(`ROB_SIZE):0] 			retire_rob_tag_out;
	logic 									retire_valid;
	logic 								halt;

    //logic                        	clear_all; // when exception happens, clear all ROB/RS/Map_Table
	//for test
	INST 				inst;
	logic [`XLEN-1:0] 	NPC;
} ROB_PACKET;

typedef struct packed{
    logic 				exception;
    logic 				complete;
    logic [4:0] 		reg_idx; 		//R
    logic [31:0] 		reg_val; //V
    INST 				inst;
	logic       		halt;          // is this a halt?
	logic [`XLEN-1:0] 	NPC;
	logic 				valid;
	logic [`XLEN-1:0] alu_result;
} ROB_ENTRY;

typedef struct packed{
	logic [$clog2(`ROB_SIZE):0] 	rob_tag;
	logic 							ready;
} MT_ENTRY;

typedef struct packed{
	MT_ENTRY 	mt_entry_1;
	MT_ENTRY 	mt_entry_2;
} MT_PACKET;

typedef struct packed{
	RS_ENTRY 	rs_entry;
	logic 		valid; // rs_entry have been issued in, valid is 1
} RS_PACKET; // RS issue out

typedef struct packed{
	logic [1:0] l_or_s; //10 is l, 01 is s
	logic 		ready_to_dcache; // different condition for L/S
	logic 		data_ready; // different condition for L/S
	logic [`XLEN-1:0] addr;
	logic [`XLEN-1:0] value;
	logic [$clog2(`ROB_SIZE):0] rob_tag;
	logic complete;
	logic [2:0]   mem_size; // byte, half-word or word
} LSQ_ENTRY;

typedef enum logic [2:0]{
	IN_CACHE,
	IN_MEM,
	DIRTY,
	COMMIT
} CACHE_STATE;


`endif // __SYS_DEFS_VH__
