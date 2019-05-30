//FIFO
`timescale 1ns/1ps

`define C_LOG_2(n) (\
(n) <= (1<<0) ? 0 : (n) <= (1<<1) ? 1 :\
(n) <= (1<<2) ? 2 : (n) <= (1<<3) ? 3 :\
(n) <= (1<<4) ? 4 : (n) <= (1<<5) ? 5 :\
(n) <= (1<<6) ? 6 : (n) <= (1<<7) ? 7 :\
(n) <= (1<<8) ? 8 : (n) <= (1<<9) ? 9 :\
(n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
(n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
(n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
(n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
(n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
(n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
(n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
(n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
(n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
(n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
(n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)

module mem_controller #(
  parameter DATA_WIDTH  =  8,
  parameter IF_WIDTH	= 	34, //Padden to 40
  parameter IF_HEIGTH =   34,
 
  parameter CACHE_WIDTH = DATA_WIDTH * IF_WIDTH ,
  parameter ADDR_WIDTH  = `C_LOG_2 ( IF_HEIGTH ) //IF_HEIGTH


)(
	input	wire	clk,    // Clock
	input	wire	clk_en, // Clock Enable
	input	wire	rst_n,  // Asynchronous reset active low
	input   wire	read_cache_req,
	output	[ CACHE_WIDTH	- 1 : 0 ]	cache_out,
	output  wire 	empty

);
  wire full;
  wire  [ ADDR_WIDTH    : 0 ]   fifo_count;
  wire [ DATA_WIDTH	- 1 : 0 ]	column_out [ 0 : IF_WIDTH -1 ];
  wire                        flag       [ 0 : IF_WIDTH -1 ];
  genvar gv_i;
  generate
  	for (gv_i = 0; gv_i < IF_WIDTH ; gv_i  = gv_i + 1)
  	begin : column
	  column #(
	  )
	  column (
      .clk(clk), 
      .clk_en  (clk_en), 
      .rst_n	 (rst_n), 
      .flag    (flag[gv_i]), 
      .column_out(column_out[gv_i])
	  );
	end
  endgenerate

  reg             read_req_flag;
  wire							write_req;
  wire							flag_in 		[ 0 : IF_WIDTH -1 ];
  reg write_cache_req;
  always @(posedge clk or posedge rst_n) begin
  	if (~rst_n) begin
      read_req_flag <= 1;
      write_cache_req <= 1;
  	end
  	else if (clk_en) begin 		
  	end
  end
  genvar gv_j;
  generate
  	for (gv_j = 0; gv_j < IF_WIDTH; gv_j = gv_j + 1)
  	begin : sparsity
  		  sparsity	#(
		  )
		  sparsity (
		  	.clk(clk),
		  	.clk_en(clk_en),
		  	.rst_n(rst_n),
		  	.read_req(read_req_flag),
		  	.flag(flag[gv_j])
		  	);
		end
  endgenerate
  wire	[ CACHE_WIDTH				- 1: 0]	 cache_in;
  assign cache_in = {   column_out [ 0 ], column_out [ 1 ], column_out [ 2 ], column_out [ 3 ], column_out [ 4 ],
                        column_out [ 5 ], column_out [ 6 ], column_out [ 7 ], column_out [ 8 ], column_out [ 9 ],
                        column_out [10 ], column_out [11 ], column_out [12 ], column_out [13 ], column_out [14 ],
                        column_out [15 ], column_out [16 ], column_out [17 ], column_out [18 ], column_out [19 ],
                        column_out [20 ], column_out [21 ], column_out [22 ], column_out [23 ], column_out [24 ],
                        column_out [25 ], column_out [26 ], column_out [27 ], column_out [28 ], column_out [29 ],
                        column_out [30 ], column_out [31 ], column_out [32 ], column_out [33 ] };

  fifo #(  .DATA_WIDTH( DATA_WIDTH ),
    .ADDR_WIDTH( ADDR_WIDTH )
    )
  cache (.clk       (clk),
    .rst_n     (~rst_n),
    .push      (write_cache_req),
    .pop       (read_cache_req),
    .data_in   (cache_in),
    .data_out  (cache_out),
    .empty     (empty),
    .full      (full),
    .fifo_count(fifo_count)
    );
endmodule