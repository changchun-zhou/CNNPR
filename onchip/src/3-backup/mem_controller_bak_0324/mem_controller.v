//Hypothesis:
//no padding block is 0 => valid = 0;
//for block_valid block_width = 8;
//for loop finish one clk
//too much column and flag
//*****BUG*****
//ceil_a_by_b
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
//`include "common.vh"
module mem_controller #(
  parameter DATA_WIDTH  =  8,
  parameter IF_WIDTH	= 	34, //Padden to 40
  parameter IF_HEIGTH =   34,
  parameter BLOCK_WIDTH = 10,
  parameter BLOCK_HEIGTH= 10,

  parameter NUM_BLOCK_W = 4,
  parameter NUM_BLOCK_H = 4,
  parameter NUM_BLOCK	=	16,
  parameter	CACHE_WIDTH	=	162, //DATA_WIDTH*BLOCK_WIDTH*2
  parameter ADDR_WIDTH  = `C_LOG_2 ( IF_HEIGTH ) //IF_HEIGTH


)(
	input	wire	clk,    // Clock
	input	wire	clk_en, // Clock Enable
	input	wire	rst_n,  // Asynchronous reset active low
	input   wire	read_req02,
	input   wire	read_req13,
	output	[ CACHE_WIDTH	- 1 : 0 ]	cache02_out,
	output	[ CACHE_WIDTH	- 1 : 0 ]	cache13_out,
	output  wire 	empty02,
	output  wire	empty13

);
  
  wire [ DATA_WIDTH	- 1 : 0 ]	column_out [ 0 : IF_WIDTH -1 ];
  wire                        flag       [ 0 : IF_WIDTH -1 ];
  wire  [ ADDR_WIDTH  - 1 : 0 ] rd_addr_flag [ 0 : IF_WIDTH -1 ];
 // wire []
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
      .column_out(column_out[gv_i]), 
      .j(gv_i), 
      .rd_addr_flag(rd_addr_flag[gv_i])//Redundance
	  );
	end
  endgenerate

  reg							read_req;
  reg             read_req_flag;
  wire							write_req;
  reg 	[NUM_BLOCK - 1 : 0] 	valid;
  wire							flag_in 		[ 0 : IF_WIDTH -1 ];
  wire	[1:0]						jump;
  wire	[2:0]						num_block 	[ 0 : IF_WIDTH -1 ];

  always @(posedge clk or posedge rst_n) begin
  	if (~rst_n) begin
  		// reset
  		read_req  <= 0;
      read_req_flag <= 1;
  //		write_req <= 1;
  		valid 	  <= 16'b1100_1100_1100_1100;
 // 		flag_in	  <= { 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, }
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
//		  	.write_req(write_req),
		  	.valid(valid),
		  	.j(gv_j),
//		  	.flag_in(flag_in[gv_j]),
		  	.flag(flag[gv_j]),
		  	.jump(jump),
		  	.num_block(num_block[gv_j]),//Redundance
        .rd_addr(rd_addr_flag[gv_j])
		  	);
		end
  endgenerate

 /* wire	new_if;
  genvar gv_k;
  generate
  	for (gv_k = 0; gv_k < IF_WIDTH; gv_k = gv_k + 1)
  	begin : block*/
/*  		  block	#(
		  )
		  block (
		  	.clk(clk),
		  	.clk_en(clk_en),
		  	.rst_n(rst_n),
		  	.new_if(new_if),
		  	.valid(valid)
		  	);*/

  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column0_9  ;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column8_17 ;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column16_25;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column24_33;

  wire	[ DATA_WIDTH*BLOCK_WIDTH  - 1: 0] 	cache0_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache2_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache1_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache3_in;
  wire	[ CACHE_WIDTH				- 1: 0]		cache02_in;
  wire	[ CACHE_WIDTH				- 1: 0]		cache13_in;
  wire											help_req0;
  wire											help_req1;
  wire											help_req2;
  wire											help_req3;
  reg  help_req0_d ;
  reg  help_req2_d ;
  reg  help_req1_d ;
  reg  help_req3_d ;
  reg  help_req0_dd;
  reg  help_req2_dd;
  reg  help_req1_dd;
  reg  help_req3_dd;
  reg  help_req0_ddd;
  reg  help_req2_ddd;
  reg  help_req1_ddd;
  reg  help_req3_ddd;

  wire	[ `C_LOG_2( NUM_BLOCK_H )  : 0 ] valid_cnt0;
  wire  [ `C_LOG_2( NUM_BLOCK_H )  : 0 ] valid_cnt1;
  wire  [ `C_LOG_2( NUM_BLOCK_H )  : 0 ] valid_cnt2;
  wire  [ `C_LOG_2( NUM_BLOCK_H )  : 0 ] valid_cnt3;

  assign valid_cnt0 = 2;
  assign valid_cnt1 = 2;  
  assign valid_cnt2 = 2;
  assign valid_cnt3 = 2;

  assign help_req0 =  ( valid_cnt0 + 2 <= valid_cnt2 ) && ( num_block[16] >= ( valid_cnt0 + valid_cnt2 ) / 2 );//finish valid_num
  assign help_req2 =  ( valid_cnt2 + 2 <= valid_cnt0 ) && ( num_block[0 ] >= ( valid_cnt0 + valid_cnt2 ) / 2 );
  assign help_req1 =  ( valid_cnt1 + 2 <= valid_cnt3 ) && ( num_block[24] >= ( valid_cnt1 + valid_cnt3 ) / 2 );
  assign help_req3 =  ( valid_cnt3 + 2 <= valid_cnt1 ) && ( num_block[8 ] >= ( valid_cnt1 + valid_cnt3 ) / 2 );
//BUG

  assign column0_9  =  { column_out [ 0 ], column_out [ 1 ], column_out [ 2 ], column_out [ 3 ], column_out [ 4 ], column_out [ 5 ], column_out [ 6 ], column_out [ 7 ], column_out [ 8 ], column_out [ 9 ] };
  assign column8_17 =  { column_out [ 8 ], column_out [ 9 ], column_out [10 ], column_out [11 ], column_out [12 ], column_out [13 ], column_out [14 ], column_out [15 ], column_out [16 ], column_out [17 ] };
  assign column16_25=  { column_out [16 ], column_out [17 ], column_out [18 ], column_out [19 ], column_out [20 ], column_out [21 ], column_out [22 ], column_out [23 ], column_out [24 ], column_out [25 ] };
  assign column24_33=  { column_out [24 ], column_out [25 ], column_out [26 ], column_out [27 ], column_out [28 ], column_out [29 ], column_out [30 ], column_out [31 ], column_out [32 ], column_out [33 ] };
always @(posedge clk or negedge rst_n) begin : proc_help_req_delay_5_clk
  if(~rst_n) begin
    help_req0_d <= 0; 
    help_req2_d <= 0;
    help_req1_d <= 0;
    help_req3_d <= 0;
  end else if(clk_en) begin
    help_req0_d <= help_req0 ; 
    help_req2_d <= help_req2 ;
    help_req1_d <= help_req1 ;
    help_req3_d <= help_req3 ;

    help_req0_dd <= help_req0_d ; 
    help_req2_dd <= help_req2_d ;
    help_req1_dd <= help_req1_d ;
    help_req3_dd <= help_req3_d ;

    help_req0_ddd <= help_req0_dd ; 
    help_req2_ddd <= help_req2_dd ;
    help_req1_ddd <= help_req1_dd ;
    help_req3_ddd <= help_req3_dd ;
  end
end
  assign cache0_in =  help_req0_ddd ? column16_25 : column0_9; //
  assign cache2_in =  help_req2_ddd ? column0_9 : column16_25; //

  assign cache1_in =  help_req1_ddd ? column24_33 : column8_17; //
  assign cache3_in =  help_req3_ddd ? column8_17 : column24_33; //

  assign cache02_in = { help_req0_ddd, help_req2_ddd, cache0_in, cache2_in};
  assign cache13_in = { help_req1_ddd, help_req3_ddd, cache1_in, cache3_in};

  cache #(
  )
  cache02 (.clk     (clk),
  	.clk_en  (clk_en),
  	.rst_n   (rst_n),
   // .write_req(     ),
  	.data_in (cache02_in),
    .read_req(read_req),
  	.data_out(cache02_out),
  	.empty   (empty02)
  	);

  cache #(
  )
  cache13 (.clk     (clk),
  	.clk_en  (clk_en),
  	.rst_n   (rst_n),
  	.data_in (cache13_in),
    .read_req(read_req),
  	.data_out(cache13_out),
  	.empty   (empty13)
  	);

/*  always @(*) begin : proc_cache_in
    //for ( i = 0; i < BLOCK_WIDTH; i = i + 1 ) begin
      //help_req: can help another block
      // extend one/two column
      //cache0 : 0  - 9
      //cache1 : 8  - 17
      //cache2 : 16 - 25
      //cache3 : 24 - 33
      //help_req0 =  ( valid_cnt0 + 2 <= valid_cnt2 ) && (num_block[i] + 2 >= num_block[ i + 2*BLOCK_WIDTH - 4 ]);
      //num_block[i] == 4 ? the block all finish
      help_req2 =  ( valid_cnt2 + 2 <= valid_cnt0 ) && ( num_block[ i + 2*BLOCK_WIDTH -3 ] == 4 );
      cache2_in = (cache2_in << DATA_WIDTH ) | ( help_req2 ?  column_out [ i ] : column_out [ i + 2*BLOCK_WIDTH -3 ] );

      help_req1 =  ( valid_cnt1 + 2 <= valid_cnt3 ) && ( num_block[ i + BLOCK_WIDTH -2 ] == 4 );
      cache1_in = ( cache1_in << DATA_WIDTH ) | (help_req1 ? column_out [ i + 3*BLOCK_WIDTH -6] : column_out [ i + BLOCK_WIDTH -2 ] );    

      help_req3 =  ( valid_cnt3 + 2 <= valid_cnt1 ) && ( num_block[ i + 3*BLOCK_WIDTH -6 ] == 4 );
      cache3_in = ( cache3_in << DATA_WIDTH ) | (help_req3 ? column_out [ i + BLOCK_WIDTH -2] : column_out [ i + 3*BLOCK_WIDTH -6 ] );
    //end
    cache02_in = { help_req0, help_req2, cache0_in, cache2_in};
    cache13_in = { help_req1, help_req3,cache1_in, cache3_in};
  end
*/
endmodule