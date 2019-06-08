module activation #(
  parameter READ_REQ_ACT = 9'b000_000_001
)
(
    input                                       clk               ,
    input                                       reset             ,
    input                                       mode              ,
    input                                       en                ,
    input                                       wr_req_act_flag   ,
    input [ `IF_WIDTH                 - 1 : 0 ] wr_data_act_flag  ,
    input                                       wr_req_act        ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act0      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act1      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act2      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act3      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act4      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act5      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act6      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act7      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act8      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act9      ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act10     ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act11     ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act12     ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act13     ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act14     ,
    input [ `DATA_WIDTH               - 1 : 0 ] wr_data_act15     , 
    input [ 2                         - 1 : 0 ] state_parallel    ,
    input                                       row_cal_done      ,
    input                                       row_index_count_3 ,
    output [ `ACT_INDEX_WIDTH         - 1 : 0 ] valid_act_index   ,
    output [ `DATA_WIDTH              - 1 : 0 ] serial_act        ,
    output [ `DATA_WIDTH * `IF_WIDTH  - 1 : 0 ] parallel_act      ,
    output [ (`ADDR_WIDTH + 1) * `KERNEL_WIDTH - 1 : 0 ] row_val_num_array 

);
  wire [ `DATA_WIDTH       - 1 : 0 ] wr_data_act [ 0 : `IF_WIDTH     - 1 ];
  assign wr_data_act[0 ] = wr_data_act0 ;
  assign wr_data_act[1 ] = wr_data_act1 ;
  assign wr_data_act[2 ] = wr_data_act2 ;
  assign wr_data_act[3 ] = wr_data_act3 ;
  assign wr_data_act[4 ] = wr_data_act4 ;
  assign wr_data_act[5 ] = wr_data_act5 ;
  assign wr_data_act[6 ] = wr_data_act6 ;
  assign wr_data_act[7 ] = wr_data_act7 ;
  assign wr_data_act[8 ] = wr_data_act8 ;
  assign wr_data_act[9 ] = wr_data_act9 ;
  assign wr_data_act[10] = wr_data_act10;
  assign wr_data_act[11] = wr_data_act11;
  assign wr_data_act[12] = wr_data_act12;
  assign wr_data_act[13] = wr_data_act13;
  assign wr_data_act[14] = wr_data_act14;
  assign wr_data_act[15] = wr_data_act15;
  
  wire                                  read_req_pflag;
  wire   [ `IF_WIDTH     - 1 : 0 ]      rd_data_act_flag ;
  wire                                  rd_req_act_flag;
  wire                                  rd_req_act_flag_d;
  wire   [ `ACT_INDEX_WIDTH         - 1 : 0 ] valid_act_index_d;
  assign rd_req_act_flag = ( mode == 1 ) ? ( state_parallel == 2'b01 ? 1 : 0 ) : 00000000000;
  ram # (
    .DATA_WIDTH( `IF_WIDTH    ),
    .ADDR_WIDTH( `ADDR_WIDTH  )
    )
  ram_act_flag (
    .clk          ( clk           ),
    .reset        ( reset         ),
    .wr_req       ( wr_req_act_flag   ),
    .wr_data      ( wr_data_act_flag  ),

    .rd_req   ( rd_req_act_flag    ),
    .rd_data  ( rd_data_act_flag   )
    );

  wire [ `KERNEL_SIZE     - 1 : 0 ] rd_req_act;
  assign rd_req_act = ( mode == 1 )? rd_data_act_flag : READ_REQ_ACT <<< valid_act_index;//mode0: only read a column.

  wire  [ `DATA_WIDTH  - 1 : 0 ] rd_data_act [ 0 : `KERNEL_SIZE -1 ];
  genvar gv_i;
  generate
    for (gv_i = 0; gv_i < `IF_WIDTH ; gv_i  = gv_i + 1)
    begin : parallel_activation
      column_parallel #(
      )
      column_parallel (
      .clk          ( clk                   ), 
      .reset        ( reset                 ), 
      .mode         ( mode                  ),
      .wr_req_p     ( wr_req_act              ),  //input
      .wr_data_p    ( wr_data_act[gv_i]       ), 

      .rd_en        ( rd_req_act_flag_d     ),//rd_req_act valid
      .rd_req_p     ( rd_req_act[gv_i]      ), 
      .rd_data_p    ( rd_data_act[gv_i]       )
      );
    end
  endgenerate
