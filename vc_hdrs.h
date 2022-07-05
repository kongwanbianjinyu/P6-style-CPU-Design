#ifndef _VC_HDRS_H
#define _VC_HDRS_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <dlfcn.h>
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
extern long long int GetLLIresult();
extern void StoreLLIresult(const unsigned int* data);
typedef struct VeriC_Descriptor *vc_handle;

#ifndef SV_3_COMPATIBILITY
#define SV_STRING const char*
#else
#define SV_STRING char*
#endif

#endif /* _VC_TYPES_ */


 extern void print_header(/* INPUT */const char* str);

 extern void print_cycles();

 extern void print_close();

 extern void print_change_line();

 extern void print_stage(/* INPUT */const char* div, /* INPUT */int inst, /* INPUT */int npc, /* INPUT */int valid_inst);

 extern void print_reg(/* INPUT */int wb_reg_wr_data_out_hi, /* INPUT */int wb_reg_wr_data_out_lo, /* INPUT */int wb_reg_wr_idx_out, /* INPUT */int wb_reg_wr_en_out);

 extern void print_membus(/* INPUT */int proc2mem_command, /* INPUT */int mem2proc_response, /* INPUT */int proc2mem_addr_hi, /* INPUT */int proc2mem_addr_lo, /* INPUT */int proc2mem_data_hi, /* INPUT */int proc2mem_data_lo);

#ifdef __cplusplus
}
#endif


#endif //#ifndef _VC_HDRS_H

