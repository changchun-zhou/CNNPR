import os
import sys
vf_dir = []
PATH = ["src", "sim"]
for path in PATH:
    dirs = os.listdir(path)
    for v in dirs:
        vf_dir.append("../" + path + "/" + v)

with open("./windows/vf", "w") as file1:
    for file_dir in vf_dir:
        file1.write(file_dir)
        file1.write("\n")

TB = os.listdir("sim")
testbench = TB[0]
# print(testbench[:-2])

with open("./windows/1_run_modelsim_v.bat", "w")as file2:
    file2.write("vlib work")
    file2.write("\n")
    file2.write("vlog -lint -f vf")
    file2.write("\n")
    file2.write("vsim -c -novopt -lib work " + testbench[:-2] + ''' -do "run -all''' + ';' + '''exit"''')
    file2.write("\n")
    file2.write("vfast -o " + testbench[:-2] + ".fsdb " + testbench[:-2] + ".vcd")
    file2.write("\n")
    file2.write("del *.vcd")

with open("./windows/2_run_debussy_v.bat", "w") as file3:
    file3.write("start /b debussy -2001 -f vf -ssf " + testbench[:-2] + ".fsdb -sswr " + testbench[:-2] + ".rc")
    file3.write("\n")
