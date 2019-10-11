echo on

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-StateMachine.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e state_machine

C:\ghdl\ghdl\bin\ghdl.exe -a Eq11-StateMachine_tb.vhd
C:\ghdl\ghdl\bin\ghdl.exe -e state_machine_tb

C:\ghdl\ghdl\bin\ghdl.exe -r state_machine_tb --wave=Eq11-StateMachine_tb.ghw --stop-time=3000ns

start cmd /c C:\ghdl\ghdl\gtkwave -f Eq11-StateMachine_tb.ghw -a Eq11-StateMachine_tb.gtkw

