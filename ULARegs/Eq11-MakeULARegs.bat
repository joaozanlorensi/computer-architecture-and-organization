echo on

C:\ghdl\ghdl\bin\ghdl.exe --clean
C:\ghdl\bin\ghdl.exe --remove

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-ULA.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e ula

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-Reg16bits.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e reg16bits

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-RegFile.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e register_file

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-ULARegs.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e ularegs

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-ULARegs_tb.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e ularegs_tb

C:\ghdl\ghdl\bin\ghdl.exe -r ULARegs_tb --wave=Eq11-ULARegs_tb.ghw --stop-time=3000ns

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-ULARegs_tb.ghw -a Eq11-ULARegs_tb.gtkw