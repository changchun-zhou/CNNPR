`timescale 1ns/1ps
`include "common.vh"
module pl_mem_controller
#( // INPUT PARAMETERS
  parameter integer NUM_PE                            = 4,
  parameter integer NUM_PU                            = 2,
  parameter integer NUM_AXI                           = 1,
  parameter integer OP_WIDTH                          = 16,
  parameter integer AXI_DATA_W                        = 64,
  parameter integer ADDR_W                            = 32,
  parameter integer BASE_ADDR_W                       = ADDR_W,
  parameter integer OFFSET_ADDR_W                     = ADDR_W,
  parameter integer RD_LOOP_W                         = 32,
  parameter integer TX_SIZE_WIDTH                     = 10,
  parameter integer D_TYPE_W                          = 2,
  parameter integer ROM_ADDR_W                        = 2,
  parameter integer ARUSER_W                          = 2,
  parameter integer RUSER_W                           = 2,
  parameter integer BUSER_W                           = 2,
  parameter integer AWUSER_W                          = 2,
  parameter integer WUSER_W                           = 2,
  parameter integer TID_WIDTH                         = 6,
  parameter integer AXI_RD_BUFFER_W                   = 6
)( // PORTS
  input  wire                                         clk,
  input  wire                                         reset,
 // input  wire                                         start,
 // output wire                                         done,

  // Master Interface Write Address
  output wire                                         [ NUM_AXI*TID_WIDTH    -1 : 0 ]        M_AXI_AWID,
  output wire                                         [ NUM_AXI*ADDR_W       -1 : 0 ]        M_AXI_AWADDR,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_AWLEN,
  output wire                                         [ NUM_AXI*3            -1 : 0 ]        M_AXI_AWSIZE,
  output wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_AWBURST,
  output wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_AWLOCK,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_AWCACHE,
  output wire                                         [ NUM_AXI*3            -1 : 0 ]        M_AXI_AWPROT,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_AWQOS,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_AWVALID,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_AWREADY,

  // Master Interface Write Data
  output wire                                         [ NUM_AXI*TID_WIDTH    -1 : 0 ]        M_AXI_WID,
  output wire                                         [ NUM_AXI*AXI_DATA_W   -1 : 0 ]        M_AXI_WDATA,
  output wire                                         [ NUM_AXI*WSTRB_W      -1 : 0 ]        M_AXI_WSTRB,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_WLAST,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_WVALID,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_WREADY,

  // Master Interface Write Response
  input  wire                                         [ NUM_AXI*TID_WIDTH    -1 : 0 ]        M_AXI_BID,
  input  wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_BRESP,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_BVALID,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_BREADY,

  // Master Interface Read Address
  output wire                                         [ NUM_AXI*TID_WIDTH    -1 : 0 ]        M_AXI_ARID,
  output                                          [ NUM_AXI*ADDR_W       -1 : 0 ]        M_AXI_ARADDR,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_ARLEN,
  output wire                                         [ NUM_AXI*3            -1 : 0 ]        M_AXI_ARSIZE,
  output wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_ARBURST,
  output wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_ARLOCK,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_ARCACHE,
  output wire                                         [ NUM_AXI*3            -1 : 0 ]        M_AXI_ARPROT,
  output wire                                         [ NUM_AXI*4            -1 : 0 ]        M_AXI_ARQOS,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_ARVALID,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_ARREADY,

  // Master Interface Read Data
  input  wire                                         [ NUM_AXI*TID_WIDTH    -1 : 0 ]        M_AXI_RID,
  input                                               [ NUM_AXI*AXI_DATA_W   -1 : 0 ]        M_AXI_RDATA,
  input  wire                                         [ NUM_AXI*2            -1 : 0 ]        M_AXI_RRESP,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_RLAST,
  input  wire  [ NUM_AXI              -1 : 0 ]        M_AXI_RVALID,
  output wire  [ NUM_AXI              -1 : 0 ]        M_AXI_RREADY,
  input                                               rd_req,
  input                                               wr_req_w
  );
 

