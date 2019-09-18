ECHO on

ghdl -a Eq11-ULA.vhd
ghdl -e ula

ghdl -a Eq11-Reg16bits.vhd
ghdl -e reg16bits

ghdl -a Eq11-RegFile.vhd
ghdl -e register_file

ghdl  -a Eq11-ULARegs.vhd
ghdl  -e ularegs

ghdl  -a Eq11-ULARegs_tb.vhd
ghdl  -e ularegs_tb

ghdl  -r ULARegs_tb --wave=Eq11-ULARegs_tb.ghw --stop-time=3000ns

