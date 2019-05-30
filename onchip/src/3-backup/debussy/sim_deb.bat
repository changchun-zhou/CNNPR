::关闭回显 
@ECHO OFF 
::设置软件路径 
::------------------------------------------
SET debussy=D:\ApplicationProgram\Debussy\bin\Debussy.exe
SET vfast=D:\ApplicationProgram\Debussy\bin\vfast.exe 
SET vsim=D:\ApplicationProgram\Modelsim10.1a\win32\vsim.exe 

::ModelSim Command 
::------------------------------------------
%vsim% -c -do sim.do 


::将VCD转换成FSDB
::------------------------------------------
::%vfast% mem_controller.vcd -o mem_controller.fsdb



::删除ModelSim生成的相关文件 
::------------------------------------------
::RD work /s /q 
::DEL transcript vsim.wlf /q 


::Debussy Command 
::------------------------------------------
%Debussy% -f rtl.f -ssf mem_controller.fsdb -2001 


::删除波形文件 
::DEL Debussy.fsdb /q 
::删除Debussy生成的相关文件 
RD Debussy.exeLog  /s /q 
::DEL novas.rc /q 
::退出命令行 
EXIT