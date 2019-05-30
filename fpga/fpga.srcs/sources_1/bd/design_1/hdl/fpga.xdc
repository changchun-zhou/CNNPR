# JA Pmod - Bank 13 
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y11  [get_ports {m_clk}];  # "JA1"  #output clock

set_property PACKAGE_PIN AA8  [get_ports {m_wr_req}];  # "JA10" #output 

set_property PACKAGE_PIN AA11 [get_ports {m_rd_req}];  # "JA2"
set_property PACKAGE_PIN Y10  [get_ports {s_ready}];  # "JA3"
set_property PACKAGE_PIN AA9  [get_ports {valid}];  # "JA4"
set_property PACKAGE_PIN AB11 [get_ports {}];  # "JA7"
set_property PACKAGE_PIN AB10 [get_ports {data_pmod[4]}];  # "JA8"
set_property PACKAGE_PIN AB9  [get_ports {data_pmod[5]}];  # "JA9"


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN W12 [get_ports {data_out[0]}];  # "JB1"
set_property PACKAGE_PIN W11 [get_ports {data_out[1]}];  # "JB2"
set_property PACKAGE_PIN V10 [get_ports {data_out[2]}];  # "JB3"
set_property PACKAGE_PIN W8  [get_ports {data_out[3]}];  # "JB4"
set_property PACKAGE_PIN V12 [get_ports {data_out[4]}];  # "JB7"
set_property PACKAGE_PIN W10 [get_ports {data_out[5]}];  # "JB8"
set_property PACKAGE_PIN V9  [get_ports {data_out[6]}];  # "JB9"
set_property PACKAGE_PIN V8  [get_ports {data_out[7]}];  # "JB10"

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AB6 [get_ports {data_out[8]}];  # "JC1_N"
set_property PACKAGE_PIN AB7 [get_ports {data_out[9]}];  # "JC1_P"
set_property PACKAGE_PIN AA4 [get_ports {data_out[10]}];  # "JC2_N"
set_property PACKAGE_PIN Y4  [get_ports {data_out[11]}];  # "JC2_P"
set_property PACKAGE_PIN T6  [get_ports {data_out[12]}];  # "JC3_N"
set_property PACKAGE_PIN R6  [get_ports {data_out[13]}];  # "JC3_P"
set_property PACKAGE_PIN U4  [get_ports {data_out[14]}];  # "JC4_N"
set_property PACKAGE_PIN T4  [get_ports {data_out[15]}];  # "JC4_P"

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN W7 [get_ports {data_out[16]}];  # "JD1_N"
set_property PACKAGE_PIN V7 [get_ports {data_out[17]}];  # "JD1_P"
set_property PACKAGE_PIN V4 [get_ports {data_out[18]}];  # "JD2_N"
set_property PACKAGE_PIN V5 [get_ports {data_out[19]}];  # "JD2_P"
set_property PACKAGE_PIN W5 [get_ports {data_out[20]}];  # "JD3_N"
set_property PACKAGE_PIN W6 [get_ports {data_out[21]}];  # "JD3_P"
set_property PACKAGE_PIN U5 [get_ports {data_out[22]}];  # "JD4_N"
set_property PACKAGE_PIN U6 [get_ports {data_out[23]}];  # "JD4_P"
