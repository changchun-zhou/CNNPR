 `timescale 1 ps / 1 ps

 module pl_mem_controller #(
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ADDR_WIDTH = 32,
    parameter C_OFFSET_WIDTH = 10,
    parameter TX_SIZE_WIDTH  = 10,
    parameter RD_RQ_WIDTH = AXI_ADDR_WIDTH + C_OFFSET_WIDTH
    
    endpackage
    )(
    clk,
    rst_n,
    M_AXI_HP0_araddr,
    M_AXI_HP0_arburst,
    M_AXI_HP0_arcache,
    M_AXI_HP0_arid,
    M_AXI_HP0_arlen,
    M_AXI_HP0_arlock,
    M_AXI_HP0_arprot,
    M_AXI_HP0_arqos,
    M_AXI_HP0_arready,
    M_AXI_HP0_arsize,
    M_AXI_HP0_arvalid,
    M_AXI_HP0_awaddr,
    M_AXI_HP0_awburst,
    M_AXI_HP0_awcache,
    M_AXI_HP0_awid,
    M_AXI_HP0_awlen,
    M_AXI_HP0_awlock,
    M_AXI_HP0_awprot,
    M_AXI_HP0_awqos,
    M_AXI_HP0_awready,
    M_AXI_HP0_awsize,
    M_AXI_HP0_awvalid,
    M_AXI_HP0_bid,
    M_AXI_HP0_bready,
    M_AXI_HP0_bresp,
    M_AXI_HP0_bvalid,
    M_AXI_HP0_rdata,
    M_AXI_HP0_rid,
    M_AXI_HP0_rlast,
    M_AXI_HP0_rready,
    M_AXI_HP0_rresp,
    M_AXI_HP0_rvalid,
    M_AXI_HP0_wdata,
    M_AXI_HP0_wid,
    M_AXI_HP0_wlast,
    M_AXI_HP0_wready,
    M_AXI_HP0_wstrb,
    M_AXI_HP0_wvalid);

  input     clk;
  input     rst_n;
  //
  output [31:0]M_AXI_HP0_araddr;//transfer address
  reg [C_OFFSET_WIDTH-1:0]                    araddr_offset = 'b0;
  wire [ AXI_ADDR_WIDTH       -1 : 0 ]        rx_addr_buf;
  assign M_AXI_HP0_araddr = {rx_addr_buf[AXI_ADDR_WIDTH-1:C_OFFSET_WIDTH], araddr_offset};

  output [1:0]M_AXI_HP0_arburst;//burst定义地址怎么变的
  assign M_AXI_HP0_arburst = 2'b01;  //INCR
  output [3:0]M_AXI_HP0_arcache;
  assign M_AXI_HP0_arcache = 4'b1111;//???
  output [5:0]M_AXI_HP0_arid;
  assign M_AXI_HP0_arid = 'b0; //ID Tag
  output [3:0]M_AXI_HP0_arlen;//读写的长度字段，arlen + 1
  assign M_AXI_HP0_arlen = arlen; //15 //突发式写的长度。此长度决定突发式写所传输的数据的个数

  output [1:0]M_AXI_HP0_arlock;
  assign M_AXI_HP0_arlock = 2'b00;
  output [2:0]M_AXI_HP0_arprot;
  assign M_AXI_HP0_arprot = 3'h0;
  output [3:0]M_AXI_HP0_arqos;
  assign M_AXI_HP0_arqos = 4'h0;
  input M_AXI_HP0_arready;
  assign arready = M_AXI_HP0_arready[0];
  output [2:0]M_AXI_HP0_arsize;//字节数
  assign M_AXI_HP0_arsize = `C_LOG_2(AXI_DATA_WIDTH/8);//突发式写的大小。

  output M_AXI_HP0_arvalid;
  assign M_AXI_HP0_arvalid = arvalid;


  output [31:0]M_AXI_HP0_awaddr;
  output [1:0]M_AXI_HP0_awburst;
  output [3:0]M_AXI_HP0_awcache;
  output [5:0]M_AXI_HP0_awid;
  output [3:0]M_AXI_HP0_awlen;
  output [1:0]M_AXI_HP0_awlock;
  output [2:0]M_AXI_HP0_awprot;
  output [3:0]M_AXI_HP0_awqos;
  input M_AXI_HP0_awready;
  output [2:0]M_AXI_HP0_awsize;
  output M_AXI_HP0_awvalid;

  input [5:0]M_AXI_HP0_bid;//not used
  output M_AXI_HP0_bready;//
  assign M_AXI_HP0_bready = rst_n ? 1'b1 : 1'b0;
  input [1:0]M_AXI_HP0_bresp;//not used
  input M_AXI_HP0_bvalid;//not used

  input [63:0]M_AXI_HP0_rdata;
  input [5:0]M_AXI_HP0_rid;//not used
  input M_AXI_HP0_rlast;// not used
  output M_AXI_HP0_rready; //
  assign M_AXI_HP0_arready = rready ; //需要读的时候，拉高。
  input [1:0]M_AXI_HP0_rresp;//not used 
  input M_AXI_HP0_rvalid;//读到数据有效
  assign rnext = rst_n &&　M_AXI_HP0_rvalid && rready ;

  output [63:0]M_AXI_HP0_wdata;
  output [5:0]M_AXI_HP0_wid;
  output M_AXI_HP0_wlast;
  input M_AXI_HP0_wready;
  output [7:0]M_AXI_HP0_wstrb;//WDATA中哪8bit的数是有效的
  output M_AXI_HP0_wvalid;

  reg [C_OFFSET_WIDTH-1:0]                    araddr_offset = 'b0;

  reg  [ TX_SIZE_WIDTH        -1 : 0 ]        rx_size;
  wire [4-1:0] arlen = (rx_size >= 16) ? 15: (rx_size != 0) ? (rx_size-1) : 0;
  reg  [ 4                    -1 : 0 ]        arlen_d;


  reg                                           rd_req_buf_pop;
  reg                                           rd_req_buf_pop_d;

  //--------------------------------------------------------------
