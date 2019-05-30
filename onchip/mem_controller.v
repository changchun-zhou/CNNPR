//Hypothesis:
//no padding block is 0 => valid = 0;
//for block_valid block_width = 8;
//for loop finish one clk
//too much column and flag
//

module mem_controller #(
  parameter IF_WIDTH	= 	34, //Padden to 40
  parameter DATA_WIDTH	=  	8,
  parameter NUM_BLOCK	=	16,
  parameter	CACHE_WIDTH	=	160, //8*10*2
  parameter integer BLOCK_WIDTH	= 10


)(
	input	wire	clk,    // Clock
	input	wire	clk_en, // Clock Enable
	input	wire	rst_n,  // Asynchronous reset active low
	input   wire	read_req02,
	input   wire	read_req13,
	output	[ CACHE_WIDTH	- 1 : 0 ]	cache_out02,
	output	[ CACHE_WIDTH	- 1 : 0 ]	cache_out13,
	output  wire 	empty02,
	output  wire	empty13

);
  
  wire [ DATA_WIDTH	- 1 : 0 ]	column_out [ 0 : IF_WIDTH -1 ];
  wire                        flag       [ 0 : IF_WIDTH -1 ];
 // wire []
  genvar gv_i;
  generate
  	for (gv_i = 0; gv_i < IF_WIDTH ; gv_i  = gv_i + 1)
  	begin : column
	  column #(
	  )
	  column (.clk(clk), .clk_en  (clk_en), .rst_n	 (rst_n), .flag    (flag[gv_i]), .column_out(column_out[gv_i])
	  );
	end
  endgenerate

  reg							read_req;
  wire							write_req;
  reg 	[NUM_BLOCK - 1 : 0] 	valid;
  wire							flag_in 		[ 0 : IF_WIDTH -1 ];
  wire							jump;
  wire							finish_block 	[ 0 : IF_WIDTH -1 ];

  always @(posedge clk or posedge rst_n) begin
  	if (~rst_n) begin
  		// reset
  		read_req  <= 0;
  //		write_req <= 1;
  		valid 	  <= 16'b0001_0001_0111_0111;
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
		  	.read_req(read_req),
//		  	.write_req(write_req),
		  	.valid(valid),
		  	.j(gv_j),
