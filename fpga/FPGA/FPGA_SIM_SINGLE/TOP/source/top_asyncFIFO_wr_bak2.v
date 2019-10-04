module top_asyncFIFO_wr #(
    parameter SPI_WIDTH = 32,
    parameter ADDR_WIDTH_FIFO = 3,
    parameter TX_WIDTH = 20
    )(
    input                                   clk_chip      , //ASIC
    input                                   reset_n_chip  , //ASIC
    input                                   O_spi_sck     , //FPGA //PAD
    output [ SPI_WIDTH   -1 : 0 ]           IO_spi_data   , //FPGA //PAD
    input                                   O_spi_cs_n    , //FPGA //PAD
    output reg                              config_req    , //FPGA //PAD

    output                                  config_ready  , //ASIC
    input                                   config_paulse , //ASIC paulse
    input [ 4            -1 : 0 ]           config_data   , //ASIC
    output                                  wr_ready      , //ASIC
    input                                   wr_req        , //ASIC
    input [ SPI_WIDTH    -1 : 0 ]           wr_data         //ASIC
    );


wire                        empty         ;
wire                        full          ;
wire                        valid         ;
reg                         wr_done_wait  ;
reg                         wr_done_wait_in  ;
reg                         O_spi_cs_n_d  ;
wire                        wr_req_fifo   ;
wire                        reset_n_fifo  ;

wire                            wr_clk    ;
wire                            wr_en     ;
wire [ SPI_WIDTH      - 1 : 0 ] din       ;
wire                            rd_clk    ;
wire                            rd_en     ;
wire [ SPI_WIDTH      - 1 : 0 ] dout      ;



reg O_spi_cs_n_sync, O_spi_cs_n_2, O_spi_cs_n_1;
reg O_spi_cs_n_d_sync, O_spi_cs_n_d_2, O_spi_cs_n_d_1;

reg [ TX_WIDTH          - 1 : 0 ] wr_count;
reg [ TX_WIDTH          - 1 : 0 ] wr_count_in;
wire                        wr_done ;      
wire                        wr_done_in ;      
reg [ 3           - 1 : 0 ] state   ;            
reg                         full_d, full_dd,full_ddd;
wire                        post_full_mkup;

localparam IDLE = 0, CONFIG = 1, WAIT = 2, RD_DATA = 3,  WR_DATA = 4, RESET_FIFO = 5;


assign wr_ready = state >= CONFIG &&  ~full && ~wr_done_wait;
assign config_ready = state           == IDLE ;

always @(posedge clk_chip or negedge reset_n_chip) begin
  if(!reset_n_chip) begin
    state <= IDLE;
  end else begin
    case (state)
      IDLE    : if ( config_paulse )
                  state <= CONFIG;

      CONFIG  : state <= WAIT;

      WAIT    : if (!O_spi_cs_n_sync) //
                  state <= WR_DATA;

      WR_DATA : if( O_spi_cs_n_d_sync && O_spi_cs_n_sync ) //avoid ahead to RESET_FIFO(near O_spi_cs_n_d_sync pull_down)
                  state <= RESET_FIFO;

      RESET_FIFO: state <= IDLE;
    endcase
  end
end

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_config_req
  if(!reset_n_chip) begin
    config_req <= 0;
  end else if( state == CONFIG )begin //paulse
    config_req <= 1;
  end else if( state == WR_DATA )begin//
    config_req <= 0;
  end else
     config_req <= config_req; 
end

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_wr_count
  if(~reset_n_chip) begin
    wr_count <= 0;
  end else if( wr_done_wait ) begin
    wr_count <= 0;
  end else if( wr_ready) begin
    wr_count <= wr_count + 1;
  end else 
    wr_count <= wr_count;
end

// assign wr_done = wr_count == 2*32 -1;//pull down wr_ready: 32bx64/64

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_wr_done_wait
    if(~reset_n_chip) begin
        wr_done_wait <= 0;
    end else if( wr_count >= 2*32 -1 && ~full)begin
        wr_done_wait <= 1; //Control wr_ready
    end else if( state == IDLE ) begin
        wr_done_wait <= 0;
    end
end

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_wr_count_in
  if(~reset_n_chip) begin
    wr_count_in <= 0;
  end else if( wr_done_wait_in ) begin
    wr_count_in <= 0;
  end else if( wr_en && ~full) begin // really write into FIFO
    wr_count_in <= wr_count_in + 1;
  end else 
    wr_count_in <= wr_count_in;
