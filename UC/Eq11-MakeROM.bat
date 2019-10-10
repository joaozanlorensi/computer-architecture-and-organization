echo on

C:\ghdl\ghdl\bin\ghdl.exe --clean
C:\ghdl\ghdl\bin\ghdl.exe --remove

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-ROM.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e rom

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-ROM_tb.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e rom_tb

C:\ghdl\ghdl\bin\ghdl.exe -r rom_tb --wave=Eq11-ROM_tb.ghw

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-ROM_tb.ghw -a Eq11-ROM_tb.gtkw