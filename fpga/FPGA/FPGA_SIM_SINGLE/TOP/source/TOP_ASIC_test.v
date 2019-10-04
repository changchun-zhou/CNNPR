//======================================================
// Copyright (C) 2019 By zhoucc
// All Rights Reserved
//======================================================
// Module : TOP_ASIC
// Author : CC zhou
// Contact : zhouchch@pku.edu.cn
// Date :  Oct.1.2019
//=======================================================
// Description :
//=======================================================

module TOP_ASIC #(
    parameter SPI_WIDTH = 32,
    parameter ADDR_WIDTH_FIFO = 5
    )(
    input clk_chip,

    input                           reset_n_pad,  // 

    output  [ SPI_WIDTH    -1 : 0 ] IO_spi_data_wr0_pad,
    input                           O_spi_sck_wr0_pad,
    input                           O_spi_cs_n_wr0_pad,
    output                          config_req_wr0_pad,

    inout   [ SPI_WIDTH    -1 : 0 ] IO_spi_data_rd0_pad,
    input                           O_spi_sck_rd0_pad,
    input                           O_spi_cs_n_rd0_pad,
    input                           OE_req_rd0_pad,
    output                          config_req_rd0_pad,
    output                          near_full_rd0_pad,

    inout   [ SPI_WIDTH    -1 : 0 ] IO_spi_data_rd1_pad,
    input                           O_spi_sck_rd1_pad,
    input                           O_spi_cs_n_rd1_pad,
    input                           OE_req_rd1_pad,

    output                          config_req_rd1_pad,
    output                          near_full_rd1_pad,

    output                          config_ready_1_F,
    output                          config_ready_2_F,
    output                          config_ready_out,

    input                           config_req_1_F,
    input                           config_req_2_F,
    input                           config_req_out,

    // output                           ready_real_BUS_1,
    output                           ready_real_BUS_2,
    output                           ready_BUS_out,

    // input                           data_request_1,
    input                           data_request_2,
    input                           write_req_out,

    // output  [ SPI_WIDTH    -1 : 0 ] data_in_1,
    output  [ SPI_WIDTH    -1 : 0 ] data_in_2,
    input   [ SPI_WIDTH    -1 : 0 ] data_out_BUS,

    input   [ 4            -1 : 0 ] which_write_1,
    input   [ 4            -1 : 0 ] which_write_2,
    input   [ 4            -1 : 0 ] which_write_out,

 output [ 63 : 0 ] data_out,
output            ready

    ); 
    wire[ SPI_WIDTH    -1 : 0 ] data_in_1; 
//=====================================================================================================================
// Variable Definition :
//=====================================================================================================================
reg                               pad_OE_rd0;
reg                               pad_OE_rd1;
wire [ SPI_WIDTH        - 1 : 0 ] O_spi_data_wr0;
wire [ SPI_WIDTH        - 1 : 0 ] O_spi_data_rd0;
wire [ SPI_WIDTH        - 1 : 0 ] I_spi_data_rd0;
wire [ SPI_WIDTH        - 1 : 0 ] O_spi_data_rd1;
wire [ SPI_WIDTH        - 1 : 0 ] I_spi_data_rd1;
wire                              OE_req_rd0;
wire                              OE_req_rd1;
wire                              config_req_rd0;
wire                              config_req_rd1;
//=====================================================================================================================
// Logic Design :
//=====================================================================================================================
always @ ( posedge clk_chip ) begin
    pad_OE_rd0 <= ( config_req_rd0 && !OE_req_rd0 );
    pad_OE_rd1 <= ( config_req_rd1 && !OE_req_rd1 );
end

//=====================================================================================================================
// Sub-Module :
//=====================================================================================================================

top_asyncFIFO_wr #(
        .SPI_WIDTH(SPI_WIDTH),
        .ADDR_WIDTH_FIFO(ADDR_WIDTH_FIFO)
    ) inst_top_asyncFIFO_wr (
        .clk_chip      (clk_chip),
        .reset_n_chip  (reset_n),
        .O_spi_sck     (O_spi_sck_wr0),
        .IO_spi_data   (O_spi_data_wr0),
        .O_spi_cs_n    (O_spi_cs_n_wr0),
        .config_req    (config_req_wr0),

        .config_ready  (config_ready_out),
        .config_paulse (config_req_out),
        .config_data   (which_write_out),
        .wr_ready      (ready_BUS_out),
        .wr_req        (write_req_out),
        .wr_data       (data_out_BUS)
    );

