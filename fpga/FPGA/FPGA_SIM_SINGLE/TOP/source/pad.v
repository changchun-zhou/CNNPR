
module pad #(
    parameter SPI_WIDTH = 32
    )(
    // input                           clk_pad,    // 
    // output                          clk, // 
    // input                           reset_n_pad,  // 
    // output                          reset_n,
    // input                           bypass_pad,
    // output                          bypass,
    // input                           dll_mode_s1_pad,
    // output                          dll_mode_s1,

    output  [ SPI_WIDTH    -1 : 0 ] IO_spi_data_wr0_pad,
    input   [ SPI_WIDTH    -1 : 0 ] O_spi_data_wr0,
    input                           O_spi_sck_wr0_pad,
    output                          O_spi_sck_wr0,
    input                           O_spi_cs_n_wr0_pad,
    output                          O_spi_cs_n_wr0,
    output                          config_req_wr0_pad,
    input                           config_req_wr0,

    inout   [ SPI_WIDTH    -1 : 0 ] IO_spi_data_rd0_pad,
    input   [ SPI_WIDTH    -1 : 0 ] O_spi_data_rd0,
    output  [ SPI_WIDTH    -1 : 0 ] I_spi_data_rd0,
    input                           O_spi_sck_rd0_pad,
    output                          O_spi_sck_rd0,
    input                           O_spi_cs_n_rd0_pad,
    output                          O_spi_cs_n_rd0,
    input                           OE_req_rd0_pad,
    output                          OE_req_rd0,

    output                          config_req_rd0_pad,
    input                           config_req_rd0,
    output                          near_full_rd0_pad,
    input                           near_full_rd0,

    input                           pad_OE_rd0,

    inout   [ SPI_WIDTH    -1 : 0 ] IO_spi_data_rd1_pad,
    input   [ SPI_WIDTH    -1 : 0 ] O_spi_data_rd1,
    output  [ SPI_WIDTH    -1 : 0 ] I_spi_data_rd1,
    input                           O_spi_sck_rd1_pad,
    output                          O_spi_sck_rd1,
    input                           O_spi_cs_n_rd1_pad,
    output                          O_spi_cs_n_rd1,
    input                           OE_req_rd1_pad,
    output                          OE_req_rd1,

    output                          config_req_rd1_pad,
    input                           config_req_rd1,
    output                          near_full_rd1_pad,
    input                           near_full_rd1,

    input                           pad_OE_rd1,



);

supply1         VDD     ;
supply0         VSS     ;
supply1         VDDIO25 ;
supply0         VSSIO   ;

IPOC IPOC_cell (.PORE(PORE),.VDD(VDD), .VSS(VSS),.VDDIO(VDDIO25));

// IUMBFS clk_PAD      (.DO (            ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (clk    ), .PAD (clk_pad     ), .PORE (PORE));
// IUMBFS reset_n_PAD  (.DO (            ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (reset_n), .PAD (reset_n_pad ), .PORE (PORE));
// ====================================================================================================================
// WRITE0 PAD defination
// ====================================================================================================================

generate
  genvar i;
  for ( i=0; i<SPI_WIDTH; i=i+1 ) begin: IO_spi_data_PAD_wr0_GEN
    IUMBFS IO_spi_data_PAD_wr0 (.DO (O_spi_data_wr0[i]), .IDDQ (1'b0), .IE (1'b1), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI ( ), .PAD (IO_spi_data_wr0_pad[i]), .PORE (PORE));
  end
endgenerate


IUMBFS O_spi_sck_PAD_wr0    (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_wr0    ), .PAD (O_spi_sck_wr0_pad    ), .PORE (PORE));
IUMBFS O_spi_cs_n_PAD_wr0   (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_wr0   ), .PAD (O_spi_cs_n_wr0_pad   ), .PORE (PORE));
IUMBFS config_req_PAD_wr0   (.DO ( config_req_wr0   ), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                 ), .PAD (config_req_wr0_pad   ), .PORE (PORE));
// ====================================================================================================================


// // ====================================================================================================================
// // WRITE1 PAD defination
// // ====================================================================================================================
// generate
//   genvar j;
//   for ( j=0; j<SPI_WIDTH; j=j+1 ) begin: IO_spi_data_PAD_wr1_GEN
//     IUMBFS IO_spi_data_PAD_wr1 (.DO (O_spi_data_wr1[j]), .IDDQ (1'b0), .IE (1'b1), .OE (1'b1), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI ( ), .PAD (IO_spi_data_wr1_pad[j]), .PORE (PORE));
//   end
// endgenerate

// IUMBFS O_spi_sck_PAD_wr1    (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_wr1    ), .PAD (O_spi_sck_wr1_pad    ), .PORE (PORE));
// IUMBFS O_spi_cs_n_PAD_wr1   (.DO (                  ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_wr1   ), .PAD (O_spi_cs_n_wr1_pad   ), .PORE (PORE));
// IUMBFS config_req_PAD_wr1   (.DO ( config_req_wr1   ), .IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (                 ), .PAD (config_req_wr1_pad   ), .PORE (PORE));
// // ====================================================================================================================


// ====================================================================================================================
// READ0  PAD defination
// ====================================================================================================================
generate
  genvar k;
  for ( k=0; k<SPI_WIDTH; k=k+1 ) begin: IO_spi_data_PAD_rd0_GEN
    IUMBFS IO_spi_data_PAD_rd0 (.DO (O_spi_data_rd0[k]), .IDDQ (1'b0), .IE (1'b1), .OE (pad_OE_rd0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (I_spi_data_rd0[k]), .PAD (IO_spi_data_rd0_pad[k]), .PORE (PORE));
  end
endgenerate

IUMBFS O_spi_sck_PAD_rd0    (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_sck_rd0     ), .PAD (O_spi_sck_rd_pad0    ), .PORE (PORE));
IUMBFS O_spi_cs_n_PAD_rd0   (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (O_spi_cs_n_rd0    ), .PAD (O_spi_cs_n_rd_pad0   ), .PORE (PORE));
IUMBFS OE_req_PAD_rd0       (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (OE_req_rd0        ), .PAD (OE_req_rd_pad0       ), .PORE (PORE));
IUMBFS near_full_PAD_rd0    (.DO (near_full_rd0   ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (near_full_rd_pad0    ), .PORE (PORE));
IUMBFS config_req_PAD_rd0   (.DO ( config_req_rd0 ),.IDDQ (1'b0), .IE (1'b0), .OE (1'b1), .PD (1'b0), .PIN1 (1'b0), .PIN2 (1'b0), .PU (1'b0), .SMT (1'b0), .DI (                  ), .PAD (config_req_rd_pad0   ), .PORE (PORE));

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
// IUMBFS bypass_PAD   (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (bypass    ), .PAD (bypass_pad   ), .PORE (PORE));
// IUMBFS dll_mode_s1_PAD       (.DO (               ), .IDDQ (1'b0), .IE (1'b1), .OE (1'b0), .PD (1'b0), .PIN1 (1'b1), .PIN2 (1'b1), .PU (1'b0), .SMT (1'b0), .DI (dll_mode_s1        ), .PAD (dll_mode_s1_pad       ), .PORE (PORE));


endmodule