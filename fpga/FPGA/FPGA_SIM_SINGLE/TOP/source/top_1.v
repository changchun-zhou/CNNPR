 module top_1#(
    parameter SPI_WIDTH = 32
    )(
    input                          clk,
    input                           rst_n,
    input                          config_ready_1_F,
    input                          config_ready_2_F,
    input                          config_ready_out,

    output                           config_req_1_F,
    output                           config_req_2_F,
    output                           config_req_out,

    input                           ready_real_BUS_1,
    input                           ready_real_BUS_2,
    input                           ready_BUS_out,

    output                           data_request_1,
    output                           data_request_2,
    output                           write_req_out,

    input  [ SPI_WIDTH    -1 : 0 ] data_in_1,
    input  [ SPI_WIDTH    -1 : 0 ] data_in_2,
    output   [ SPI_WIDTH    -1 : 0 ] data_out_BUS,

    output   [ 4            -1 : 0 ] which_write_1,
    output   [ 4            -1 : 0 ] which_write_2,
    output   [ 4            -1 : 0 ] which_write_out
);

endmodule