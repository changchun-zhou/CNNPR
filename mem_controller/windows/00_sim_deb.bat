rd /q /s Debussy.exeLog
rd /q /s vfast.exeLog
rd /q /s work
del /q *.fsdb
del /q *.vcd
del /q *.vstf
del /q transcript

del /q novas.rc
del /q plain.txt
del /q cipher.txt
del /q modelsim.ini

del /q *.wlf

rd /q /s work.lib++
rd /q /s vericom.exeLog
rd /q /s vhdlcom.exeLog

vlib work
vlog -lint -f vf
vsim -c -novopt work.mem_controller_tb -do "run -all"
vfast -o mem_controller_tb.fsdb mem_controller_tb.vcd

start /b debussy -2001 -f vf -ssf mem_controller_tb.fsdb -sswr mem_controller_tb.rc
pause
