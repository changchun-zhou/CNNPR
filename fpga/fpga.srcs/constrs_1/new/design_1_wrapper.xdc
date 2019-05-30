set_property PACKAGE_PIN F22 [get_ports rd_req]
set_property PACKAGE_PIN G22 [get_ports wr_req]
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {pl_mem_controller/rd_addr[0]} {pl_mem_controller/rd_addr[1]} {pl_mem_controller/rd_addr[2]} {pl_mem_controller/rd_addr[3]} {pl_mem_controller/rd_addr[4]} {pl_mem_controller/rd_addr[5]} {pl_mem_controller/rd_addr[6]} {pl_mem_controller/rd_addr[7]} {pl_mem_controller/rd_addr[8]} {pl_mem_controller/rd_addr[9]} {pl_mem_controller/rd_addr[10]} {pl_mem_controller/rd_addr[11]} {pl_mem_controller/rd_addr[12]} {pl_mem_controller/rd_addr[13]} {pl_mem_controller/rd_addr[14]} {pl_mem_controller/rd_addr[15]} {pl_mem_controller/rd_addr[16]} {pl_mem_controller/rd_addr[17]} {pl_mem_controller/rd_addr[18]} {pl_mem_controller/rd_addr[19]} {pl_mem_controller/rd_addr[20]} {pl_mem_controller/rd_addr[21]} {pl_mem_controller/rd_addr[22]} {pl_mem_controller/rd_addr[23]} {pl_mem_controller/rd_addr[24]} {pl_mem_controller/rd_addr[25]} {pl_mem_controller/rd_addr[26]} {pl_mem_controller/rd_addr[27]} {pl_mem_controller/rd_addr[28]} {pl_mem_controller/rd_addr[29]} {pl_mem_controller/rd_addr[30]} {pl_mem_controller/rd_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 64 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pl_mem_controller/M_AXI_RDATA[0]} {pl_mem_controller/M_AXI_RDATA[1]} {pl_mem_controller/M_AXI_RDATA[2]} {pl_mem_controller/M_AXI_RDATA[3]} {pl_mem_controller/M_AXI_RDATA[4]} {pl_mem_controller/M_AXI_RDATA[5]} {pl_mem_controller/M_AXI_RDATA[6]} {pl_mem_controller/M_AXI_RDATA[7]} {pl_mem_controller/M_AXI_RDATA[8]} {pl_mem_controller/M_AXI_RDATA[9]} {pl_mem_controller/M_AXI_RDATA[10]} {pl_mem_controller/M_AXI_RDATA[11]} {pl_mem_controller/M_AXI_RDATA[12]} {pl_mem_controller/M_AXI_RDATA[13]} {pl_mem_controller/M_AXI_RDATA[14]} {pl_mem_controller/M_AXI_RDATA[15]} {pl_mem_controller/M_AXI_RDATA[16]} {pl_mem_controller/M_AXI_RDATA[17]} {pl_mem_controller/M_AXI_RDATA[18]} {pl_mem_controller/M_AXI_RDATA[19]} {pl_mem_controller/M_AXI_RDATA[20]} {pl_mem_controller/M_AXI_RDATA[21]} {pl_mem_controller/M_AXI_RDATA[22]} {pl_mem_controller/M_AXI_RDATA[23]} {pl_mem_controller/M_AXI_RDATA[24]} {pl_mem_controller/M_AXI_RDATA[25]} {pl_mem_controller/M_AXI_RDATA[26]} {pl_mem_controller/M_AXI_RDATA[27]} {pl_mem_controller/M_AXI_RDATA[28]} {pl_mem_controller/M_AXI_RDATA[29]} {pl_mem_controller/M_AXI_RDATA[30]} {pl_mem_controller/M_AXI_RDATA[31]} {pl_mem_controller/M_AXI_RDATA[32]} {pl_mem_controller/M_AXI_RDATA[33]} {pl_mem_controller/M_AXI_RDATA[34]} {pl_mem_controller/M_AXI_RDATA[35]} {pl_mem_controller/M_AXI_RDATA[36]} {pl_mem_controller/M_AXI_RDATA[37]} {pl_mem_controller/M_AXI_RDATA[38]} {pl_mem_controller/M_AXI_RDATA[39]} {pl_mem_controller/M_AXI_RDATA[40]} {pl_mem_controller/M_AXI_RDATA[41]} {pl_mem_controller/M_AXI_RDATA[42]} {pl_mem_controller/M_AXI_RDATA[43]} {pl_mem_controller/M_AXI_RDATA[44]} {pl_mem_controller/M_AXI_RDATA[45]} {pl_mem_controller/M_AXI_RDATA[46]} {pl_mem_controller/M_AXI_RDATA[47]} {pl_mem_controller/M_AXI_RDATA[48]} {pl_mem_controller/M_AXI_RDATA[49]} {pl_mem_controller/M_AXI_RDATA[50]} {pl_mem_controller/M_AXI_RDATA[51]} {pl_mem_controller/M_AXI_RDATA[52]} {pl_mem_controller/M_AXI_RDATA[53]} {pl_mem_controller/M_AXI_RDATA[54]} {pl_mem_controller/M_AXI_RDATA[55]} {pl_mem_controller/M_AXI_RDATA[56]} {pl_mem_controller/M_AXI_RDATA[57]} {pl_mem_controller/M_AXI_RDATA[58]} {pl_mem_controller/M_AXI_RDATA[59]} {pl_mem_controller/M_AXI_RDATA[60]} {pl_mem_controller/M_AXI_RDATA[61]} {pl_mem_controller/M_AXI_RDATA[62]} {pl_mem_controller/M_AXI_RDATA[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 64 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {S_AXI_HP0_wdata[0]} {S_AXI_HP0_wdata[1]} {S_AXI_HP0_wdata[2]} {S_AXI_HP0_wdata[3]} {S_AXI_HP0_wdata[4]} {S_AXI_HP0_wdata[5]} {S_AXI_HP0_wdata[6]} {S_AXI_HP0_wdata[7]} {S_AXI_HP0_wdata[8]} {S_AXI_HP0_wdata[9]} {S_AXI_HP0_wdata[10]} {S_AXI_HP0_wdata[11]} {S_AXI_HP0_wdata[12]} {S_AXI_HP0_wdata[13]} {S_AXI_HP0_wdata[14]} {S_AXI_HP0_wdata[15]} {S_AXI_HP0_wdata[16]} {S_AXI_HP0_wdata[17]} {S_AXI_HP0_wdata[18]} {S_AXI_HP0_wdata[19]} {S_AXI_HP0_wdata[20]} {S_AXI_HP0_wdata[21]} {S_AXI_HP0_wdata[22]} {S_AXI_HP0_wdata[23]} {S_AXI_HP0_wdata[24]} {S_AXI_HP0_wdata[25]} {S_AXI_HP0_wdata[26]} {S_AXI_HP0_wdata[27]} {S_AXI_HP0_wdata[28]} {S_AXI_HP0_wdata[29]} {S_AXI_HP0_wdata[30]} {S_AXI_HP0_wdata[31]} {S_AXI_HP0_wdata[32]} {S_AXI_HP0_wdata[33]} {S_AXI_HP0_wdata[34]} {S_AXI_HP0_wdata[35]} {S_AXI_HP0_wdata[36]} {S_AXI_HP0_wdata[37]} {S_AXI_HP0_wdata[38]} {S_AXI_HP0_wdata[39]} {S_AXI_HP0_wdata[40]} {S_AXI_HP0_wdata[41]} {S_AXI_HP0_wdata[42]} {S_AXI_HP0_wdata[43]} {S_AXI_HP0_wdata[44]} {S_AXI_HP0_wdata[45]} {S_AXI_HP0_wdata[46]} {S_AXI_HP0_wdata[47]} {S_AXI_HP0_wdata[48]} {S_AXI_HP0_wdata[49]} {S_AXI_HP0_wdata[50]} {S_AXI_HP0_wdata[51]} {S_AXI_HP0_wdata[52]} {S_AXI_HP0_wdata[53]} {S_AXI_HP0_wdata[54]} {S_AXI_HP0_wdata[55]} {S_AXI_HP0_wdata[56]} {S_AXI_HP0_wdata[57]} {S_AXI_HP0_wdata[58]} {S_AXI_HP0_wdata[59]} {S_AXI_HP0_wdata[60]} {S_AXI_HP0_wdata[61]} {S_AXI_HP0_wdata[62]} {S_AXI_HP0_wdata[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {S_AXI_HP0_rdata[53]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {S_AXI_HP0_bresp[0]} {S_AXI_HP0_bresp[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {pl_mem_controller/M_AXI_AWADDR[0]} {pl_mem_controller/M_AXI_AWADDR[1]} {pl_mem_controller/M_AXI_AWADDR[2]} {pl_mem_controller/M_AXI_AWADDR[3]} {pl_mem_controller/M_AXI_AWADDR[4]} {pl_mem_controller/M_AXI_AWADDR[5]} {pl_mem_controller/M_AXI_AWADDR[6]} {pl_mem_controller/M_AXI_AWADDR[7]} {pl_mem_controller/M_AXI_AWADDR[8]} {pl_mem_controller/M_AXI_AWADDR[9]} {pl_mem_controller/M_AXI_AWADDR[10]} {pl_mem_controller/M_AXI_AWADDR[11]} {pl_mem_controller/M_AXI_AWADDR[12]} {pl_mem_controller/M_AXI_AWADDR[13]} {pl_mem_controller/M_AXI_AWADDR[14]} {pl_mem_controller/M_AXI_AWADDR[15]} {pl_mem_controller/M_AXI_AWADDR[16]} {pl_mem_controller/M_AXI_AWADDR[17]} {pl_mem_controller/M_AXI_AWADDR[18]} {pl_mem_controller/M_AXI_AWADDR[19]} {pl_mem_controller/M_AXI_AWADDR[20]} {pl_mem_controller/M_AXI_AWADDR[21]} {pl_mem_controller/M_AXI_AWADDR[22]} {pl_mem_controller/M_AXI_AWADDR[23]} {pl_mem_controller/M_AXI_AWADDR[24]} {pl_mem_controller/M_AXI_AWADDR[25]} {pl_mem_controller/M_AXI_AWADDR[26]} {pl_mem_controller/M_AXI_AWADDR[27]} {pl_mem_controller/M_AXI_AWADDR[28]} {pl_mem_controller/M_AXI_AWADDR[29]} {pl_mem_controller/M_AXI_AWADDR[30]} {pl_mem_controller/M_AXI_AWADDR[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {pl_mem_controller/M_AXI_ARADDR[0]} {pl_mem_controller/M_AXI_ARADDR[1]} {pl_mem_controller/M_AXI_ARADDR[2]} {pl_mem_controller/M_AXI_ARADDR[3]} {pl_mem_controller/M_AXI_ARADDR[4]} {pl_mem_controller/M_AXI_ARADDR[5]} {pl_mem_controller/M_AXI_ARADDR[6]} {pl_mem_controller/M_AXI_ARADDR[7]} {pl_mem_controller/M_AXI_ARADDR[8]} {pl_mem_controller/M_AXI_ARADDR[9]} {pl_mem_controller/M_AXI_ARADDR[10]} {pl_mem_controller/M_AXI_ARADDR[11]} {pl_mem_controller/M_AXI_ARADDR[12]} {pl_mem_controller/M_AXI_ARADDR[13]} {pl_mem_controller/M_AXI_ARADDR[14]} {pl_mem_controller/M_AXI_ARADDR[15]} {pl_mem_controller/M_AXI_ARADDR[16]} {pl_mem_controller/M_AXI_ARADDR[17]} {pl_mem_controller/M_AXI_ARADDR[18]} {pl_mem_controller/M_AXI_ARADDR[19]} {pl_mem_controller/M_AXI_ARADDR[20]} {pl_mem_controller/M_AXI_ARADDR[21]} {pl_mem_controller/M_AXI_ARADDR[22]} {pl_mem_controller/M_AXI_ARADDR[23]} {pl_mem_controller/M_AXI_ARADDR[24]} {pl_mem_controller/M_AXI_ARADDR[25]} {pl_mem_controller/M_AXI_ARADDR[26]} {pl_mem_controller/M_AXI_ARADDR[27]} {pl_mem_controller/M_AXI_ARADDR[28]} {pl_mem_controller/M_AXI_ARADDR[29]} {pl_mem_controller/M_AXI_ARADDR[30]} {pl_mem_controller/M_AXI_ARADDR[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 2 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {pl_mem_controller/u_axim/AXI_GEN[0].u_axim/write_state_wire[0]} {pl_mem_controller/u_axim/AXI_GEN[0].u_axim/write_state_wire[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 64 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {pl_mem_controller/axi_rd_buffer_data_in[0]} {pl_mem_controller/axi_rd_buffer_data_in[1]} {pl_mem_controller/axi_rd_buffer_data_in[2]} {pl_mem_controller/axi_rd_buffer_data_in[3]} {pl_mem_controller/axi_rd_buffer_data_in[4]} {pl_mem_controller/axi_rd_buffer_data_in[5]} {pl_mem_controller/axi_rd_buffer_data_in[6]} {pl_mem_controller/axi_rd_buffer_data_in[7]} {pl_mem_controller/axi_rd_buffer_data_in[8]} {pl_mem_controller/axi_rd_buffer_data_in[9]} {pl_mem_controller/axi_rd_buffer_data_in[10]} {pl_mem_controller/axi_rd_buffer_data_in[11]} {pl_mem_controller/axi_rd_buffer_data_in[12]} {pl_mem_controller/axi_rd_buffer_data_in[13]} {pl_mem_controller/axi_rd_buffer_data_in[14]} {pl_mem_controller/axi_rd_buffer_data_in[15]} {pl_mem_controller/axi_rd_buffer_data_in[16]} {pl_mem_controller/axi_rd_buffer_data_in[17]} {pl_mem_controller/axi_rd_buffer_data_in[18]} {pl_mem_controller/axi_rd_buffer_data_in[19]} {pl_mem_controller/axi_rd_buffer_data_in[20]} {pl_mem_controller/axi_rd_buffer_data_in[21]} {pl_mem_controller/axi_rd_buffer_data_in[22]} {pl_mem_controller/axi_rd_buffer_data_in[23]} {pl_mem_controller/axi_rd_buffer_data_in[24]} {pl_mem_controller/axi_rd_buffer_data_in[25]} {pl_mem_controller/axi_rd_buffer_data_in[26]} {pl_mem_controller/axi_rd_buffer_data_in[27]} {pl_mem_controller/axi_rd_buffer_data_in[28]} {pl_mem_controller/axi_rd_buffer_data_in[29]} {pl_mem_controller/axi_rd_buffer_data_in[30]} {pl_mem_controller/axi_rd_buffer_data_in[31]} {pl_mem_controller/axi_rd_buffer_data_in[32]} {pl_mem_controller/axi_rd_buffer_data_in[33]} {pl_mem_controller/axi_rd_buffer_data_in[34]} {pl_mem_controller/axi_rd_buffer_data_in[35]} {pl_mem_controller/axi_rd_buffer_data_in[36]} {pl_mem_controller/axi_rd_buffer_data_in[37]} {pl_mem_controller/axi_rd_buffer_data_in[38]} {pl_mem_controller/axi_rd_buffer_data_in[39]} {pl_mem_controller/axi_rd_buffer_data_in[40]} {pl_mem_controller/axi_rd_buffer_data_in[41]} {pl_mem_controller/axi_rd_buffer_data_in[42]} {pl_mem_controller/axi_rd_buffer_data_in[43]} {pl_mem_controller/axi_rd_buffer_data_in[44]} {pl_mem_controller/axi_rd_buffer_data_in[45]} {pl_mem_controller/axi_rd_buffer_data_in[46]} {pl_mem_controller/axi_rd_buffer_data_in[47]} {pl_mem_controller/axi_rd_buffer_data_in[48]} {pl_mem_controller/axi_rd_buffer_data_in[49]} {pl_mem_controller/axi_rd_buffer_data_in[50]} {pl_mem_controller/axi_rd_buffer_data_in[51]} {pl_mem_controller/axi_rd_buffer_data_in[52]} {pl_mem_controller/axi_rd_buffer_data_in[53]} {pl_mem_controller/axi_rd_buffer_data_in[54]} {pl_mem_controller/axi_rd_buffer_data_in[55]} {pl_mem_controller/axi_rd_buffer_data_in[56]} {pl_mem_controller/axi_rd_buffer_data_in[57]} {pl_mem_controller/axi_rd_buffer_data_in[58]} {pl_mem_controller/axi_rd_buffer_data_in[59]} {pl_mem_controller/axi_rd_buffer_data_in[60]} {pl_mem_controller/axi_rd_buffer_data_in[61]} {pl_mem_controller/axi_rd_buffer_data_in[62]} {pl_mem_controller/axi_rd_buffer_data_in[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 10 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {pl_mem_controller/rd_req_size[0]} {pl_mem_controller/rd_req_size[1]} {pl_mem_controller/rd_req_size[2]} {pl_mem_controller/rd_req_size[3]} {pl_mem_controller/rd_req_size[4]} {pl_mem_controller/rd_req_size[5]} {pl_mem_controller/rd_req_size[6]} {pl_mem_controller/rd_req_size[7]} {pl_mem_controller/rd_req_size[8]} {pl_mem_controller/rd_req_size[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 2 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {S_AXI_HP0_rresp[0]} {S_AXI_HP0_rresp[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 10 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {pl_mem_controller/rd_rvalid_size[0]} {pl_mem_controller/rd_rvalid_size[1]} {pl_mem_controller/rd_rvalid_size[2]} {pl_mem_controller/rd_rvalid_size[3]} {pl_mem_controller/rd_rvalid_size[4]} {pl_mem_controller/rd_rvalid_size[5]} {pl_mem_controller/rd_rvalid_size[6]} {pl_mem_controller/rd_rvalid_size[7]} {pl_mem_controller/rd_rvalid_size[8]} {pl_mem_controller/rd_rvalid_size[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list pl_mem_controller/axi_rd_buffer_push]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list pl_mem_controller/axi_rd_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list FCLK_CLK0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list FCLK_RESET0_N]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list pl_mem_controller/rd_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list pl_mem_controller/rd_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list pl_mem_controller/read_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list S_AXI_HP0_arready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list S_AXI_HP0_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list S_AXI_HP0_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list S_AXI_HP0_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list S_AXI_HP0_rlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list S_AXI_HP0_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list S_AXI_HP0_rvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list S_AXI_HP0_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list S_AXI_HP0_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list S_AXI_HP0_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {pl_mem_controller/u_axim/AXI_GEN[0].u_axim/wchannel_req_buf_full}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list pl_mem_controller/wr_req]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets FCLK_CLK0]
