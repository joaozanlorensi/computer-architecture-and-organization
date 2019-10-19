#!/bin/sh

ghdl --clean
ghdl --remove

# Program counter
ghdl -a Eq11-PC.vhd
ghdl -e pc

# ROM
ghdl -a Eq11-ROM.vhd
ghdl -e rom

# Control unit
ghdl -a Eq11-UC.vhd
ghdl -e uc

# ROM-PC-UC
ghdl -a Eq11-ROM-PC-UC.vhd
ghdl -e rom_pc_uc

# Testbench
ghdl -a Eq11-ROM-PC-UC_tb.vhd
ghdl -e rom_pc_uc_tb

# Run the testbench
ghdl -r rom_pc_uc_tb --wave=Eq11-ROM-PC-UC.ghw --stop-time=3000ns;

# Show on GTKWave
gtkwave -f Eq11-ROM-PC-UC.ghw -a Eq11-ROM-PC-UC.gtkw
