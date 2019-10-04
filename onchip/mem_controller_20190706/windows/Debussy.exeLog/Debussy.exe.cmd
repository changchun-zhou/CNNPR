srcSourceCodeView
debImport "-2001" "-f" "vf"
debLoadSimResult \
           F:\1-DL_hardware\CNNPR\onchip\mem_controller_20190706\windows\mem_controller_tb.fsdb
wvCreateWindow
wvResizeWindow -win $_nWave2 -7 205 1038 589
wvOpenFile -win $_nWave2 \
           {F:\1-DL_hardware\CNNPR\onchip\mem_controller_20190706\windows\mem_controller_tb.fsdb}
wvRestoreSignal -win $_nWave2 "mem_controller_tb.rc"
srcResizeWindow 426 210 804 500
wvResizeWindow -win $_nWave2 -7 205 1038 589
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/mem_controller_tb"
wvGetSignalSetScope -win $_nWave2 "/mem_controller_tb/mem_controller"
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/clk} \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
{/mem_controller_tb/mem_controller/state[2:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 )}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/clk} \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
{/mem_controller_tb/mem_controller/state[2:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 )}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 30127.723971 -snap {("G2" 0)}
wvResizeWindow -win $_nWave2 571 301 1038 589
wvSelectSignal -win $_nWave2 {( "G1" 2 )}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvResizeWindow -win $_nWave2 259 445 1038 588
wvResizeWindow -win $_nWave2 259 445 1038 367
wvResizeWindow -win $_nWave2 259 445 1038 309
wvResizeWindow -win $_nWave2 259 445 1038 266
wvSetCursor -win $_nWave2 511960.167051 -snap {("G2" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/clk} \
{/mem_controller_tb/mem_controller/state[2:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
{/mem_controller_tb/mem_controller/row_index[3:0]} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
}
wvSelectSignal -win $_nWave2 {( "G2" 2 )}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/mem_controller_tb/mem_controller/clk} \
{/mem_controller_tb/mem_controller/state[2:0]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
{/mem_controller_tb/mem_controller/parallel_out[71:0]} \
{/mem_controller_tb/mem_controller/row_index[3:0]} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
}
wvSelectSignal -win $_nWave2 {( "G2" 2 )}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvGetSignalClose -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 926233050
wvSetCursor -win $_nWave2 696894.427183 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 887836.887224 -snap {("G2" 2)}
wvSetRadix -win $_nWave2 -format UDec {("G2" 2)}
wvSearchNext -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G2" 1 )}
wvSetCursor -win $_nWave2 892882.820494 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 932409.297779 -snap {("G1" 2)}
debExit
