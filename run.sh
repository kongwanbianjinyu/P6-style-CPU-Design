#!/usr/bin/bash
#
# This file will allow automated checking of project 3. It requires that you create a git branch with
# the unmodified project 3 starter code (BASEBRANCH), a branch with your modified code (TESTBRANCH)
# and a directory holding test programs (TESTCASES)
#

export BASEOUTDIR=base_outputs
export TESTOUTDIR=test_outputs
export TESTCASES=test_progs
export BASEBRANCH=master
export TESTBRANCH=improvement
export ASSEMBLY_EXT=s
export PROGRAM_EXT=c

tests=("rv32_fib_rec.s" "rv32_mult_no_lsq.s" "haha.s" "rv32_copy.s" "rv32_mult.s" "rv32_copy_long.s" "rv32_evens.s" "rv32_evens_long.s" "rv32_fib.s" "rv32_fib_long.s" "rv32_insertion.s" "rv32_btest1.s" "rv32_btest2.s" "rv32_parallel.s" "rv32_saxpy.s" "rv32_halt.s" "sampler.s")
#tests=("rv32_fib_rec.s" "rv32_btest1.s" "rv32_btest2.s" "rv32_parallel.s" "rv32_saxpy.s" "rv32_halt.s" "sampler.s")
#tests=("alexnet.c" "backtrack.c" "basic_malloc.c" "bfs.c" "dft.c" "fc_forward.c" "graph.c" "insertionsort.c" "matrix_mult_rec.c" "mergesort.c" "omegalul.c" "outer_product.c" "priority_queue.c" "quicksort.c")

# tests=("alexnet.c")


# function compare_tests{
#     rm -r $TESTOUTDIR
#     mkdir $TESTOUTDIR
#     type="assembly"
#     extension="s"
#     for test in $tests; do
#         testpath = $TESTCASES/$test
#         # testname=${testname##${TESTCASES}\/}
#         testname=${test%%.${extension}}
#         echo "$0: Test: $test"
#         make $type SOURCE=$testpath >/dev/null
#         ./simv >program.out
#         grep "@@@" program.out >$2/$testname.program.out
#         grep "CPI" program.out >$2/$testname.cpi.out
#         mv pipeline.out $2/$testname.pipeline.out
#         mv writeback.out $2/$testname.writeback.out
#     done
# }

function generate_base_outputs {
    if ! [ -d $BASEOUTDIR ]; then
        echo "$0: Making base outputs..."
        mkdir $BASEOUTDIR
        # branch_temp=$(git rev-parse --abbrev-ref HEAD)
        # git checkout $BASEBRANCH
        # echo "$0: Building base simv on branch [$BASEBRANCH]"
        make clean simv >/dev/null
        echo "$0: Done."
        run_tests ${ASSEMBLY_EXT} ${BASEOUTDIR} assembly
        run_tests ${PROGRAM_EXT} ${BASEOUTDIR} program
        # git checkout $branch_temp
    fi
}

function run_debug {
    extension=$1
    outputs=$2
    type=$3
    # echo "$0: $extension $outputs $type"
    echo "$0: Testing $type files"
    if [[ ! -d $outputs ]]; then
        echo "$0: Make directory $outputs"
        mkdir $outputs
    else
        rm -rf $outputs
        mkdir $outputs
    fi
    for test in "${tests[@]}"; do
        tst=$TESTCASES/$test
        testname=$tst
        testname=${testname##${TESTCASES}\/}
        testname=${testname%%.${extension}}
        echo "$0: Test: $testname"
        make $type SOURCE=$tst >/dev/null
        ./simv >program.out
        grep "@@@" program.out >$outputs/$testname.program.out
        # grep "CPI" program.out >$outputs/$testname.cpi.out
        mv pipeline.out $outputs/$testname.pipeline.out
        mv writeback.out $outputs/$testname.writeback.out
    done
}

function run_tests {
    extension=$1
    type=$2
    echo "$0: Testing $type files"
    for tst in $TESTCASES/*.$extension; do
        testname=$tst
        testname=${testname##${TESTCASES}\/}
        testname=${testname%%.${extension}}
        echo "$0: Test: $testname"
        make $type SOURCE=$tst >/dev/null
        ./simv >program.out
        grep "@@@" program.out >$2/$testname.program.out
        grep "CPI" program.out >$2/$testname.cpi.out
        mv pipeline.out $2/$testname.pipeline.out
        mv writeback.out $2/$testname.writeback.out
    done
}

function generate_test_outputs {
    # create test outputs
    git checkout $TESTBRANCH
    if [ -d $TESTOUTDIR ]; then
        echo "$0: Deleting old test outputs from $TESTOUTDIR"
        rm -r $TESTOUTDIR/*
    else
        mkdir $TESTOUTDIR
    fi
    echo "$0: Building Test simv on branch [$TESTBRANCH]"
    make clean simv >/dev/null
    echo "$0: Done."
    run_tests ${ASSEMBLY_EXT} ${TESTOUTDIR} assembly
    run_tests ${PROGRAM_EXT} ${TESTOUTDIR} program
}

function compare_results {
    printf "\TEST RESULTS:\n"
    # compare results
    pass_count=$((0))
    fail_count=$((0))
    total=$((0))
    for tst in $TESTOUTDIR/*.program.out; do
        testname=$tst
        testname=${testname##${TESTOUTDIR}\/}
        testname=${testname%%.program.out}
        diff $tst $BASEOUTDIR/$testname.program.out >/dev/null
        status=$? # 0 -> no difference
        if [[ "$status" -eq "0" ]]; then
            echo "$0: Test $testname PASSED"
            pass_count=$(($pass_count + 1))
        else
            echo "$0: Test $testname FAILED"
            fail_count=$(($fail_count + 1))
        fi
        echo "BASE PERF $(cat $BASEOUTDIR/$testname.cpi.out)"
        echo "TEST PERF $(cat $TESTOUTDIR/$testname.cpi.out)"
        echo ""
        total=$(($total + 1))
    done
    echo ""
    echo "PASSED $pass_count/$total tests ($fail_count failures)."
}

function compare_results_customize {
    for tst in $TESTOUTDIR/*.program.out; do
        testname=$tst
        testname=${testname##${TESTOUTDIR}\/}
        testname=${testname%%.program.out}
        echo "$0: test $testname"
        diff $tst $BASEOUTDIR/$testname.program.out 
    done
}

# changes=$(git status --porcelain | grep -v "??")

# if [ -n "$changes" ]; then
#     echo "Please commit/revert pending changes on current branch before running $0:"
#     echo $changes
#     exit
# fi

# generate_base_outputs
# generate_test_outputs
# compare_results
#run_debug c test_outputs program
run_debug s test_outputs assembly
compare_results_customize
