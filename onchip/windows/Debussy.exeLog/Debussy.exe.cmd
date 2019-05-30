srcSourceCodeView
debImport "-2001" "-f" "vf"
debLoadSimResult F:\1-DL_hardware\CNNPR\onchip\windows\mem_controller_tb.fsdb
wvCreateWindow
wvResizeWindow -win $_nWave2 98 33 1778 515
wvOpenFile -win $_nWave2 \
           {F:\1-DL_hardware\CNNPR\onchip\windows\mem_controller_tb.fsdb}
wvRestoreSignal -win $_nWave2 "mem_controller_tb.rc"
srcResizeWindow 560 380 1024 463
wvResizeWindow -win $_nWave2 98 33 1778 515
srcDeselectAll -win $_nTrace1
srcHBSelect "mem_controller_tb.mem_controller" -win $_nTrace1
srcSetScope -win $_nTrace1 "mem_controller_tb.mem_controller" -delim "."
wvSetCursor -win $_nWave2 174.647571
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/clk"
wvSetPosition -win $_nWave2 {("G1" 0)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 1)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "state" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/state\[1:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 2)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "act_index" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/act_index\[3:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "wei_index" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/wei_index\[1:0\]"
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSelectGroup -win $_nWave2 {G3}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "parallel_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvSetCursor -win $_nWave2 166.741714 -snap {("G3" 0)}
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 1803.526476 -snap {("G3" 0)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvSetCursor -win $_nWave2 1855.273905 -snap {("G3" 0)}
wvSetCursor -win $_nWave2 2059.845381 -snap {("G3" 0)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "parallel_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "zero_flag" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/zero_flag"
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 1)}
wvSetPosition -win $_nWave2 {("G3" 1)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G3" 1)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "serial_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "parallel_out" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G3" wvResizeWindow -win $_nWave2 -7 46 1038 326
vSetPosition -win $_nWave2 {("G3" 0)}
wvAddSignal -win $_nWave2 \
           "/mem_controller_tb/mem_controller/parallel_out\[71:0\]"
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 1)}
wvSetCursor -win $_nWave2 1688.988810 -snap {("G4" 0)}
wvSetCursor -win $_nWave2 1210.660905 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 1230.784905 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 1256.658619 -snap {("G4" 0)}
wvSetCursor -win $_nWave2 1549.730238 -snap {("G3" 1)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 1589.891726 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 1596.270315 -snap {("G4" 0)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "serial_out" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G3" 2)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/serial_out\[7:0\]"
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G4" 1)}
wvSetPosition -win $_nWave2 {("G4" 1)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G4" 1)}
wvSetCursor -win $_nWave2 1542.456583 -snap {("G5" 0)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "wei_index" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "row_index" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/row_index\[4:0\]"
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G5" 1)}
wvSetPosition -win $_nWave2 {("G5" 1)}
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G5" 1)}
wvSetCursor -win $_nWave2 1444.847351 -snap {("G6" 0)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetRadix -win $_nWave2 -format UDec {("G5" 1)}
wvSetCursor -win $_nWave2 2664.992571 -snap {("G6" 0)}
wvSelectSignal -win $_nWave2 {( "G5" 1 )}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "zero_flag" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "row_val_num" -win $_nTrace1
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G6" 0)}
wvAddSignal -win $_nWave2 "/mem_controller_tb/mem_controller/row_val_num\[3:0\]"
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G6" 1)}
wvSetPosition -win $_nWave2 {("G6" 1)}
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("G6" 1)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "zero_flag" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "row_index" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "serial_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "parallel_out" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvResizeWindow -win $_nWave2 -7 24 1038 515
