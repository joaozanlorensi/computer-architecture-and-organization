echo on

C:\ghdl\ghdl\bin\ghdl.exe --clean
C:\ghdl\ghdl\bin\ghdl.exe --remove

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-PC.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e pc

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-PC_tb.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e pc_tb

C:\ghdl\ghdl\bin\ghdl.exe -r pc_tb --wave=Eq11-PC_tb.ghw

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-PC_tb.ghw -a Eq11-PC_tb.gtkw
