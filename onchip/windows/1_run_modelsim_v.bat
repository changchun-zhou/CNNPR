vlib work
vlog -lint -f vf
vsim -c -novopt work.mem_controller_tb -do "run -all"
vfast -o mem_controller_tb.fsdb mem_controller_tb.vcd
pause