///////////////////////// MODE 0 //////////////////////////////////////////////////////
  delay #(
    .DATA_WIDTH(1)
    )
  delay_rd_req_act_flag(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_act_flag),
    .stride( 1 ),
    .delay_num_clk( 1 ),
    .delay_out(rd_req_act_flag_d)
    ); 
  wire refresh_seq;
  assign refresh_seq = !mode && rd_req_act_flag_d;
 //only for mode0
  seq2index #(
    .DATA_WIDTH (`IF_WIDTH),
    .INDEX_WIDTH(`ACT_INDEX_WIDTH)
    )
  seq2index_act(
    .clk        (clk),
    .reset      (reset),
    .refresh_seq(refresh_seq),
    .seq        (rd_data_act_flag),
    .index      (valid_act_index) 
    );

  delay #(
    .DATA_WIDTH( `ACT_INDEX_WIDTH )
    )
  delay_valid_act_index(
    .clk(clk),
    .reset(reset),
    .delay_in(valid_act_index),
    .stride( 1 ),
    .delay_num_clk( 1 ),
    .delay_out(valid_act_index_d)
    ); 
  assign serial_act = mode ? 8'bz: rd_data_act [ valid_act_index_d ];
  wire [ `ACT_INDEX_WIDTH   : 0 ] row_val_num_in;
  assign row_val_num_in = rd_data_act_flag [ 15 ]+ rd_data_act_flag [ 14 ]+ rd_data_act_flag [ 13 ]+ rd_data_act_flag [ 12 ]+
                          rd_data_act_flag [ 11 ]+ rd_data_act_flag [ 10 ]+ rd_data_act_flag [ 9  ]+ rd_data_act_flag [ 8  ]+ 
                          rd_data_act_flag [ 7  ]+ rd_data_act_flag [ 6  ]+ rd_data_act_flag [ 5  ]+ rd_data_act_flag [ 4  ]+ 
                          rd_data_act_flag [ 3  ]+ rd_data_act_flag [ 2  ]+ rd_data_act_flag [ 1  ]+ rd_data_act_flag [ 0  ] ;
  seq2parallel#(
    .IN_WIDTH ( `ACT_INDEX_WIDTH + 1 ),
    .OUT_WIDTH( (`ADDR_WIDTH + 1) * `KERNEL_WIDTH )
    )
  seq2parallel_row_val_num_array(
    .clk                   (clk),
    .reset                 (reset),
    .mode                  (mode),
    .in_serial             (row_val_num_in),
    .begin_serial_in       ( ),
    .refresh_parallel_array( ),
    .parallel_array        ( row_val_num_array )
    );

//////////////////////// MODE 1 //////////////////////////////////////////////////////////////////////
  assign parallel_act = mode? {  rd_data_act [ 15 ], rd_data_act [ 14 ], rd_data_act [ 13 ], rd_data_act [ 12 ],
                          rd_data_act [ 11 ], rd_data_act [ 10 ], rd_data_act [ 9 ], rd_data_act [ 8 ], 
                          rd_data_act [ 7 ],  rd_data_act [ 6 ], rd_data_act [ 5 ], rd_data_act [ 4 ], 
                          rd_data_act [ 3 ],  rd_data_act [ 2 ], rd_data_act [ 1 ], rd_data_act [ 0 ] } : 128'bz;

endmodule // activation