wire rd_req_buf_pop, rd_req_buf_push;
wire rd_req_buf_empty, rd_req_buf_full;
wire [AXI_ADDR_WIDTH+TX_SIZE_WIDTH-1:0] rd_req_buf_data_in, rd_req_buf_data_out;
  wire [ TX_SIZE_WIDTH        -1 : 0 ]        rx_req_size_buf;
  wire [ AXI_ADDR_WIDTH       -1 : 0 ]        rx_addr_buf;

assign rd_req_buf_pop       = rx_size == 0 && !rd_req_buf_empty && !rd_req_buf_pop_d;
assign rd_req_buf_push      = rd_req;
assign rd_ready = !rd_req_buf_full;
assign rd_req_buf_data_in   = {rd_req_size, rd_addr};//32 +10 = 42
assign {rx_req_size_buf, rx_addr_buf} = rd_req_buf_data_out;

always @(posedge clk)
begin
  if (~rst_n)
    rd_req_buf_pop_d <= 0;
  else
    rd_req_buf_pop_d <= rd_req_buf_pop;
    
end

  fifo #(
    .DATA_WIDTH               ( RD_RQ_WIDTH              ),
    .ADDR_WIDTH               ( 2                        )
  ) rd_req_buf (
    .clk                      ( clk                      ), //input
    .reset                    ( ~rst_n                    ), //input
    .pop                      ( rd_req_buf_pop           ), //input
    .data_out                 ( rd_req_buf_data_out      ), //output
    .empty                    ( rd_req_buf_empty         ), //output
    .push                     ( rd_req_buf_push          ), //input
    .data_in                  ( rd_req_buf_data_in       ), //input
    .full                     ( rd_req_buf_full          ), //output
    .fifo_count               (                          )  //output
  );
//--------------------------------------------------------------

always @(posedge clk)
   begin
    if (~rst_n)
       rx_size <= 0;
     //else if (rd_req)
       //    rx_size <= rx_size + rd_req_size;
    else if (rd_req_buf_pop_d)
         rx_size <= rx_size + rx_req_size_buf;//需要多少个数
    else if (arvalid && arready)
         rx_size <= rx_size - arlen - 1;//记录实际读的地址，有没有读完
     end

always @(posedge clk)
   begin
     if (~rst_n)
       arlen_d <= 0;
     else if (arvalid && arready)
       arlen_d <= arlen;
   end


always @(posedge clk)
begin
  if (~rst_n)
  begin
      araddr_offset  <= 'b0;
  end
  else if (rd_req_buf_pop_d)  //给新的基址，基址是存储于FIFO中的
  begin
    araddr_offset <= rx_addr_buf;
  end
  else if (arvalid && arready)
  begin
      araddr_offset <= araddr_offset + 'h80;//+64位 为啥 一次取16个数，对应'h80地址增加
  end
  else if (rx_size != 0)
  begin
      araddr_offset <= araddr_offset;
  end
  else
  begin
      araddr_offset <= araddr_offset;
  end
end

  reg                                         arvalid;
always @(posedge clk)
begin
  if (~rst_n)
  begin
      arvalid <= 1'b0;
  end
  else if (arvalid && arready) //1->0 0->1
  begin
      arvalid <= 1'b0;
  end
  else if (rx_size != 0)
  begin
      arvalid <= 1'b1;
  end
  else
  begin
      arvalid <= arvalid;
  end
end




