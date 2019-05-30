vlib work
vlog -lint -f vf
vsim -c -novopt work.mem_controller_tb -do "run -all"
vfast -o mem_controller_tb.fsdb mem_controller_tb.vcd

start /b debussy -2001 -f vf -ssf mem_controller_tb.fsdb -sswr mem_controller_tb.rc
