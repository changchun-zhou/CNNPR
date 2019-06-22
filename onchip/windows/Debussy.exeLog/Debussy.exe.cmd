srcSourceCodeView
debImport "-2001" "-f" "vf"
debLoadSimResult F:\1-DL_hardware\CNNPR\onchip\windows\mem_controller_tb.fsdb
wvCreateWindow
wvResizeWindow -win $_nWave2 54 237 960 332
wvOpenFile -win $_nWave2 \
           {F:\1-DL_hardware\CNNPR\onchip\windows\mem_controller_tb.fsdb}
wvRestoreSignal -win $_nWave2 "mem_controller_tb.rc"
srcResizeWindow 0 0 804 500
wvResizeWindow -win $_nWave2 54 237 960 332
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/mem_controller_tb"
wvGetSignalSetScope -win $_nWave2 "/mem_controller_tb/mem_controller"
wvGetSignalSetSignalFilter -win $_nWave2 "state"
wvGetSignalSetSignalFilter -win $_nWave2 "row_index"
wvGetSignalSetSignalFilter -win $_nWave2 "parallel_out"
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/state[1:0]} \
{/mem_controller_tb/mem_controller/row_index[3:0]} \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 3 )}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/state[1:0]} \
{/mem_controller_tb/mem_controller/row_index[3:0]} \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 3 )}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 3210.691066 -snap {("G1" 2)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvResizeWindow -win $_nWave2 54 237 960 332
wvResizeWindow -win $_nWave2 54 237 960 332
wvCloseWindow -win $_nWave2
wvGetSignalClose -win $_nWave2
debExit
