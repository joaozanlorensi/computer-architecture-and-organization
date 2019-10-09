#!/bin/bash

ghdl -a Eq11-StateMachine*.vhd

ghdl -e state_machine
ghdl -e state_machine_tb

ghdl -r state_machine_tb --wave=Eq11-StateMachine_tb.ghw --stop-time=600ns