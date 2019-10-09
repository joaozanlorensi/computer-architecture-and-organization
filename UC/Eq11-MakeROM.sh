#!/bin/bash

ghdl -a Eq11-ROM.vhd Eq11-ROM_tb.vhd

ghdl -e rom
ghdl -e rom_tb

ghdl -r rom_tb --wave=Eq11-ROM_tb.ghw --stop-time=600ns
