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

`timescale 1ns/100ps

module Dcache(
    input   clk,
    input   reset,
    // inputs from memory
    input   [3:0] Dmem2proc_response,
    input  [63:0] Dmem2proc_data,
    input   [3:0] Dmem2proc_tag,
    // input  read_valid,
    // inputs from proc
    input BUS_COMMAND proc2Dcache_command,
    input      [`XLEN-1:0] proc2Dcache_data,
    input      [`XLEN-1:0] proc2Dcache_addr,
    input       MEM_SIZE mem_size,
    //input    MEM_SDZE proc2Dcache_size,
    // outputs to memory
    output BUS_COMMAND proc2Dmem_command,
    output logic [`XLEN-1:0] proc2Dmem_addr,
    output logic [63:0] proc2Dmem_data,
    //output     MEM_SDZE proc2Dmem_size,
    // outputs to proc
    output logic [`XLEN-1:0] Dcache_data_out, // value is memory[proc2Dcache_addr]
    output logic        Dcache_valid_out      // when this is high
    );


    logic [`CACHE_LINE_BITS - 2:0] current_index, last_index;
    logic [12 - `CACHE_LINE_BITS:0] current_tag, last_tag;
    logic [`XLEN - 1:0] last_data;
    BUS_COMMAND last_command;

    logic command_accept;
    logic update_mem_tag;
    logic next_inst;
    // logic unanswered_miss;

    logic [3:0] current_mem_tag, next_mem_tag;
    // logic miss_outstanding;
    logic hit;


    //Cache memory
    logic write_commit, next_write_commit;
    logic load_commit, next_load_commit;
    logic send_command, next_send_command;
    logic update_state;
    CACHE_STATE next_state_i;
    CACHE_BLOCK [31:0] data;
    CACHE_STATE [`CACHE_LINES-1:0] curr_state;
    logic [`CACHE_LINES-1:0] [12 - `CACHE_LINE_BITS:0]  tags;
    logic [`CACHE_LINES-1:0]                            valids;

    always_comb begin
        {current_tag, current_index} = proc2Dcache_addr[`CACHE_LINES - 1:3];
        proc2Dmem_addr = {proc2Dcache_addr[`XLEN - 1:3],3'b0};
        command_accept = (current_mem_tag == Dmem2proc_tag) && (current_mem_tag != 0);
        hit =  current_tag == tags[current_index] && valids[current_index];
        Dcache_data_out = proc2Dcache_addr[2] == 0 ? data[current_index][31:0] : data[current_index][63:32];

        update_mem_tag = 0;
        Dcache_valid_out = 0;
        update_state = 0;


        proc2Dmem_command = BUS_NONE;
        next_state_i = IN_MEM;
        proc2Dmem_data = data[current_index];

        next_inst = current_index != last_index || current_tag != last_tag || proc2Dcache_command != last_command || (proc2Dcache_command == BUS_STORE && proc2Dcache_data != last_data);

        if(next_inst) begin
            next_write_commit = 0;
            next_load_commit = 0;
            next_send_command = 0;
        end
        else begin
            next_send_command = send_command;
            next_write_commit = write_commit;
            next_load_commit = load_commit;
        end

        if(!next_inst) begin
            if(hit && curr_state[current_index] == IN_CACHE) begin
                if(proc2Dcache_command != BUS_STORE  || (proc2Dcache_command == BUS_STORE && write_commit)) begin
                    proc2Dmem_command = BUS_NONE;
                    Dcache_valid_out = 1;
                end else begin
                    if(proc2Dcache_command == BUS_STORE) begin
                        if(!hit) begin
                            update_state = 1;
                            next_state_i = IN_MEM;
                            update_mem_tag = 1;
                            next_mem_tag = 0;
                        end else begin
                            update_state = 1;
                            next_state_i = DIRTY;
                            update_mem_tag = 1;
                            next_mem_tag = 0;
                        end
                    end
                end
            end else if(curr_state[current_index] == DIRTY && proc2Dcache_command == BUS_STORE) begin
                update_mem_tag = 1;
                next_mem_tag = 0;
                update_state = 1;
                next_state_i = COMMIT;
            end else if(curr_state[current_index] == COMMIT && proc2Dcache_command == BUS_STORE) begin
                proc2Dmem_command = BUS_STORE;
                if(Dmem2proc_response != 0) begin
                    // Dcache_valid_out = 1;
                    update_state = 1;
                    next_state_i = IN_CACHE;
                    next_write_commit = 1;
                    update_mem_tag = 1;
                    next_mem_tag = 0;
                end
            end else if(!hit || curr_state[current_index] == IN_MEM) begin
                if(proc2Dcache_command != BUS_NONE) begin
                    if(!send_command) begin
                        proc2Dmem_command = BUS_LOAD;
                        if(Dmem2proc_response != 0) begin
                            update_mem_tag = 1;
                            next_mem_tag = Dmem2proc_response;
                            update_state = 1;
                            next_state_i = IN_MEM;
                            next_send_command = 1;
                        end
                    end else if(command_accept) begin
                        update_mem_tag = 1;
                        next_mem_tag = 0;
                        proc2Dmem_command = BUS_NONE;
                        next_load_commit = 1;
                    end else if(load_commit) begin
                        update_state = 1;
                        if(proc2Dcache_command == BUS_LOAD) begin
                            next_state_i = IN_CACHE;
                        end else begin
                            next_state_i = DIRTY;
                        end
                    end
                end
            end
        end
    end

    // synopsys sync_set_reset "reset"
    always_ff @(posedge clk) begin
        if(reset) begin
            last_command <= `SD BUS_NONE;
            last_data <= `SD 0;
            last_index <= `SD -1;
            last_tag <= `SD -1;
            current_mem_tag  <= `SD 0;
            // miss_outstanding <= `SD 0;
            load_commit <= `SD 0;
            write_commit <= `SD 0;
            valids <= `SD 31'b0;
            send_command <= `SD 0;
            for(int i = 0; i < `CACHE_LINES; i ++) begin
                curr_state[i] <= `SD IN_MEM;
            end
        end else begin
            // miss_outstanding        <= `SD unanswered_miss;
            last_index <= `SD current_index;
            last_tag <= `SD current_tag;
            last_data <= `SD proc2Dcache_data;
            last_command <= `SD proc2Dcache_command;
            write_commit <= `SD next_write_commit;
            load_commit <= `SD next_load_commit;
            send_command <= `SD next_send_command;

            if(update_mem_tag)
                current_mem_tag     <= `SD next_mem_tag;
            if(update_state)
                curr_state[current_index] <= `SD next_state_i;


            if(curr_state[current_index] == DIRTY) begin
                case (mem_size)
                    BYTE: begin
                        data[current_index].bytes[proc2Dcache_addr[2:0]] <= `SD proc2Dcache_data[7:0];
                    end
                    HALF: begin
                        assert(proc2Dcache_addr[0] == 0);
                        data[current_index].halves[proc2Dcache_addr[2:1]] <= `SD proc2Dcache_data[15:0];
                    end
                    WORD: begin
                        assert(proc2Dcache_addr[1:0] == 0);
                        data[current_index].words[proc2Dcache_addr[2]] <= `SD proc2Dcache_data[31:0];
                    end
                    default: begin
                        assert(proc2Dcache_addr[1:0] == 0);
                        data[current_index].words[proc2Dcache_addr[2]] <= `SD proc2Dcache_data[31:0];
                    end
                endcase
                tags[current_index] <= `SD current_tag;
                valids[current_index] <= `SD 1;
            end else if(command_accept && curr_state[current_index] == IN_MEM) begin
                    data[current_index]     <= `SD Dmem2proc_data;
                    tags[current_index]     <= `SD current_tag;
                    valids[current_index] <= `SD 1;
                end
        end
    end

endmodule