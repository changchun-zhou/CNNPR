//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Fri Mar 15 17:25:26 2019
//Host        : DESKTOP-K4PJT3U running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_ps7_cnt=1,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
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
    FCLK_CLK0,
    FCLK_RESET0_N,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    S_AXI_HP0_araddr,
    S_AXI_HP0_arburst,
    S_AXI_HP0_arcache,
    S_AXI_HP0_arid,
    S_AXI_HP0_arlen,
    S_AXI_HP0_arlock,
    S_AXI_HP0_arprot,
    S_AXI_HP0_arqos,
    S_AXI_HP0_arready,
    S_AXI_HP0_arsize,
    S_AXI_HP0_arvalid,
    S_AXI_HP0_awaddr,
    S_AXI_HP0_awburst,
    S_AXI_HP0_awcache,
    S_AXI_HP0_awid,
    S_AXI_HP0_awlen,
    S_AXI_HP0_awlock,
    S_AXI_HP0_awprot,
    S_AXI_HP0_awqos,
    S_AXI_HP0_awready,
    S_AXI_HP0_awsize,
    S_AXI_HP0_awvalid,
    S_AXI_HP0_bid,
    S_AXI_HP0_bready,
    S_AXI_HP0_bresp,
    S_AXI_HP0_bvalid,
    S_AXI_HP0_rdata,
    S_AXI_HP0_rid,
    S_AXI_HP0_rlast,
    S_AXI_HP0_rready,
    S_AXI_HP0_rresp,
    S_AXI_HP0_rvalid,
    S_AXI_HP0_wdata,
    S_AXI_HP0_wid,
    S_AXI_HP0_wlast,
    S_AXI_HP0_wready,
    S_AXI_HP0_wstrb,
    S_AXI_HP0_wvalid);
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
  output FCLK_CLK0;
  output FCLK_RESET0_N;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [31:0]S_AXI_HP0_araddr;
  input [1:0]S_AXI_HP0_arburst;
  input [3:0]S_AXI_HP0_arcache;
  input [5:0]S_AXI_HP0_arid;
  input [3:0]S_AXI_HP0_arlen;
  input [1:0]S_AXI_HP0_arlock;
  input [2:0]S_AXI_HP0_arprot;
  input [3:0]S_AXI_HP0_arqos;
  output S_AXI_HP0_arready;
  input [2:0]S_AXI_HP0_arsize;
  input S_AXI_HP0_arvalid;
  input [31:0]S_AXI_HP0_awaddr;
  input [1:0]S_AXI_HP0_awburst;
  input [3:0]S_AXI_HP0_awcache;
  input [5:0]S_AXI_HP0_awid;
  input [3:0]S_AXI_HP0_awlen;
  input [1:0]S_AXI_HP0_awlock;
  input [2:0]S_AXI_HP0_awprot;
  input [3:0]S_AXI_HP0_awqos;
  output S_AXI_HP0_awready;
  input [2:0]S_AXI_HP0_awsize;
  input S_AXI_HP0_awvalid;
  output [5:0]S_AXI_HP0_bid;
  input S_AXI_HP0_bready;
  output [1:0]S_AXI_HP0_bresp;
  output S_AXI_HP0_bvalid;
  output [63:0]S_AXI_HP0_rdata;
  output [5:0]S_AXI_HP0_rid;
  output S_AXI_HP0_rlast;
  input S_AXI_HP0_rready;
  output [1:0]S_AXI_HP0_rresp;
  output S_AXI_HP0_rvalid;
  input [63:0]S_AXI_HP0_wdata;
  input [5:0]S_AXI_HP0_wid;
  input S_AXI_HP0_wlast;
  output S_AXI_HP0_wready;
  input [7:0]S_AXI_HP0_wstrb;
  input S_AXI_HP0_wvalid;

  wire Net;
  wire [31:0]S_AXI_HP0_1_ARADDR;
  wire [1:0]S_AXI_HP0_1_ARBURST;
  wire [3:0]S_AXI_HP0_1_ARCACHE;
  wire [5:0]S_AXI_HP0_1_ARID;
  wire [3:0]S_AXI_HP0_1_ARLEN;
  wire [1:0]S_AXI_HP0_1_ARLOCK;
  wire [2:0]S_AXI_HP0_1_ARPROT;
  wire [3:0]S_AXI_HP0_1_ARQOS;
  wire S_AXI_HP0_1_ARREADY;
  wire [2:0]S_AXI_HP0_1_ARSIZE;
  wire S_AXI_HP0_1_ARVALID;
  wire [31:0]S_AXI_HP0_1_AWADDR;
  wire [1:0]S_AXI_HP0_1_AWBURST;
  wire [3:0]S_AXI_HP0_1_AWCACHE;
  wire [5:0]S_AXI_HP0_1_AWID;
  wire [3:0]S_AXI_HP0_1_AWLEN;
  wire [1:0]S_AXI_HP0_1_AWLOCK;
  wire [2:0]S_AXI_HP0_1_AWPROT;
  wire [3:0]S_AXI_HP0_1_AWQOS;
  wire S_AXI_HP0_1_AWREADY;
  wire [2:0]S_AXI_HP0_1_AWSIZE;
  wire S_AXI_HP0_1_AWVALID;
  wire [5:0]S_AXI_HP0_1_BID;
  wire S_AXI_HP0_1_BREADY;
  wire [1:0]S_AXI_HP0_1_BRESP;
  wire S_AXI_HP0_1_BVALID;
  wire [63:0]S_AXI_HP0_1_RDATA;
  wire [5:0]S_AXI_HP0_1_RID;
  wire S_AXI_HP0_1_RLAST;
  wire S_AXI_HP0_1_RREADY;
  wire [1:0]S_AXI_HP0_1_RRESP;
  wire S_AXI_HP0_1_RVALID;
  wire [63:0]S_AXI_HP0_1_WDATA;
  wire [5:0]S_AXI_HP0_1_WID;
  wire S_AXI_HP0_1_WLAST;
  wire S_AXI_HP0_1_WREADY;
  wire [7:0]S_AXI_HP0_1_WSTRB;
  wire S_AXI_HP0_1_WVALID;
  wire [14:0]processing_system7_0_DDR_ADDR;
  wire [2:0]processing_system7_0_DDR_BA;
  wire processing_system7_0_DDR_CAS_N;
  wire processing_system7_0_DDR_CKE;
  wire processing_system7_0_DDR_CK_N;
  wire processing_system7_0_DDR_CK_P;
  wire processing_system7_0_DDR_CS_N;
  wire [3:0]processing_system7_0_DDR_DM;
  wire [31:0]processing_system7_0_DDR_DQ;
  wire [3:0]processing_system7_0_DDR_DQS_N;
  wire [3:0]processing_system7_0_DDR_DQS_P;
  wire processing_system7_0_DDR_ODT;
  wire processing_system7_0_DDR_RAS_N;
  wire processing_system7_0_DDR_RESET_N;
  wire processing_system7_0_DDR_WE_N;
  wire processing_system7_0_FCLK_RESET0_N;
  wire processing_system7_0_FIXED_IO_DDR_VRN;
  wire processing_system7_0_FIXED_IO_DDR_VRP;
  wire [53:0]processing_system7_0_FIXED_IO_MIO;
  wire processing_system7_0_FIXED_IO_PS_CLK;
  wire processing_system7_0_FIXED_IO_PS_PORB;
  wire processing_system7_0_FIXED_IO_PS_SRSTB;

  assign FCLK_CLK0 = Net;
  assign FCLK_RESET0_N = processing_system7_0_FCLK_RESET0_N;
  assign S_AXI_HP0_1_ARADDR = S_AXI_HP0_araddr[31:0];
  assign S_AXI_HP0_1_ARBURST = S_AXI_HP0_arburst[1:0];
  assign S_AXI_HP0_1_ARCACHE = S_AXI_HP0_arcache[3:0];
  assign S_AXI_HP0_1_ARID = S_AXI_HP0_arid[5:0];
  assign S_AXI_HP0_1_ARLEN = S_AXI_HP0_arlen[3:0];
  assign S_AXI_HP0_1_ARLOCK = S_AXI_HP0_arlock[1:0];
  assign S_AXI_HP0_1_ARPROT = S_AXI_HP0_arprot[2:0];
  assign S_AXI_HP0_1_ARQOS = S_AXI_HP0_arqos[3:0];
  assign S_AXI_HP0_1_ARSIZE = S_AXI_HP0_arsize[2:0];
  assign S_AXI_HP0_1_ARVALID = S_AXI_HP0_arvalid;
  assign S_AXI_HP0_1_AWADDR = S_AXI_HP0_awaddr[31:0];
  assign S_AXI_HP0_1_AWBURST = S_AXI_HP0_awburst[1:0];
  assign S_AXI_HP0_1_AWCACHE = S_AXI_HP0_awcache[3:0];
  assign S_AXI_HP0_1_AWID = S_AXI_HP0_awid[5:0];
  assign S_AXI_HP0_1_AWLEN = S_AXI_HP0_awlen[3:0];
  assign S_AXI_HP0_1_AWLOCK = S_AXI_HP0_awlock[1:0];
  assign S_AXI_HP0_1_AWPROT = S_AXI_HP0_awprot[2:0];
  assign S_AXI_HP0_1_AWQOS = S_AXI_HP0_awqos[3:0];
  assign S_AXI_HP0_1_AWSIZE = S_AXI_HP0_awsize[2:0];
  assign S_AXI_HP0_1_AWVALID = S_AXI_HP0_awvalid;
  assign S_AXI_HP0_1_BREADY = S_AXI_HP0_bready;
  assign S_AXI_HP0_1_RREADY = S_AXI_HP0_rready;
  assign S_AXI_HP0_1_WDATA = S_AXI_HP0_wdata[63:0];
  assign S_AXI_HP0_1_WID = S_AXI_HP0_wid[5:0];
  assign S_AXI_HP0_1_WLAST = S_AXI_HP0_wlast;
  assign S_AXI_HP0_1_WSTRB = S_AXI_HP0_wstrb[7:0];
  assign S_AXI_HP0_1_WVALID = S_AXI_HP0_wvalid;
  assign S_AXI_HP0_arready = S_AXI_HP0_1_ARREADY;
  assign S_AXI_HP0_awready = S_AXI_HP0_1_AWREADY;
  assign S_AXI_HP0_bid[5:0] = S_AXI_HP0_1_BID;
  assign S_AXI_HP0_bresp[1:0] = S_AXI_HP0_1_BRESP;
  assign S_AXI_HP0_bvalid = S_AXI_HP0_1_BVALID;
  assign S_AXI_HP0_rdata[63:0] = S_AXI_HP0_1_RDATA;
  assign S_AXI_HP0_rid[5:0] = S_AXI_HP0_1_RID;
  assign S_AXI_HP0_rlast = S_AXI_HP0_1_RLAST;
  assign S_AXI_HP0_rresp[1:0] = S_AXI_HP0_1_RRESP;
  assign S_AXI_HP0_rvalid = S_AXI_HP0_1_RVALID;
  assign S_AXI_HP0_wready = S_AXI_HP0_1_WREADY;
  design_1_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(processing_system7_0_FCLK_RESET0_N),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(Net));
  design_1_processing_system7_0_0 processing_system7_0
       (.DDR_Addr(DDR_addr[14:0]),
        .DDR_BankAddr(DDR_ba[2:0]),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm[3:0]),
        .DDR_DQ(DDR_dq[31:0]),
        .DDR_DQS(DDR_dqs_p[3:0]),
        .DDR_DQS_n(DDR_dqs_n[3:0]),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .FCLK_CLK0(Net),
        .FCLK_RESET0_N(processing_system7_0_FCLK_RESET0_N),
        .MIO(FIXED_IO_mio[53:0]),
        .M_AXI_GP0_ACLK(Net),
        .M_AXI_GP0_ARREADY(1'b0),
        .M_AXI_GP0_AWREADY(1'b0),
        .M_AXI_GP0_BID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_BRESP({1'b0,1'b0}),
        .M_AXI_GP0_BVALID(1'b0),
        .M_AXI_GP0_RDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_RID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_GP0_RLAST(1'b0),
        .M_AXI_GP0_RRESP({1'b0,1'b0}),
        .M_AXI_GP0_RVALID(1'b0),
        .M_AXI_GP0_WREADY(1'b0),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .S_AXI_HP0_ACLK(Net),
        .S_AXI_HP0_ARADDR(S_AXI_HP0_1_ARADDR),
        .S_AXI_HP0_ARBURST(S_AXI_HP0_1_ARBURST),
        .S_AXI_HP0_ARCACHE(S_AXI_HP0_1_ARCACHE),
        .S_AXI_HP0_ARID(S_AXI_HP0_1_ARID),
        .S_AXI_HP0_ARLEN(S_AXI_HP0_1_ARLEN),
        .S_AXI_HP0_ARLOCK(S_AXI_HP0_1_ARLOCK),
        .S_AXI_HP0_ARPROT(S_AXI_HP0_1_ARPROT),
        .S_AXI_HP0_ARQOS(S_AXI_HP0_1_ARQOS),
        .S_AXI_HP0_ARREADY(S_AXI_HP0_1_ARREADY),
        .S_AXI_HP0_ARSIZE(S_AXI_HP0_1_ARSIZE),
        .S_AXI_HP0_ARVALID(S_AXI_HP0_1_ARVALID),
        .S_AXI_HP0_AWADDR(S_AXI_HP0_1_AWADDR),
        .S_AXI_HP0_AWBURST(S_AXI_HP0_1_AWBURST),
        .S_AXI_HP0_AWCACHE(S_AXI_HP0_1_AWCACHE),
        .S_AXI_HP0_AWID(S_AXI_HP0_1_AWID),
        .S_AXI_HP0_AWLEN(S_AXI_HP0_1_AWLEN),
        .S_AXI_HP0_AWLOCK(S_AXI_HP0_1_AWLOCK),
        .S_AXI_HP0_AWPROT(S_AXI_HP0_1_AWPROT),
        .S_AXI_HP0_AWQOS(S_AXI_HP0_1_AWQOS),
        .S_AXI_HP0_AWREADY(S_AXI_HP0_1_AWREADY),
        .S_AXI_HP0_AWSIZE(S_AXI_HP0_1_AWSIZE),
        .S_AXI_HP0_AWVALID(S_AXI_HP0_1_AWVALID),
        .S_AXI_HP0_BID(S_AXI_HP0_1_BID),
        .S_AXI_HP0_BREADY(S_AXI_HP0_1_BREADY),
        .S_AXI_HP0_BRESP(S_AXI_HP0_1_BRESP),
        .S_AXI_HP0_BVALID(S_AXI_HP0_1_BVALID),
        .S_AXI_HP0_RDATA(S_AXI_HP0_1_RDATA),
        .S_AXI_HP0_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP0_RID(S_AXI_HP0_1_RID),
        .S_AXI_HP0_RLAST(S_AXI_HP0_1_RLAST),
        .S_AXI_HP0_RREADY(S_AXI_HP0_1_RREADY),
        .S_AXI_HP0_RRESP(S_AXI_HP0_1_RRESP),
        .S_AXI_HP0_RVALID(S_AXI_HP0_1_RVALID),
        .S_AXI_HP0_WDATA(S_AXI_HP0_1_WDATA),
        .S_AXI_HP0_WID(S_AXI_HP0_1_WID),
        .S_AXI_HP0_WLAST(S_AXI_HP0_1_WLAST),
        .S_AXI_HP0_WREADY(S_AXI_HP0_1_WREADY),
        .S_AXI_HP0_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP0_WSTRB(S_AXI_HP0_1_WSTRB),
        .S_AXI_HP0_WVALID(S_AXI_HP0_1_WVALID),
        .USB0_VBUS_PWRFAULT(1'b0));
endmodule