top_asyncFIFO_rd #(
        .SPI_WIDTH(SPI_WIDTH),
        .ADDR_WIDTH_FIFO(ADDR_WIDTH_FIFO)
    ) inst_top_asyncFIFO_rd0 (
        .clk_chip      (clk_chip),
        .reset_n_chip  (reset_n),
        .O_spi_sck     (O_spi_sck_rd0),
        .I_spi_data    (I_spi_data_rd0),
        .O_spi_data    (O_spi_data_rd0),
        .O_spi_cs_n    (O_spi_cs_n_rd0),
        .config_req    (config_req_rd0),
        .full          (near_full_rd0      ),
        .config_ready  (config_ready_1_F),
        .config_paulse (config_req_1_F),
        .config_data   (which_write_1),
        .rd_req        (data_request_1),
        .rd_valid      (ready_real_BUS_1),
        .rd_data       (data_in_1)
    );

reg [1:0] data_mode;

always @(*) begin : proc_data_mode
    if(!reset_n)
      data_mode = 0;
    else
        case(which_write_1)
          4'b0001:  data_mode = 0;
          4'b0010:  data_mode = 0;
          4'b0011:  data_mode = 1;
          4'b0100:  data_mode = 1;
          4'b0101:  data_mode = 2;
          4'b0110:  data_mode = 2;
          4'b0111:  data_mode = 3;
          4'b1000:  data_mode = 3;
          default:  data_mode = 0;
        endcase
end

reg_128bit reg_128bit(
  .clk          ( clk_chip      ),
  .rst_n        ( reset_n  ),
  .data_in      (data_in_1        ),
  .ready_bus_real    ( ready_real_BUS_1      ),
  .data_request ( data_request_1  ),

  .read_en      ( 1'b1          ),
  .data_mode    ( data_mode         ),
  .data_out     ( data_out      ),
  .ready        ( ready         ) 
  );
  


top_asyncFIFO_rd #(
        .SPI_WIDTH(SPI_WIDTH),
        .ADDR_WIDTH_FIFO(ADDR_WIDTH_FIFO)
    ) inst_top_asyncFIFO_rd1 (
        .clk_chip      (clk_chip),
        .reset_n_chip  (reset_n),
        .O_spi_sck     (O_spi_sck_rd1),
        .I_spi_data    (I_spi_data_rd1),
        .O_spi_data    (O_spi_data_rd1),
        .O_spi_cs_n    (O_spi_cs_n_rd1),
        .config_req    (config_req_rd1),
        .full          (near_full_rd1      ),

        .config_ready  (config_ready_2_F),
        .config_paulse (config_req_2_F),
        .config_data   (which_write_2),
        .rd_req        ( data_request_2),
        .rd_valid      (ready_real_BUS_2),
        .rd_data       (data_in_2)
    );







// top_1 inst_top_1
//     (
//         .clk                (clk_chip),
//         .rst_n              (reset_n),
//         .config_ready_1_F   (config_ready_1_F),
//         .config_ready_2_F   (config_ready_2_F),
//         .config_ready_out   (config_ready_out),
//         .config_req_1_F     (config_req_1_F),
//         .config_req_2_F     (config_req_2_F),
//         .config_req_out     (config_req_out),
//         .ready_real_BUS_1   (ready_real_BUS_1),
//         .ready_real_BUS_2   (ready_real_BUS_2),
//         .ready_BUS_out      (ready_real_BUS_out),
//         .data_request_1     (data_request_1),
//         .data_request_2     (data_request_2),
//         .write_req_out      (write_req_out),
//         .data_in_1          (data_in_1),
//         .data_in_2          (data_in_2),
//         .data_out_BUS       (data_out_BUS),
//         .which_write_1      (which_write_1),
//         .which_write_2      (which_write_2),
//         .which_write_out    (which_write_out)
//     );



