#!/bin/sh

MAIN_ENTITY="RegFile"
TB_ENTITY="register_file_tb"

ghdl --clean
ghdl --remove

ghdl -a *.vhd

ghdl -r "$TB_ENTITY" --wave="Eq11-$MAIN_ENTITY.ghw" --stop-time=3000ns

gtkwave -f "Eq11-$MAIN_ENTITY.ghw" -a "Eq11-$MAIN_ENTITY.gtkw"

