#!/bin/sh

ghdl -a *.vhd

ghdl -e rom
ghdl -e reg24bits
ghdl -e register_file
ghdl -e pc
ghdl -e uc
ghdl -e ula
ghdl -e flags
ghdl -e uprocessor
ghdl -e uprocessor_tb

ghdl -r uprocessor_tb --wave=Eq11-DesvCond.ghw --stop-time=120000ns