//		  	.flag_in(flag_in[gv_j]),
		  	.flag(flag[gv_j]),
		  	.jump(jump),
		  	.finish_block(finish_block[gv_j])
		  	);
		end
  endgenerate

  wire	new_if;
  genvar gv_k;
  generate
  	for (gv_k = 0; gv_k < IF_WIDTH; gv_k = gv_k + 1)
  	begin : block
  		  block	#(
		  )
		  block (
		  	.clk(clk),
		  	.clk_en(clk_en),
		  	.rst_n(rst_n),
		  	.new_if(new_if),
		  	.valid(valid)
		  	);
    end
  endgenerate
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column0_9  ;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column8_17 ;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column16_25;
  wire  [ DATA_WIDTH*BLOCK_WIDTH  - 1: 0]   column24_33;

  wire	[ DATA_WIDTH*BLOCK_WIDTH  - 1: 0] 	cache0_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache2_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache1_in;
  wire	[ DATA_WIDTH*BLOCK_WIDTH	- 1: 0] 	cache3_in;
  wire	[ CACHE_WIDTH				+ 1: 0]		cache02_in;
  wire	[ CACHE_WIDTH				+ 1: 0]		cache13_in;
  wire											help_req0;
  wire											help_req1;
  wire											help_req2;
  wire											help_req3;
  wire	[2:0] valid_cnt0;
  wire	[2:0] valid_cnt1;
  wire	[2:0] valid_cnt2;
  wire	[2:0] valid_cnt3;
  reg   [3:0] i;

  assign help_req0 =  ( valid_cnt0 + 2 <= valid_cnt2 ) && ( finish_block[0] == 4 );
  assign help_req2 =  ( valid_cnt2 + 2 <= valid_cnt0 ) && ( finish_block[16] == 4 );
  assign help_req1 =  ( valid_cnt1 + 2 <= valid_cnt3 ) && ( finish_block[8] == 4 );
  assign help_req3 =  ( valid_cnt3 + 2 <= valid_cnt1 ) && ( finish_block[24] == 4 );

  assign column0_9  =  { column_out [ 0 ], column_out [ 1 ], column_out [ 2 ], column_out [ 3 ], column_out [ 4 ], column_out [ 5 ], column_out [ 6 ], column_out [ 7 ], column_out [ 8 ], column_out [ 9 ] };
  assign column8_17 =  { column_out [ 8 ], column_out [ 9 ], column_out [10 ], column_out [11 ], column_out [12 ], column_out [13 ], column_out [14 ], column_out [15 ], column_out [16 ], column_out [17 ] };
  assign column16_25=  { column_out [16 ], column_out [17 ], column_out [18 ], column_out [19 ], column_out [20 ], column_out [21 ], column_out [22 ], column_out [23 ], column_out [24 ], column_out [25 ] };
  assign column24_33=  { column_out [24 ], column_out [25 ], column_out [26 ], column_out [27 ], column_out [28 ], column_out [29 ], column_out [30 ], column_out [31 ], column_out [32 ], column_out [33 ] };

  assign cache0_in =  help_req0 ? column16_25 : column0_9; //
  assign cache2_in =  help_req2 ? column0_9 : column16_25; //

  assign cache1_in =  help_req1 ? column24_33 : column8_17; //
  assign cache3_in =  help_req3 ? column8_17 : column24_33; //

  assign cache02_in = { help_req0, help_req2, cache0_in, cache2_in};
  assign cache13_in = { help_req1, help_req3,cache1_in, cache3_in};

  cache #(
  )
  cache02 (
    .clk     (clk),
  	.clk_en  (clk_en),
  	.rst_n   (rst_n),
  	.data_in (cache02_in),
  	.column_out(cache02_out),
  	.empty   (empty02)
  	);

  cache #(
  )
  cache13 (.clk     (clk),
  	.clk_en  (clk_en),
  	.rst_n   (rst_n),
  	.data_in (cache13_in),
  	.column_out(cache13_out),
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
      //help_req0 =  ( valid_cnt0 + 2 <= valid_cnt2 ) && (finish_block[i] + 2 >= finish_block[ i + 2*BLOCK_WIDTH - 4 ]);
      //finish_block[i] == 4 ? the block all finish
      help_req2 =  ( valid_cnt2 + 2 <= valid_cnt0 ) && ( finish_block[ i + 2*BLOCK_WIDTH -3 ] == 4 );
      cache2_in = (cache2_in << DATA_WIDTH ) | ( help_req2 ?  column_out [ i ] : column_out [ i + 2*BLOCK_WIDTH -3 ] );

      help_req1 =  ( valid_cnt1 + 2 <= valid_cnt3 ) && ( finish_block[ i + BLOCK_WIDTH -2 ] == 4 );
      cache1_in = ( cache1_in << DATA_WIDTH ) | (help_req1 ? column_out [ i + 3*BLOCK_WIDTH -6] : column_out [ i + BLOCK_WIDTH -2 ] );    

      help_req3 =  ( valid_cnt3 + 2 <= valid_cnt1 ) && ( finish_block[ i + 3*BLOCK_WIDTH -6 ] == 4 );
      cache3_in = ( cache3_in << DATA_WIDTH ) | (help_req3 ? column_out [ i + BLOCK_WIDTH -2] : column_out [ i + 3*BLOCK_WIDTH -6 ] );
    //end
    cache02_in = { help_req0, help_req2, cache0_in, cache2_in};
    cache13_in = { help_req1, help_req3,cache1_in, cache3_in};
  end
*/


endmodule