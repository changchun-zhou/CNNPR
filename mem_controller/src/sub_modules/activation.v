`include "def_params.vh" 
module activation #(
  parameter READ_REQ_ACT = 16'b000_0000_0000_0001
)
(
    input                                       clk               ,
    input                                       reset             ,
    input                                       mode              ,
    input                                       en                ,
    input                                       start             ,
    input                                       wr_req_act_flag   ,
    input [ `IF_WIDTH                 - 1 : 0 ] wr_data_act_flag  ,
    input [ `IF_WIDTH                 - 1 : 0 ] wr_req_act        ,
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
    input                                       row_cal_done      ,
    input [ `WEI_INDEX_WIDTH              : 0 ] state             ,
    input                                       row_index_count_3 ,
    input                                       zero_flag         ,
    output [ `ACT_INDEX_WIDTH         - 1 : 0 ] valid_act_index   ,// not influenced by rd_req_act_flag_d
    output [ `DATA_WIDTH              - 1 : 0 ] act_serial_out        ,//
    output [ `DATA_WIDTH * `IF_WIDTH  - 1 : 0 ] parallel_act      ,//
    output reg [ (`ADDR_WIDTH + 1)    - 1 : 0 ] row_val_num_act_real,//
    output                                      rd_req_act_flag_paulse_dd//

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
  wire                                  rd_req_act_flag_paulse, rd_req_act_flag_paulse_d;
  wire                                  rd_req_act_flag_0;
  
  assign rd_req_act_flag_paulse = start | en | row_index_count_3;
  assign rd_req_act_flag_0      = start | en | row_cal_done;
  assign rd_req_act_flag = mode ? ( rd_req_act_flag_paulse | rd_req_act_flag_paulse_d | rd_req_act_flag_paulse_dd ) : rd_req_act_flag_0;
  ram # (
    .DATA_WIDTH( `IF_WIDTH    ),
    .ADDR_WIDTH( `ADDR_WIDTH  )
    )
  ram_act_flag (
    .clk          ( clk           ),
    .reset        ( reset         ),
    .wr_req       ( wr_req_act_flag   ),
    .wr_data      ( wr_data_act_flag  ),

    .rd_req   ( rd_req_act_flag ),
    .rd_data  ( rd_data_act_flag   )
    );
  
  wire [ `IF_WIDTH     - 1 : 0 ] rd_req_act;
  assign rd_req_act = mode? rd_data_act_flag : READ_REQ_ACT <<< valid_act_index;//mode0: only read a column.
  wire  [ `DATA_WIDTH  - 1 : 0 ] rd_data_act [ 0 : `IF_WIDTH -1 ];
  wire rd_en_act;
  assign rd_en_act = mode? rd_req_act_flag_d : (state != `PREP && !row_cal_done && !zero_flag);
  genvar gv_i;
  generate
    for (gv_i = 0; gv_i < `IF_WIDTH ; gv_i  = gv_i + 1)
    begin : parallel_activation
      column_parallel 
      column_parallel (
      .clk          ( clk                   ), 
      .reset        ( reset                 ), 
      .mode         ( mode                  ),
      .wr_req_p     ( wr_req_act[gv_i]              ),  //input
      .wr_data_p    ( wr_data_act[gv_i]       ), 

      .rd_en        ( rd_en_act  ),//rd_en is for mode0-READ_REQ_ACT: not state=PREP, row_cal_done stop read act
      .rd_req_p     ( rd_req_act[gv_i]      ), 
      .rd_data_p    ( rd_data_act[gv_i]       )
      );
    end
  endgenerate

///////////////////////// MODE 0 //////////////////////////////////////////////////////
  wire refresh_seq;
  assign refresh_seq = !mode && (en || row_cal_done );
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

  assign act_serial_out = mode ? 8'bz: rd_data_act [ valid_act_index_d ];
  wire [ `ACT_INDEX_WIDTH   : 0 ] row_val_num_in;
  assign row_val_num_in = mode? 4'bz: (rd_data_act_flag [ 15 ]+ rd_data_act_flag [ 14 ]+ rd_data_act_flag [ 13 ]+ rd_data_act_flag [ 12 ]+
                          rd_data_act_flag [ 11 ]+ rd_data_act_flag [ 10 ]+ rd_data_act_flag [ 9  ]+ rd_data_act_flag [ 8  ]+ 
                          rd_data_act_flag [ 7  ]+ rd_data_act_flag [ 6  ]+ rd_data_act_flag [ 5  ]+ rd_data_act_flag [ 4  ]+ 
                          rd_data_act_flag [ 3  ]+ rd_data_act_flag [ 2  ]+ rd_data_act_flag [ 1  ]+ rd_data_act_flag [ 0  ] );
  always @(posedge clk or negedge reset ) begin : proc_row_val_num_act_real
    if(~reset || mode) begin
      row_val_num_act_real <= 0;
    end else if( en || row_cal_done ) begin
      row_val_num_act_real <= row_val_num_in;
    end
  end
//////////////////////// MODE 1 //////////////////////////////////////////////////////////////////////
  assign parallel_act = mode? {  rd_data_act [ 15 ], rd_data_act [ 14 ], rd_data_act [ 13 ], rd_data_act [ 12 ],
                          rd_data_act [ 11 ], rd_data_act [ 10 ], rd_data_act [ 9 ], rd_data_act [ 8 ], 
                          rd_data_act [ 7 ],  rd_data_act [ 6 ], rd_data_act [ 5 ], rd_data_act [ 4 ], 
                          rd_data_act [ 3 ],  rd_data_act [ 2 ], rd_data_act [ 1 ], rd_data_act [ 0 ] } : 128'bz;

///////////////////////// DELAY //////////////////////////////////////////////////////////////////////
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_act_flag_paulse_d(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_act_flag_paulse),
    .delay_num_clk( 2'd1 ),
    .delay_out(rd_req_act_flag_paulse_d)
    ); 
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_act_flag_paulse_dd(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_act_flag_paulse_d),
    .delay_num_clk( 2'd1 ),
    .delay_out(rd_req_act_flag_paulse_dd)
    ); 
  delay #(
    .DATA_WIDTH(1)
    )
  delay_rd_req_act_flag_d(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_act_flag),
    .delay_num_clk( 2'd1 ),
    .delay_out(rd_req_act_flag_d)
    );
  delay #(
    .DATA_WIDTH( `ACT_INDEX_WIDTH )
    )
  delay_valid_act_index(
    .clk(clk),
    .reset(reset),
    .delay_in(valid_act_index),
    .delay_num_clk( 2'd1 ),
    .delay_out(valid_act_index_d)
    ); 
endmodule // activation
