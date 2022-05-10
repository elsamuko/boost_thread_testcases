#!/usr/bin/env bash

function please_remove {
    if [ -f "$1" ]; then
        rm "$1"
    fi
    if [ -d "$1" ]; then
        rm -rf "$1"
    fi
}

function indent {
    sed  's/^/    /'
}

function red  {
    echo -e "\033[1;31m$*\033[0m"
}

function green  {
    echo -e "\033[1;32m$*\033[0m"
}

function cyan  {
    echo -e "\033[1;34m$*\033[0m"
}

function build_and_run {
    echo "-----------------------------------------------------------------"
    cyan "With $1"
    please_remove double_interrupt
    please_remove Makefile
    please_remove bin

    qmake "CONFIG+=$2" double_interrupt.pro
    make --silent clean
    make --silent -j 8
    ./bin/release/double_interrupt
    if [ $? -eq 0 ]; then green "No crash"; else red "Crash"; fi
    echo "-----------------------------------------------------------------"
    echo
}

build_and_run "boost::scoped_thread<boost::interrupt_and_join_if_joinable>" "with_scoped_thread"
build_and_run "boost::scoped_thread<boost::non_interruptable_interrupt_and_join_if_joinable>" "with_scoped_thread_ni"
build_and_run "boost::thread_guard<boost::interrupt_and_join_if_joinable>" "with_thread_guard"
build_and_run "boost::thread_guard<boost::non_interruptable_interrupt_and_join_if_joinable>" "with_thread_guard_ni"
build_and_run "~scope_guard()" "with_scope_guard"
build_and_run "boost::this_thread::disable_interruption" "with_non_interrupt"
build_and_run "catch(boost::thread_interrupted&)" "with_catch"
build_and_run "boost::thread::join()" "with_manual"
