///////////////////////////////////////////////////////////////////////
//                                                                   //
//   Modulename :  Dcache.v                                          //
//                                                                   //
//  Description :  Data Cache of the P6 architecture;                //
//                 Write-through Write-allocate,                     //
//                 blocking, directly mapped Dcahce                  //
//                 block size = 8 bytes, 32 entries                  //
//                                                                   //
///////////////////////////////////////////////////////////////////////

//`define CACHE_LINES 32
//`define CACHE_LINE_BITS $clog2(`CACHE_LINES)

`timescale 1ns/100ps

module Dcache(
    input   clock,
    input   reset,
    // inputs from memory
    input   [3:0] Dmem2proc_response,
    input  [63:0] Dmem2proc_data,
    input   [3:0] Dmem2proc_tag,
    // inputs from proc
    input BUS_COMMAND proc2Dcache_command,
    input      [63:0] proc2Dcache_data,
    input      [`XLEN-1:0] proc2Dcache_addr,
    input       MEM_SIZE mem_size,
    //input    MEM_SIZE proc2Dcache_size,
    // outputs to memory
    output BUS_COMMAND proc2Dmem_command,
    output logic [`XLEN-1:0] proc2Dmem_addr,
    output logic [63:0] proc2Dmem_data,
    //output     MEM_SIZE proc2Dmem_size,
    // outputs to proc
    output logic [`XLEN-1:0] Dcache_data_out, // value is memory[proc2Dcache_addr]
    output logic        Dcache_valid_out      // when this is high
    );

    logic [`CACHE_LINE_BITS - 1:0] current_index, last_index;
    logic [28 - `CACHE_LINE_BITS:0] current_tag, last_tag;

    assign {current_tag, current_index} = proc2Dcache_addr[31:3];

    logic data_write_enable;
    logic changed_addr;
    logic update_mem_tag;
    logic unanswered_miss;
    logic write_miss; // high when write miss
    // logic [63:0] write_miss_data;
    // logic `MEM_SIZE write_mem_size;
    logic write_block_allocated; //high when the block we want to write is loaded from memory and allocated to cache
    logic [`CACHE_LINE_BITS - 1:0] write_miss_index;
    logic store_en;
    logic data_overwrited;
    
    logic [3:0] current_mem_tag;
    logic miss_outstanding;

    logic write_hit; // high when writing to dcache and hit

    //Cache
    CACHE_BLOCK [31:0] data;
    logic [31:0] [28 - `CACHE_LINE_BITS:0]  tags;
    logic [31:0]                            valids;

    assign proc2Dmem_addr = {proc2Dcache_addr[`XLEN-1:3],3'b0};
    assign Dcache_data_out = proc2Dcache_addr[2] == 0 ? data[current_index][31:0] : data[current_index][63:32];
    assign Dcache_valid_out = valids[current_index] && (tags[current_index] == current_tag);
    assign write_hit = (proc2Dcache_command == BUS_STORE) && (valids[current_index]) && (tags[current_index] == current_tag);
    assign data_block = Dmem2proc_data;

    always_comb begin
        if(write_hit) begin
            proc2Dmem_command = proc2Dcache_command;
            proc2Dmem_data = proc2Dcache_data;
        end else begin
            data_write_enable = (current_mem_tag == Dmem2proc_tag) && (current_mem_tag != 0);
            changed_addr      = (current_index != last_index) || (current_tag != last_tag);
            update_mem_tag    = changed_addr || miss_outstanding || data_write_enable;
            unanswered_miss   = changed_addr ? !Dcache_valid_out :
                                        miss_outstanding && (Dmem2proc_response == 0);
            write_miss = (proc2Dcache_command == BUS_STORE) && (!write_block_allocated);
            // if(proc2Dcache_command == BUS_STORE) begin
            //     write_miss_data = proc2Dcache_data;
            //     write_miss_index = current_index;
            //     write_mem_size = mem_size;
            // end else begin
                //write_miss = 0;
                // write_miss_data = 0; // ? why it's not write_miss_index = 0 ?
            // end
            store_en = write_block_allocated ? 1 : 0;
            // TODO: need to modify, when can we send the overwrited block to memory?
            if(data_overwrited) begin
                // proc2Dmem_data = data[write_miss_index];
                proc2Dmem_data = data[current_index];
            end
            proc2Dmem_command = data_overwrited ? BUS_STORE :
                                        (miss_outstanding && !changed_addr) ?  BUS_LOAD : BUS_NONE;
        end
    end

    // synopsys sync_set_reset "reset"
    always_ff @(posedge clock) begin
         if(reset) begin
            last_index       <= `SD -1;   // These are -1 to get ball rolling when // ? what does this mean
            last_tag         <= `SD -1;   // reset goes low because addr "changes"
            current_mem_tag  <= `SD 0;
            miss_outstanding <= `SD 0;
            write_block_allocated <= `SD 0;
            data_overwrited       <= `SD 0;
            valids <= `SD 0;
        end else begin
            last_index              <= `SD current_index;
            last_tag                <= `SD current_tag;
            miss_outstanding        <= `SD unanswered_miss;

            if(update_mem_tag)
                current_mem_tag     <= `SD Dmem2proc_response;

            if(data_write_enable) begin
                data[current_index]     <= `SD Dmem2proc_data;
                tags[current_index]     <= `SD current_tag;
                valids[current_index]   <= `SD 1;
                if(write_miss) begin
                    write_block_allocated   <= `SD 1;
                    valids[current_index]   <= `SD 0;
                end
            end

            if(write_hit) begin
                data[current_index]     <= `SD proc2Dcache_data;
                valids[current_index]   <= `SD 1;
            end

            if(store_en) begin
                case (mem_size)
                    BYTE: begin
                        data[current_index].bytes[proc2Dmem_addr[2:0]] <= `SD proc2Dmem_data[7:0];
                    end
                    HALF: begin
                        assert(proc2Dmem_addr[0] == 0);
                        data[current_index].halves[proc2Dmem_addr[2:1]] <= `SD proc2Dmem_data[15:0];
                    end
                    WORD: begin
                        assert(proc2Dmem_addr[1:0] == 0);
                        data[current_index].words[proc2Dmem_addr[2]] <= `SD proc2Dmem_data[31:0];
                    end
                    default: begin
                        assert(proc2Dmem_addr[1:0] == 0);
                        data[current_index].words[proc2Dmem_addr[2]] <= `SD proc2Dmem_data[31:0];
                    end
                endcase
                // data[write_miss_index]   <= `SD write_miss_data;
                valids[current_index] <= `SD 1;
                write_block_allocated    <= `SD 0;
                data_overwrited          <= `SD 1;
            end else begin
                data_overwrited          <= `SD 0;
            end

        end
    end


endmodule