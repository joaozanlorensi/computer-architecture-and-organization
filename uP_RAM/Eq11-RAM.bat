echo on

C:\ghdl\ghdl\bin\ghdl.exe --clean
C:\ghdl\bin\ghdl.exe --remove

C:\ghdl\ghdl\bin\ghdl.exe -a *.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e reg24bits
C:\ghdl\ghdl\bin\ghdl.exe -e ram
C:\ghdl\ghdl\bin\ghdl.exe -e register_file
C:\ghdl\ghdl\bin\ghdl.exe -e rom
C:\ghdl\ghdl\bin\ghdl.exe -e flags
C:\ghdl\ghdl\bin\ghdl.exe -e pc
C:\ghdl\ghdl\bin\ghdl.exe -e uc
C:\ghdl\ghdl\bin\ghdl.exe -e uprocessor
C:\ghdl\ghdl\bin\ghdl.exe -e ula
C:\ghdl\ghdl\bin\ghdl.exe -e ularegs
C:\ghdl\ghdl\bin\ghdl.exe -e uprocessor_tb


C:\ghdl\ghdl\bin\ghdl.exe -r uprocessor_tb --wave=Eq11-RAM.ghw --stop-time=480000ns

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-RAM.ghw -a Eq11-RAM.gtkw