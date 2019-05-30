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