// ====================================================================================================================
// PAD Defination
// ====================================================================================================================

supply1         VDD     ;
supply0         VSS     ;
supply1         VDDIO25 ;
supply0         VSSIO   ;

IPOC IPOC_cell (.PORE(PORE),.VDD(VDD), .VSS(VSS),.VDDIO(VDDIO25));

IUMBFS reset_n_PAD  (.DO (            ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (reset_n), .PAD (reset_n_pad ), .PORE (PORE));
// ====================================================================================================================
// WRITE0 PAD defination
// ====================================================================================================================

generate
  genvar i;
  for ( i=0; i<SPI_WIDTH; i=i+1 ) begin: IO_spi_data_PAD_wr0_GEN
    IUMBFS IO_spi_data_PAD_wr0 (.DO (O_spi_data_wr0[i]), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI ( ), .PAD (IO_spi_data_wr0_pad[i]), .PORE (PORE));
  end
endgenerate


IUMBFS O_spi_sck_PAD_wr0    (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_wr0    ), .PAD (O_spi_sck_wr0_pad    ), .PORE (PORE));
IUMBFS O_spi_cs_n_PAD_wr0   (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_wr0   ), .PAD (O_spi_cs_n_wr0_pad   ), .PORE (PORE));
IUMBFS config_req_PAD_wr0   (.DO ( config_req_wr0   ), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                 ), .PAD (config_req_wr0_pad   ), .PORE (PORE));
// ====================================================================================================================



// ====================================================================================================================
// READ0  PAD defination
// ====================================================================================================================
generate
  genvar k;
  for ( k=0; k<SPI_WIDTH; k=k+1 ) begin: IO_spi_data_PAD_rd0_GEN
    IUMBFS IO_spi_data_PAD_rd0 (.DO (O_spi_data_rd0[k]), .IDDQ (1'b0), .IE (1'b1), .OE (pad_OE_rd0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (I_spi_data_rd0[k]), .PAD (IO_spi_data_rd0_pad[k]), .PORE (PORE));
  end
endgenerate

IUMBFS O_spi_sck_PAD_rd0    (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_rd0     ), .PAD (O_spi_sck_rd0_pad    ), .PORE (PORE));
IUMBFS O_spi_cs_n_PAD_rd0   (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_rd0    ), .PAD (O_spi_cs_n_rd0_pad   ), .PORE (PORE));
IUMBFS OE_req_PAD_rd0       (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (OE_req_rd0        ), .PAD (OE_req_rd0_pad       ), .PORE (PORE));
IUMBFS near_full_PAD_rd0    (.DO (near_full_rd0   ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (near_full_rd0_pad    ), .PORE (PORE));
IUMBFS config_req_PAD_rd0   (.DO ( config_req_rd0 ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (config_req_rd0_pad   ), .PORE (PORE));

// ====================================================================================================================

// ====================================================================================================================
// READ1  PAD defination
// ====================================================================================================================
generate
  genvar m;
  for ( m=0; m<SPI_WIDTH; m=m+1 ) begin: IO_spi_data_PAD_rd1_GEN
    IUMBFS IO_spi_data_PAD_rd1 (.DO (O_spi_data_rd1[m]), .IDDQ (1'b0), .IE (1'b1), .OE (pad_OE_rd1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (I_spi_data_rd1[m]), .PAD (IO_spi_data_rd1_pad[m]), .PORE (PORE));
  end
endgenerate

IUMBFS O_spi_sck_PAD_rd1    (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_rd1     ), .PAD (O_spi_sck_rd1_pad    ), .PORE (PORE));
IUMBFS O_spi_cs_n_PAD_rd1   (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_rd1    ), .PAD (O_spi_cs_n_rd1_pad   ), .PORE (PORE));
IUMBFS OE_req_PAD_rd1       (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (OE_req_rd1        ), .PAD (OE_req_rd1_pad       ), .PORE (PORE));
IUMBFS near_full_PAD_rd1    (.DO (near_full_rd1   ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (near_full_rd1_pad    ), .PORE (PORE));
IUMBFS config_req_PAD_rd1   (.DO ( config_req_rd1 ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (config_req_rd1_pad   ), .PORE (PORE));

// ====================================================================================================================

endmodule
