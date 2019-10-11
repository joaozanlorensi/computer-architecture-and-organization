echo on

C:\ghdl\ghdl\bin\ghdl.exe --clean
C:\ghdl\ghdl\bin\ghdl.exe --remove

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-PC.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e pc

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-UC.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e UC

C:\ghdl\ghdl\bin\ghdl.exe -r uc --wave=Eq11-UC.ghw --stop-time=3000ns

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-UC.ghw -a Eq11-UC.gtkw
