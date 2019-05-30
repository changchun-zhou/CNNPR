//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Fri Mar 15 17:25:27 2019
//Host        : DESKTOP-K4PJT3U running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
 //   FCLK_CLK0,
 //   FCLK_RESET0_N,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    rd_req);
  input wire rd_req;
  (*mark_debug = "true"*) wire  [ 64   -1 : 0 ] S_AXI_HP0_rdata;
  (*mark_debug = "true"*) wire                  FCLK_CLK0;
  (*mark_debug = "true"*) wire                  FCLK_RESET0_N;
  pl_mem_controller pl_mem_controller (
    .clk(FCLK_CLK0),
    .reset(!FCLK_RESET0_N),
    .rd_req(rd_req),
    .M_AXI_ARADDR  (S_AXI_HP0_araddr ) ,
    .M_AXI_ARBURST (S_AXI_HP0_arburst) ,
    .M_AXI_ARCACHE (S_AXI_HP0_arcache) ,
    .M_AXI_ARID    (S_AXI_HP0_arid   ) ,
    .M_AXI_ARLEN   (S_AXI_HP0_arlen  ) ,
    .M_AXI_ARLOCK  (S_AXI_HP0_arlock ) ,
    .M_AXI_ARPROT  (S_AXI_HP0_arprot ) ,
    .M_AXI_ARQOS   (S_AXI_HP0_arqos  ) ,
    .M_AXI_ARREADY (S_AXI_HP0_arready) ,
    .M_AXI_ARSIZE  (S_AXI_HP0_arsize ) ,
    .M_AXI_ARVALID (S_AXI_HP0_arvalid) ,
    .M_AXI_AWADDR  (S_AXI_HP0_awaddr ) ,
    .M_AXI_AWBURST (S_AXI_HP0_awburst) ,
    .M_AXI_AWCACHE (S_AXI_HP0_awcache) ,
    .M_AXI_AWID    (S_AXI_HP0_awid   ) ,
    .M_AXI_AWLEN   (S_AXI_HP0_awlen  ) ,
    .M_AXI_AWLOCK  (S_AXI_HP0_awlock ) ,
    .M_AXI_AWPROT  (S_AXI_HP0_awprot ) ,
    .M_AXI_AWQOS   (S_AXI_HP0_awqos  ) ,
    .M_AXI_AWREADY (S_AXI_HP0_awready) ,
    .M_AXI_AWSIZE  (S_AXI_HP0_awsize ) ,
    .M_AXI_AWVALID (S_AXI_HP0_awvalid) ,
    .M_AXI_BID     (S_AXI_HP0_bid    ) ,
    .M_AXI_BREADY  (S_AXI_HP0_bready ) ,
    .M_AXI_BRESP   (S_AXI_HP0_bresp  ) ,
    .M_AXI_BVALID  (S_AXI_HP0_bvalid ) ,
    .M_AXI_RDATA   (S_AXI_HP0_rdata  ) ,
    .M_AXI_RID     (S_AXI_HP0_rid    ) ,
    .M_AXI_RLAST   (S_AXI_HP0_rlast  ) ,
    .M_AXI_RREADY  (S_AXI_HP0_rready ) ,
    .M_AXI_RRESP   (S_AXI_HP0_rresp  ) ,
    .M_AXI_RVALID  (S_AXI_HP0_rvalid ) ,
    .M_AXI_WDATA   (S_AXI_HP0_wdata  ) ,
    .M_AXI_WID     (S_AXI_HP0_wid    ) ,
    .M_AXI_WLAST   (S_AXI_HP0_wlast  ) ,
    .M_AXI_WREADY  (S_AXI_HP0_wready ) ,
    .M_AXI_WSTRB   (S_AXI_HP0_wstrb  ) ,
    .M_AXI_WVALID  (S_AXI_HP0_wvalid ) 
    );

  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
//  output FCLK_CLK0;
//  output FCLK_RESET0_N;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FCLK_CLK0;
  wire FCLK_RESET0_N;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire debug_clk;
  design_1 design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(FCLK_CLK0), //output
        .FCLK_RESET0_N(FCLK_RESET0_N),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .S_AXI_HP0_araddr(S_AXI_HP0_araddr),
        .S_AXI_HP0_arburst(S_AXI_HP0_arburst),
        .S_AXI_HP0_arcache(S_AXI_HP0_arcache),
        .S_AXI_HP0_arid(S_AXI_HP0_arid),
        .S_AXI_HP0_arlen(S_AXI_HP0_arlen),
        .S_AXI_HP0_arlock(S_AXI_HP0_arlock),
        .S_AXI_HP0_arprot(S_AXI_HP0_arprot),
        .S_AXI_HP0_arqos(S_AXI_HP0_arqos),
        .S_AXI_HP0_arready(S_AXI_HP0_arready),
        .S_AXI_HP0_arsize(S_AXI_HP0_arsize),
        .S_AXI_HP0_arvalid(S_AXI_HP0_arvalid),
        .S_AXI_HP0_awaddr(S_AXI_HP0_awaddr),
        .S_AXI_HP0_awburst(S_AXI_HP0_awburst),
        .S_AXI_HP0_awcache(S_AXI_HP0_awcache),
        .S_AXI_HP0_awid(S_AXI_HP0_awid),
        .S_AXI_HP0_awlen(S_AXI_HP0_awlen),
        .S_AXI_HP0_awlock(S_AXI_HP0_awlock),
        .S_AXI_HP0_awprot(S_AXI_HP0_awprot),
        .S_AXI_HP0_awqos(S_AXI_HP0_awqos),
        .S_AXI_HP0_awready(S_AXI_HP0_awready),
        .S_AXI_HP0_awsize(S_AXI_HP0_awsize),
        .S_AXI_HP0_awvalid(S_AXI_HP0_awvalid),
        .S_AXI_HP0_bid(S_AXI_HP0_bid),
        .S_AXI_HP0_bready(S_AXI_HP0_bready),
        .S_AXI_HP0_bresp(S_AXI_HP0_bresp),
        .S_AXI_HP0_bvalid(S_AXI_HP0_bvalid),
        .S_AXI_HP0_rdata(S_AXI_HP0_rdata),
        .S_AXI_HP0_rid(S_AXI_HP0_rid),
        .S_AXI_HP0_rlast(S_AXI_HP0_rlast),
        .S_AXI_HP0_rready(S_AXI_HP0_rready),
        .S_AXI_HP0_rresp(S_AXI_HP0_rresp),
        .S_AXI_HP0_rvalid(S_AXI_HP0_rvalid),
        .S_AXI_HP0_wdata(S_AXI_HP0_wdata),
        .S_AXI_HP0_wid(S_AXI_HP0_wid),
        .S_AXI_HP0_wlast(S_AXI_HP0_wlast),
        .S_AXI_HP0_wready(S_AXI_HP0_wready),
        .S_AXI_HP0_wstrb(S_AXI_HP0_wstrb),
        .S_AXI_HP0_wvalid(S_AXI_HP0_wvalid),
        .debug_clk(debug_clk));
endmodule
