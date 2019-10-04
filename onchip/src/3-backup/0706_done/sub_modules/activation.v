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
    input                                       row_cal_done      ,
    input [ `WEI_INDEX_WIDTH              : 0 ] state             ,
    input [ `WEI_INDEX_WIDTH              : 0 ] next_state        ,
    input                                       row_cal_done_3 ,
    input                                       zero_flag         ,
    output [ `ACT_INDEX_WIDTH         - 1 : 0 ] valid_act_index   ,// not influenced by rd_req_act_flag_d
    output [ `DATA_WIDTH              - 1 : 0 ] act_serial_out    ,//
    output reg [ (`ADDR_WIDTH + 1)    - 1 : 0 ] row_val_num_act_real,//
);

  wire                                  read_req_pflag;
  wire [ `IF_WIDTH            - 1 : 0 ] rd_data_act_flag ;
  wire                                  rd_req_act_flag;
  wire                                  rd_req_act_flag_d;
  wire [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_act_index_d;
  wire                                  rd_req_act_flag_paulse, rd_req_act_flag_paulse_d;
  wire                                  rd_req_act_flag_0;
  wire [ `IF_WIDTH            - 1 : 0 ] rd_req_act;
  wire                                  rd_en_act;
  wire [ `DATA_WIDTH          - 1 : 0 ] rd_data_act [ 0 : `IF_WIDTH -1 ];
  wire                                  refresh_seq;
  wire [ `ACT_INDEX_WIDTH         : 0 ] row_val_num_in;
 


  assign rd_data_act_flag = ft_mem_flag[ row_index ];
///////////////////////// MODE 0 //////////////////////////////////////////////////////
 
  assign refresh_seq = !mode && (en || row_cal_done );
 //only for mode0
  seq2index #(
    .DATA_WIDTH (`IF_WIDTH),
    .INDEX_WIDTH(`ACT_INDEX_WIDTH)
    )
  seq2index_act(
    .clk        ( clk             ),
    .reset      ( reset           ),
    .refresh_seq( refresh_seq     ),
    .seq        ( rd_data_act_flag),
    .shift      ( refresh_seq),
    .index      ( valid_act_index ) 
    );

  assign row_val_num_in = mode? 4'bz: (rd_data_act_flag [ 15 ]+ rd_data_act_flag [ 14 ]+ rd_data_act_flag [ 13 ]+ rd_data_act_flag [ 12 ]+
                          rd_data_act_flag [ 11 ]+ rd_data_act_flag [ 10 ]+ rd_data_act_flag [ 9  ]+ rd_data_act_flag [ 8  ]+ 
                          rd_data_act_flag [ 7  ]+ rd_data_act_flag [ 6  ]+ rd_data_act_flag [ 5  ]+ rd_data_act_flag [ 4  ]+ 
                          rd_data_act_flag [ 3  ]+ rd_data_act_flag [ 2  ]+ rd_data_act_flag [ 1  ]+ rd_data_act_flag [ 0  ] );
  always @(posedge clk or negedge reset ) begin : proc_row_val_num_act_real
    if(~reset) begin
      row_val_num_act_real <= 0;
    end else if( mode )begin
      row_val_num_act_real <= 0;
    end else if( en || row_cal_done ) begin
      row_val_num_act_real <= row_val_num_in;
    end
  end
///////////////////////// DELAY //////////////////////////////////////////////////////////////////////
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_act_flag_paulse_d(
    .clk          ( clk                     ),
    .reset        ( reset                   ),
    .delay_in     ( rd_req_act_flag_paulse  ),
    .delay_num_clk( 2'd1                    ),
    .delay_out    ( rd_req_act_flag_paulse_d)
    ); 
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_act_flag_paulse_dd(
    .clk          ( clk                       ),
    .reset        ( reset                     ),
    .delay_in     ( rd_req_act_flag_paulse_d  ),
    .delay_num_clk( 2'd1                      ),
    .delay_out    ( rd_req_act_flag_paulse_dd )
    ); 
  delay #(
    .DATA_WIDTH(1)
    )
  delay_rd_req_act_flag_d(
    .clk          ( clk               ),
    .reset        ( reset             ),
    .delay_in     ( rd_req_act_flag   ),
    .delay_num_clk( 2'd1              ),
    .delay_out    ( rd_req_act_flag_d )
    );
  delay #(
    .DATA_WIDTH( `ACT_INDEX_WIDTH )
    )
  delay_valid_act_index(
    .clk          ( clk               ),
    .reset        ( reset             ),
    .delay_in     ( valid_act_index   ),
    .delay_num_clk( 2'd1              ),
    .delay_out    ( valid_act_index_d )
    ); 
endmodule // activation