//    (*mark_debug = "true"*) wire  [ NUM_AXI*AXI_DATA_W   -1 : 0 ]        M_AXI_RDATA;
    (*mark_debug = "true"*) wire  [ NUM_AXI*ADDR_W       -1 : 0 ]        M_AXI_ARADDR;
    (*mark_debug = "true"*) wire  [ NUM_AXI*ADDR_W       -1 : 0 ]        M_AXI_AWADDR;
    (*mark_debug = "true"*) wire  [ AXI_DATA_W           -1 : 0 ]        axi_rd_buffer_data_in;
    (*mark_debug = "true"*) wire                                         axi_rd_buffer_push;
    (*mark_debug = "true"*) wire                                              rd_ready;


// ******************************************************************
// LOCALPARAMS
// ******************************************************************
  localparam integer WSTRB_W = AXI_DATA_W/8;
  localparam integer PU_DATA_W = OP_WIDTH * NUM_PE;
  localparam integer STREAM_PU_DATA_W = OP_WIDTH * NUM_PE * NUM_PU;
  localparam integer OUTBUF_DATA_W = PU_DATA_W * NUM_PU;
  localparam integer AXI_OUT_DATA_W = AXI_DATA_W * NUM_PU;
  localparam integer PU_ID_W = `C_LOG_2(NUM_PU)+1;
// ******************************************************************
// WIRES
// ******************************************************************
  reg  [ 32                   -1 : 0 ]        inbuf_push_count;
  wire [ AXI_OUT_DATA_W       -1 : 0 ]        outbuf_data_out;
  wire [ AXI_DATA_W           -1 : 0 ]        inbuf_data_in;

   (*mark_debug = "true"*) wire                                        read_full;
  // Memory Controller Interface
   (*mark_debug = "true"*) wire                                        rd_req;
   reg  wr_req_reg;
   (*mark_debug = "true"*) wire                                        wr_req;
   assign wr_req = wr_req_reg;
   (*mark_debug = "true"*) wire                                        rd_ready;
  (*mark_debug = "true"*)  wire                                        axi_rd_ready;
  (*mark_debug = "true"*)  wire [ TX_SIZE_WIDTH        -1 : 0 ]        rd_req_size;
   (*mark_debug = "true"*) wire [ TX_SIZE_WIDTH        -1 : 0 ]        rd_rvalid_size;
   (*mark_debug = "true"*) wire [ ADDR_W               -1 : 0 ]        rd_addr;

  //wire [ RD_LOOP_W            -1 : 0 ]        buffer_pu_id;
  wire [ D_TYPE_W             -1 : 0 ]        d_type;

  wire [PU_ID_W-1:0] wr_pu_id;
  wire [PU_ID_W-1:0] pu_id;
  wire                                        wr_ready;
  wire [ ADDR_W               -1 : 0 ]        wr_addr;
  wire [ TX_SIZE_WIDTH        -1 : 0 ]        wr_req_size;
  wire                                        wr_done;

  wire [ NUM_PU               -1 : 0 ]        outbuf_empty;
  wire [ NUM_PU               -1 : 0 ]        write_valid;
  wire [ NUM_PU               -1 : 0 ]        outbuf_pop;

  assign M_AXI_AWUSER = 0;
  assign M_AXI_WUSER = 0;
  assign M_AXI_ARUSER = 0;
// ==================================================================
  axi_master_wrapper
  #(
    .AXI_DATA_W               ( AXI_DATA_W               ),
    .ADDR_W                   ( ADDR_W                   ),
    .TX_SIZE_WIDTH            ( TX_SIZE_WIDTH            ),
    .NUM_AXI                  ( NUM_AXI                  ),
    .NUM_PU                   ( NUM_PU                   )
  )
  u_axim
  (
    .clk                      ( clk                      ),
    .reset                    ( reset                    ),

    .M_AXI_AWID               ( M_AXI_AWID               ),
    .M_AXI_AWADDR             ( M_AXI_AWADDR             ),
    .M_AXI_AWLEN              ( M_AXI_AWLEN              ),
    .M_AXI_AWSIZE             ( M_AXI_AWSIZE             ),
    .M_AXI_AWBURST            ( M_AXI_AWBURST            ),
    .M_AXI_AWLOCK             ( M_AXI_AWLOCK             ),
    .M_AXI_AWCACHE            ( M_AXI_AWCACHE            ),
    .M_AXI_AWPROT             ( M_AXI_AWPROT             ),
    .M_AXI_AWQOS              ( M_AXI_AWQOS              ),
    .M_AXI_AWVALID            ( M_AXI_AWVALID            ),
    .M_AXI_AWREADY            ( M_AXI_AWREADY            ),
    .M_AXI_WID                ( M_AXI_WID                ),
    .M_AXI_WDATA              ( M_AXI_WDATA              ),
    .M_AXI_WSTRB              ( M_AXI_WSTRB              ),
    .M_AXI_WLAST              ( M_AXI_WLAST              ),
    .M_AXI_WVALID             ( M_AXI_WVALID             ),
    .M_AXI_WREADY             ( M_AXI_WREADY             ),
    .M_AXI_BID                ( M_AXI_BID                ),
    .M_AXI_BRESP              ( M_AXI_BRESP              ),
    .M_AXI_BVALID             ( M_AXI_BVALID             ),
    .M_AXI_BREADY             ( M_AXI_BREADY             ),
    .M_AXI_ARID               ( M_AXI_ARID               ),
    .M_AXI_ARADDR             ( M_AXI_ARADDR             ),
    .M_AXI_ARLEN              ( M_AXI_ARLEN              ),
    .M_AXI_ARSIZE             ( M_AXI_ARSIZE             ),
    .M_AXI_ARBURST            ( M_AXI_ARBURST            ),
    .M_AXI_ARLOCK             ( M_AXI_ARLOCK             ),
    .M_AXI_ARCACHE            ( M_AXI_ARCACHE            ),
    .M_AXI_ARPROT             ( M_AXI_ARPROT             ),
    .M_AXI_ARQOS              ( M_AXI_ARQOS              ),
    .M_AXI_ARVALID            ( M_AXI_ARVALID            ),
    .M_AXI_ARREADY            ( M_AXI_ARREADY            ),
    .M_AXI_RID                ( M_AXI_RID                ),
    .M_AXI_RDATA              ( M_AXI_RDATA              ),
    .M_AXI_RRESP              ( M_AXI_RRESP              ),
    .M_AXI_RLAST              ( M_AXI_RLAST              ),
    .M_AXI_RVALID             ( M_AXI_RVALID             ),
    .M_AXI_RREADY             ( M_AXI_RREADY             ),

    .outbuf_empty             ( outbuf_empty             ),//not used
    .outbuf_pop               ( outbuf_pop               ),//output
    .data_from_outbuf         ( outbuf_data_out          ),//write

    .data_to_inbuf            ( axi_rd_buffer_data_in    ),//output
    .inbuf_push               ( axi_rd_buffer_push       ),//output
    .inbuf_full               ( read_full                ),//input 

    .rd_req                   ( rd_req                   ),//in
    .rd_ready                 ( axi_rd_ready             ),//output
    .rd_req_size              ( rd_req_size              ),//in
    .rd_addr                  ( rd_addr                  ),//in

    .wr_req                   ( wr_req                   ),
    .wr_pu_id                 ( wr_pu_id                 ),
    .wr_done                  ( wr_done                  ),//output
    .wr_ready                 ( wr_ready                 ),
    .wr_req_size              ( wr_req_size              ),
    .wr_addr                  ( wr_addr                  ),
    .write_valid              ( write_valid              )
  );
// ==================================================================
//assign wr_req = 0;
reg  [5:0] count;
always @(posedge clk) begin
  if (reset) begin
    // reset
    wr_req_reg <= 0;  
    count <= 0;
  end
  else wr_req_reg <= 0;
end

assign read_full = 0;
assign rd_req_size = 1000;
//assign rd_addr = 32'b0000_1000_0000_0000_0000_0000_0000_0000;
assign rd_addr = 32'h08000000;
//====================================================================
//assign outbuf_empty = 0;
assign outbuf_data_out = 1;

assign wr_pu_id = 0;
assign wr_req_size = 1000;
assign wr_addr = 32'h08000000;
assign write_valid = 2'b11;

endmodule // pl_mem_controller