end
always @(posedge clk_chip or negedge reset_n_chip) begin : proc_wr_done_wait_in
    if(~reset_n_chip) begin
        wr_done_wait_in <= 0;
    end else if( wr_count_in >= 2*32 )begin // really write 64,pull_down wr_en
        wr_done_wait_in <= 1; //Control wr_en
    end else if( state == IDLE ) begin
        wr_done_wait_in <= 0;
    end
end
// assign wr_done_in = wr_count_in == 2*32;//pull down wr_ready: 32bx64/64


always @(posedge O_spi_sck or negedge reset_n_chip) begin : proc_O_spi_cs_n_d
    if(~reset_n_chip) begin
        O_spi_cs_n_d <= 1;
    end else begin
        O_spi_cs_n_d <= O_spi_cs_n;
    end
end


always @(posedge clk_chip or negedge reset_n_chip) begin : proc_O_spi_cs_n_sync
  if(!reset_n_chip) begin
    {O_spi_cs_n_sync, O_spi_cs_n_2, O_spi_cs_n_1} <= 3'b111;
  end else begin //paulse
    {O_spi_cs_n_sync, O_spi_cs_n_2, O_spi_cs_n_1} <= {O_spi_cs_n_2, O_spi_cs_n_1, O_spi_cs_n};
  end
end

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_O_spi_cs_n_d_sync
  if(!reset_n_chip) begin
    {O_spi_cs_n_d_sync, O_spi_cs_n_d_2, O_spi_cs_n_d_1} <= 3'b111;
  end else begin //paulse
    {O_spi_cs_n_d_sync, O_spi_cs_n_d_2, O_spi_cs_n_d_1} <= {O_spi_cs_n_d_2, O_spi_cs_n_d_1, O_spi_cs_n_d};
  end
end

always @(posedge clk_chip or negedge reset_n_chip) begin : proc_wr_full_mkup
  if(~reset_n_chip) begin
    {full_ddd, full_dd, full_d}<= 0;
  end else begin
    {full_ddd, full_dd, full_d} <= {full_dd, full_d, full};
  end
end

assign post_full_mkup = ~full && (full_d || full_dd);
wire pre_full_mkup;
assign pre_full_mkup = (full || full_d) && ~full_dd ;

assign reset_n_fifo = reset_n_chip && !(state == IDLE); 
// ====================================================================================================================
// cache temp data
// ====================================================================================================================
reg [ SPI_WIDTH     - 1 : 0 ] data_temp_ram [ 1 : 0 ];
reg                           addr_push;
reg                           addr_pop ;

wire[ SPI_WIDTH     - 1 : 0 ] data_mkup;

always @ ( posedge clk_chip or negedge reset_n_chip ) begin
    if ( !reset_n_chip ) begin
       addr_push  <= 1'b0;
    end else if ( pre_full_mkup ) begin
       addr_push  <= ~addr_push;
    end
end
always @(posedge clk_chip) begin
  if( pre_full_mkup )
    data_temp_ram[ addr_push ] <= wr_data;
end

always @ ( posedge clk_chip or negedge reset_n_chip ) begin
    if ( !reset_n_chip ) begin
       addr_pop  <= 1'b0;
    end else if ( post_full_mkup ) begin
       addr_pop  <= ~addr_pop;
    end
end

assign data_mkup = data_temp_ram[ addr_pop ];

// ====================================================================================================================
// fifo_async
// ====================================================================================================================
reg pre_full_mkup_d;

always @(posedge clk_chip) begin : proc_pre_full_mkup_d
    pre_full_mkup_d <= pre_full_mkup;
end

assign IO_spi_data = ( O_spi_cs_n_d && O_spi_cs_n )? {config_data, 28'd0} : dout;// level O_spi_cs_n is OK
assign wr_clk = clk_chip          ; 
assign wr_en  = ( (wr_req && ~full)  || post_full_mkup ) && ~wr_done_wait_in;// add missed two clk 
assign din    = (post_full_mkup)? data_mkup: wr_data ;
assign rd_clk = O_spi_sck        ;
assign rd_en  = !O_spi_cs_n      ;
fifo_async_wr #(
  .data_width     ( SPI_WIDTH               ),
  .addr_width     ( ADDR_WIDTH_FIFO  )
  )fifo_async(
  .rst_n    ( reset_n_fifo),
  .wr_clk   ( wr_clk    ),
  .wr_en    ( wr_en     ),
  .din      ( din       ),
  .rd_clk   ( rd_clk    ),
  .rd_en    ( rd_en     ),
  .valid    ( valid     ),
  .dout     ( dout      ),
  .empty    ( empty     ),
  .full     ( full      )
  );

// ====================================================================================================================

endmodule
