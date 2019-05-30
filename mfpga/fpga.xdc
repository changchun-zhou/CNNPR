set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports clk]
## ----------------------------------------------------------------------------
## User DIP Switches - Bank 35
## ----------------------------------------------------------------------------
set_property PACKAGE_PIN F22 [get_ports {reset}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {m_rd_req_sw}];  # "SW1"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y11 [get_ports m_clk]
set_property PACKAGE_PIN AA8 [get_ports m_wr_req]
set_property PACKAGE_PIN AA11 [get_ports m_rd_req]
set_property PACKAGE_PIN Y10 [get_ports s_ready]
set_property PACKAGE_PIN AA9 [get_ports data_ov]
#set_property PACKAGE_PIN AB11 [get_ports {}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {data_pmod[4]}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {data_pmod[5]}];  # "JA9"


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W12 [get_ports {data_out[0]}]
set_property PACKAGE_PIN W11 [get_ports {data_out[1]}]
set_property PACKAGE_PIN V10 [get_ports {data_out[2]}]
set_property PACKAGE_PIN W8 [get_ports {data_out[3]}]
set_property PACKAGE_PIN V12 [get_ports {data_out[4]}]
set_property PACKAGE_PIN W10 [get_ports {data_out[5]}]
set_property PACKAGE_PIN V9 [get_ports {data_out[6]}]
set_property PACKAGE_PIN V8 [get_ports {data_out[7]}]

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AB6 [get_ports {data_out[8]}]
set_property PACKAGE_PIN AB7 [get_ports {data_out[9]}]
set_property PACKAGE_PIN AA4 [get_ports {data_out[10]}]
set_property PACKAGE_PIN Y4 [get_ports {data_out[11]}]
set_property PACKAGE_PIN T6 [get_ports {data_out[12]}]
set_property PACKAGE_PIN R6 [get_ports {data_out[13]}]
set_property PACKAGE_PIN U4 [get_ports {data_out[14]}]
set_property PACKAGE_PIN T4 [get_ports {data_out[15]}]

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W7 [get_ports {data_out[16]}]
set_property PACKAGE_PIN V7 [get_ports {data_out[17]}]
set_property PACKAGE_PIN V4 [get_ports {data_out[18]}]
set_property PACKAGE_PIN V5 [get_ports {data_out[19]}]
set_property PACKAGE_PIN W5 [get_ports {data_out[20]}]
set_property PACKAGE_PIN W6 [get_ports {data_out[21]}]
set_property PACKAGE_PIN U5 [get_ports {data_out[22]}]
set_property PACKAGE_PIN U6 [get_ports {data_out[23]}]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_out_IBUF[0]} {data_out_IBUF[1]} {data_out_IBUF[2]} {data_out_IBUF[3]} {data_out_IBUF[4]} {data_out_IBUF[5]} {data_out_IBUF[6]} {data_out_IBUF[7]} {data_out_IBUF[8]} {data_out_IBUF[9]} {data_out_IBUF[10]} {data_out_IBUF[11]} {data_out_IBUF[12]} {data_out_IBUF[13]} {data_out_IBUF[14]} {data_out_IBUF[15]} {data_out_IBUF[16]} {data_out_IBUF[17]} {data_out_IBUF[18]} {data_out_IBUF[19]} {data_out_IBUF[20]} {data_out_IBUF[21]} {data_out_IBUF[22]} {data_out_IBUF[23]} {data_out_IBUF[24]} {data_out_IBUF[25]} {data_out_IBUF[26]} {data_out_IBUF[27]} {data_out_IBUF[28]} {data_out_IBUF[29]} {data_out_IBUF[30]} {data_out_IBUF[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list clk_IBUF_BUFG]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list data_ov_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list m_clk_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list m_rd_req_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list m_wr_req_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list p_0_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list reset_IBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
