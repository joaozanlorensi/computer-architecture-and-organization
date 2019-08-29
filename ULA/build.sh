#!/bin/bash
# Building project script
# Usage - ./build.sh <entity-name>

ghdl -a *.vhd
ghdl -r $1 --wave=waves.ghw
gtkwave waves.ghw
