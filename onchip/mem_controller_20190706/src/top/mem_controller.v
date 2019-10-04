//======================================================
// Copyright (C) 2019 By ZHOU
// mail@Changchun.zhou, All Rights Reserved
//======================================================
// Module : mem_controller
// Author : Changchun.zhou
// Contact : zhouchch@pku.edu.cn
// Date : June.30.2019
//=======================================================
// Description :  1.sub_memory between global MEM and PE array
//                2.NOT sparsity
//                3.16x16x8 = 256B FF
//========================================================

`include "def_params.vh" 
module mem_controller (
	input	wire	                        clk,    // Clock
	input	wire	                        reset,  // Asynchronous reset active low
//initial
  input                               wr_req_act_flag,   
  input [ `IF_WIDTH         - 1 : 0 ] wr_data_act_flag,
  input                               wr_req_act,
  input [ `FM_DATA_WIDTH    - 1 : 0 ] wr_data_act,
  input                               wr_req_wei_flag,
  input [ `KERNEL_SIZE      - 1 : 0 ] wr_data_wei_flag,
  input                               wr_req_wei,
  input [ `DATA_WIDTH       - 1 : 0 ] wr_data_wei,
  input                               mode,   //
  input                               start,

  output reg                          en,
  output reg [ 2                : 0 ] state,
  output [ `PARALLEL_WIDTH  - 1 : 0 ] parallel_out,
  output [ `DATA_WIDTH      - 1 : 0 ] serial_out,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] act_index,
  output [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_col_index, // only [1:0] for mode1
  output [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_row_index,
  output reg[`ACT_INDEX_WIDTH-1 : 0 ] row_index,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] row_val_num, //0->1 1->2 2->3  4 bit
  output                              zero_flag,  //0

  input  [ `ACT_INDEX_WIDTH - 1 : 0 ] cnt,
  input                               wait_state,
  output                               row_finish_done_0, //weight loop
  input                               row_finish_done_1,  //activation loop not used
  output                               row_cal_done 
);
//========================================================================================================
// Constant Definition :
//========================================================================================================
//local parameter 

//========================================================================================================
// FF Definition :
//========================================================================================================
  reg  [ `FM_DATA_WIDTH                           - 1 : 0 ] fm_mem      [ `FM_WIDTH * `IF_WIDTH     - 1 : 0 ];
  reg  [ `IF_WIDTH                                - 1 : 0 ] fm_flag_mem [ `IF_WIDTH                 - 1 : 0 ];
  reg  [ `DATA_WIDTH                              - 1 : 0 ] ft_mem      [ `KERNEL_SIZE              - 1 : 0 ];
  reg  [ `KERNEL_SIZE                             - 1 : 0 ] ft_flag_mem                                      ;

//========================================================================================================
// Variable Definition :
//=======================================================================================================
  reg  [ 2                                            : 0 ] next_state;
  wire [ `ACT_INDEX_WIDTH                         - 1 : 0 ] valid_act_index;
  wire [ `ACT_INDEX_WIDTH                         - 1 : 0 ] valid_act_index_d;
  reg  [ `ACT_INDEX_WIDTH                         - 1 : 0 ] act_index_1;
  reg  [ `FM_DATA_WIDTH * 6                       - 1 : 0 ] act_array;
  reg  [ `DATA_WIDTH * `KERNEL_SIZE               - 1 : 0 ] parallel_out_wei;
  reg  [ `PARALLEL_WIDTH                          - 1 : 0 ] parallel_out_act;
  wire [ `WEI_INDEX_WIDTH                         - 1 : 0 ] wei_col_index_d;
  wire [ `WEI_INDEX_WIDTH * 2                     - 1 : 0 ] wei_index_comb;
  wire [ 2                                        - 1 : 0 ] row_val_num_wei_real;
  reg  [ 5                                        - 1 : 0 ] row_val_num_act_real;
  wire                                                      row_cal_done_3;
  reg  [ `DATA_WIDTH                              - 1 : 0 ] act_serial_out;
  wire [ `DATA_WIDTH                              - 1 : 0 ] wei_serial_out;
  
  reg  [ `ACT_INDEX_WIDTH                         - 1 : 0 ] wr_addr_act_flag;
  reg  [ 7                                        - 1 : 0 ] wr_addr_act;
  reg  [ 4                                        - 1 : 0 ] wr_addr_wei;
  wire                                                      refresh_seq;
  reg [ `IF_WIDTH                                - 1 : 0 ] fm_flag_array;
  wire [ `DATA_WIDTH * `KERNEL_SIZE               - 1 : 0 ] wei_array_full;
  reg  [ 7                                        - 1 : 0 ] count_block ;
  reg                                                       next_block;
  wire                                                      refresh_act_array;
  wire [ `ACT_INDEX_WIDTH                         - 1 : 0 ] count_val_num;
  wire                                                      val_num_equal_d;
//=========================================================================================================
// Logic Design :
//=========================================================================================================
// FSM-state
  always @(posedge clk or negedge reset) begin : proc_state
    if(~reset) begin
      state <= `PREP;
    end else begin
      state <= next_state;
    end
  end
  always @( * ) begin : proc_next_state
    if(~reset) begin
      next_state = `PREP;
    end else begin
      case (state)
        `PREP:  if ( en )
                  next_state = `TRAN;
                else
                  next_state = `PREP;

        `TRAN:  if ( wait_state )
                  next_state = `WAIT;
                else
                  next_state = `COMP;
        `COMP:  if ( row_cal_done )
                  next_state = `TRAN;
                else
                  next_state = `COMP;
        `WAIT:  if( wait_state )
                  next_state = `WAIT;
                else
                  next_state = `COMP;
        default:  next_state = `PREP;
      endcase
    end
  end
 //=================================================================================================================
// MEMORY :
//==================================================================================================================
  always @(posedge clk or negedge reset) begin : proc_wr_addr_act_flag
    if(~reset) begin
      wr_addr_act_flag <= 0;
    end else if( wr_req_act_flag ) begin
      wr_addr_act_flag <= wr_addr_act_flag + 1;
    end
  end
  always @(posedge clk or negedge reset) begin : proc_fm_flag_mem
    if(~reset) begin
//      fm_flag_mem <= 0;
    end else if( wr_req_act_flag ) begin
      fm_flag_mem[wr_addr_act_flag] <= wr_data_act_flag;
    end
  end

  always @(posedge clk or negedge reset) begin : proc_wr_addr_act
    if(~reset) begin
      wr_addr_act <= 0;
    end else if( wr_req_act ) begin
      wr_addr_act <= wr_addr_act + 1;
    end
  end
  always @(posedge clk or negedge reset) begin : proc_fm_mem
    if(~reset) begin
//      fm_mem <= 0;
    end else if( wr_req_act )begin
      fm_mem[wr_addr_act] <= wr_data_act;
    end
  end

//weight
  // always @(posedge clk or negedge reset) begin : proc_ft_flag_mem
  //   if(~reset) begin
  //     ft_flag_mem <= 0;
  //   end else if( wr_req_wei_flag )begin
  //     ft_flag_mem <= wr_data_wei_flag;
  //   end
  // end

  always @(posedge clk or negedge reset) begin : proc_wr_addr_wei
    if(~reset) begin
      wr_addr_wei <= 0;
    end else if( wr_req_wei ) begin
      wr_addr_wei <= wr_addr_wei + 1;
    end
  end
  always @(posedge clk or negedge reset) begin : proc_ft_mem
    if(~reset) begin
//      ft_mem <= 0;
    end else if(wr_req_wei )begin
      ft_mem[wr_addr_wei] <= wr_data_wei;
    end
  end

 //--OUTPUT  --
  always @(posedge clk or negedge reset) begin : proc_en
      if(~reset) begin
        en <= 0;
      end else begin
        en <= start;
      end
  end
  assign parallel_out = mode ? parallel_out_act : parallel_out_wei;
  assign serial_out = mode? wei_serial_out : act_serial_out;
  assign act_index = mode? act_index_1 : valid_act_index_d;
  assign row_val_num = mode?  (row_val_num_wei_real - 1) : (row_val_num_act_real - 1);
  assign zero_flag   = row_val_num == 15;  //0 weight 4'd0 - 1 = 15
  
  assign row_finish_done_0 = mode? state==`COMP && (zero_flag || val_num_equal_d ) : row_cal_done;
  assign row_cal_done = mode? state == `COMP && zero_flag || act_index == 4'd14 : state == `COMP && zero_flag || val_num_equal_d; //MODE 1

  loop_count#(
    .DATA_WIDTH( `ACT_INDEX_WIDTH )
    )
  loop_count_count_val_num(
    .clk            ( clk                         ),
    .reset          ( reset                       ),
    .reset2         ( next_state==`TRAN),//en || row_cal_done || !mode
    .count_condition( next_state == `COMP         ),//( state != `PREP              ),
    .max            ( row_val_num    ), //
    .stride         ( 4'd1                        ),
    .count          ( count_val_num               )
    );

//=================================================================================================================
// Activation :
//=================================================================================================================

  always @(posedge clk or negedge reset) begin : proc_count_block
    if(~reset) begin
      count_block <= 0;
    end else if( refresh_act_array ) begin
      if( count_block%6 == 5 )begin
        if ( wei_row_index != 2 )
          count_block <= count_block - 5;
        else  //next row
          count_block <= count_block + 13;
      end else
        count_block <= count_block + 1;
    end
  end

  assign refresh_act_array = mode && ( start || (next_state==`TRAN && !zero_flag)  ||(state != `PREP && count_val_num == (row_val_num_wei_real - 1)) );// initial-B1B0 + valid_num
  always @(posedge clk or negedge reset) begin : proc_act_array
    if(~reset) begin
      act_array <= 0;
    end else if( refresh_act_array ) begin //start, en, second activation push
      act_array <= {fm_mem[ count_block + 12 ],
                    fm_mem[ count_block + 6  ],
                    fm_mem[ count_block      ],
                    act_array[`FM_DATA_WIDTH*6 - 1 : `FM_DATA_WIDTH*3]};
    end else if(!mode && row_cal_done ) begin
      act_array <= {fm_mem[ (row_index + 1) *6 + 5 ], fm_mem[ (row_index + 1)*6 + 4 ], fm_mem[ (row_index + 1)*6 + 3 ],
                    fm_mem[ (row_index + 1) *6 + 2 ], fm_mem[ (row_index + 1)*6 + 1 ], fm_mem[ (row_index + 1)*6 + 0 ]};//
    end else if( !mode && en )  begin //initial
      act_array <= {fm_mem[ 5 ], fm_mem[ 4 ], fm_mem[ 3 ],
                    fm_mem[ 2 ], fm_mem[ 1 ], fm_mem[ 0 ]};//
    end
  end
  assign wei_index_comb = { wei_col_index_d, wei_col_index };
  // Maybe not necessary
  always @(posedge clk or negedge reset) begin : proc_act_index_1_parallel_out_act
    if(~reset) begin
      act_index_1 <= 0;
      parallel_out_act <= 0;
      next_block <= 0;
    end else if(mode) begin
      //every row initial
      if( state == `TRAN) begin
        act_index_1 <= wei_col_index;
        parallel_out_act <= { act_array[  ( wei_col_index + 2 > 2?  wei_col_index + 14 :wei_col_index + 8) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[ ( wei_col_index + 1 > 2?  wei_col_index + 13 :wei_col_index + 7) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  ( wei_col_index + 6 )* `DATA_WIDTH +: `DATA_WIDTH ],  
                              act_array[  ( wei_col_index + 2 > 2?  wei_col_index + 11 :wei_col_index + 5) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[ ( wei_col_index + 1 > 2?  wei_col_index + 10 :wei_col_index + 4) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  ( wei_col_index + 3 )* `DATA_WIDTH +: `DATA_WIDTH ],  
                              act_array[  ( wei_col_index + 2 > 2?  wei_col_index +  8 :wei_col_index + 2) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[ ( wei_col_index + 1 > 2?  wei_col_index +  7 :wei_col_index + 1) * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  ( wei_col_index     )* `DATA_WIDTH +: `DATA_WIDTH ] };
        next_block <= 1;
      //every row end
      end else if( row_cal_done ) begin
        act_index_1 <= 0;
        parallel_out_act <= 0;
      //every row compute
      end else if( state == `COMP )
        case ( wei_index_comb ) 
          4'b00_00 :  begin 
                        act_index_1 <= act_index_1 + 3;
                        next_block <= 1;
                        parallel_out_act <= { act_array[0 +: `DATA_WIDTH*9] };//high half
                      end
          4'b00_01 :  begin
                        act_index_1 <= act_index_1 + 1;
                        next_block <= 0;
                        parallel_out_act <= { act_array[ 15* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[ 12* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[  9* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0 };
                      end                      
          4'b00_10 :  begin
                        act_index_1 <= act_index_1 + 2;
                        next_block <= 0;
                        parallel_out_act <= { act_array[ 15 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0, 
                                              act_array[ 12 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0, 
                                              act_array[  9 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0 };
                      end
          4'b01_00 :  begin
                        act_index_1 <= act_index_1 + 2;
                        next_block <= 1;
                        parallel_out_act <= { act_array[  7 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0, 
                                              act_array[  4 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0, 
                                              act_array[  1 * `DATA_WIDTH +: `DATA_WIDTH *2], 8'd0 };
                      end
          4'b01_01 :  begin
                        act_index_1 <= act_index_1 + 3;
                        next_block <= 1;
                        parallel_out_act <= { act_array[  15 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  7 * `DATA_WIDTH +: `DATA_WIDTH *2],  
                                              act_array[  12 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  4 * `DATA_WIDTH +: `DATA_WIDTH *2],  
                                              act_array[   9 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  1 * `DATA_WIDTH +: `DATA_WIDTH *2] };
                      end
          4'b01_10 :  begin
                        act_index_1 <= act_index_1 + 1;
                        next_block <= 0;
                        parallel_out_act <= { act_array[ 16* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[ 13* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[ 10* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0 };
                      end
          4'b10_00 :  begin
                        act_index_1 <= act_index_1 + 1;
                        next_block <= 1;
                        parallel_out_act <= { act_array[  8* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[  5* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0,
                                              act_array[  2* `DATA_WIDTH +: `DATA_WIDTH ], 8'd0, 8'd0 };
                      end
          4'b10_01 :  begin
                        act_index_1 <= act_index_1 + 2;
                        next_block <= 1;
                        parallel_out_act <= { act_array[  15 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  8 * `DATA_WIDTH +: `DATA_WIDTH ], 8'd0,  
                                              act_array[  12 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  5 * `DATA_WIDTH +: `DATA_WIDTH ], 8'd0,  
                                              act_array[   9 * `DATA_WIDTH +: `DATA_WIDTH ], act_array[  2 * `DATA_WIDTH +: `DATA_WIDTH ], 8'd0 };
                      end
          4'b10_10 :  begin
                        act_index_1 <= act_index_1 + 3;
                        next_block <= 1;
                        parallel_out_act <= { act_array[  15 * `DATA_WIDTH +: `DATA_WIDTH *2 ], act_array[  8 * `DATA_WIDTH +: `DATA_WIDTH ],  
                                              act_array[  12 * `DATA_WIDTH +: `DATA_WIDTH *2 ], act_array[  5 * `DATA_WIDTH +: `DATA_WIDTH ],  
                                              act_array[   9 * `DATA_WIDTH +: `DATA_WIDTH *2 ], act_array[  2 * `DATA_WIDTH +: `DATA_WIDTH ] };
                      end
          default  :  begin
                        act_index_1 <= 4'bzzzz;
                        next_block <= 0;
                        parallel_out_act <= 72'bz;
                      end
        endcase
    end
  end

//--ROW_INDEX 
 always @ (posedge clk or negedge reset) begin
  if(~reset) begin
    if (mode == 1)
       row_index <= 2;
    else 
      row_index <= 0;
  end else if( mode == 1 && row_cal_done_3 ) begin//
    row_index <= row_index + 3;
  end else if( mode == 0 && state==`COMP && next_state==`TRAN ) begin//
    row_index <= row_index + 1;
  end else 
    row_index <= row_index;
 end


 always @(posedge clk or negedge reset) begin : proc_act_serial_out
   if(~reset) begin
     act_serial_out <= 0;
   end else if ( !mode ) begin
    act_serial_out <= act_array[ `DATA_WIDTH * valid_act_index +: `DATA_WIDTH ];
   end
 end

  assign refresh_seq = !mode && (en || row_cal_done );
 // assign fm_flag_array = state == `PREP? fm_flag_mem[0] : fm_flag_mem[ row_index  + 1];
 always @(posedge clk or negedge reset) begin : proc_fm_flag_array
   if(~reset) begin
     fm_flag_array <= 0;
   end else if( next_state == `PREP) begin
     fm_flag_array <= fm_flag_mem[0];
   end else if( state == `PREP && next_state == `TRAN ) begin
     fm_flag_array <= fm_flag_mem[1];
   end else if ( next_state == `TRAN ) begin
     fm_flag_array <= fm_flag_mem[row_index + 2];
   end
 end
 //only for mode0
  seq2index #(
    .DATA_WIDTH (`IF_WIDTH),
    .INDEX_WIDTH(`ACT_INDEX_WIDTH)
    )
  seq2index_act(
    .clk        ( clk             ),
    .reset      ( reset           ),
    .refresh_seq( refresh_seq     ),
    .seq        ( fm_flag_array   ),//
    .shift      ( !wait_state || state==`WAIT && next_state==`COMP ),//`TRAN + `COMP
    .index      ( valid_act_index ) 
    );
  always @(posedge clk or negedge reset ) begin : proc_row_val_num_act_real
    if(~reset) begin
      row_val_num_act_real <= 0;
    end else if( mode )begin
      row_val_num_act_real <= 0;
    end else if( en || row_cal_done ) begin
      row_val_num_act_real <=   fm_flag_array [ 15 ]+ fm_flag_array [ 14 ]+ fm_flag_array [ 13 ]+ fm_flag_array [ 12 ]+
                                fm_flag_array [ 11 ]+ fm_flag_array [ 10 ]+ fm_flag_array [ 9  ]+ fm_flag_array [ 8  ]+ 
                                fm_flag_array [ 7  ]+ fm_flag_array [ 6  ]+ fm_flag_array [ 5  ]+ fm_flag_array [ 4  ]+ 
                                fm_flag_array [ 3  ]+ fm_flag_array [ 2  ]+ fm_flag_array [ 1  ]+ fm_flag_array [ 0  ] ;
    end
  end

//=================================================================================================================
// Weight :
//================================================================================================================
  always @(posedge clk or negedge reset) begin : proc_parallel_out_wei
    if(~reset) begin
      parallel_out_wei <= 0;
    end else if( !mode ) begin
      parallel_out_wei <= wei_array_full;
    end
  end
  assign wei_array_full = { ft_mem[8], ft_mem[7], ft_mem[6],
                            ft_mem[5], ft_mem[4], ft_mem[3],
                            ft_mem[2], ft_mem[1], ft_mem[0] };
  weight
  weight(
    .clk                  ( clk                   ),
    .reset                ( reset                 ),
    .mode                 ( mode                  ),
    .en                   ( en                    ),
    .state                ( state                 ),
    .next_state           ( next_state            ),
    .row_cal_done         ( row_cal_done          ),
    .wr_req_wei_flag      ( wr_req_wei_flag       ),
    .wr_data_wei_flag     ( wr_data_wei_flag      ),
    .wei_array_full       ( wei_array_full        ),
    .wei_col_index        ( wei_col_index         ),
    .wei_row_index        ( wei_row_index         ),
    .row_val_num_wei_real ( row_val_num_wei_real  ),
    .wei_serial_out       ( wei_serial_out        ),
    .row_cal_done_3       ( row_cal_done_3        ),
    .count_val_num        ( count_val_num         )

    );


//--DELAY 
  delay #(
    .DATA_WIDTH(`ACT_INDEX_WIDTH)
    )
  delay_rd_req_act_flag(
    .clk          ( clk             ),
    .reset        ( reset           ),
    .delay_in     ( valid_act_index ),
    .delay_num_clk( 2'd1            ),
    .delay_out    ( valid_act_index_d)
    );

  delay #(
    .DATA_WIDTH( `WEI_INDEX_WIDTH )
    )
  delay_wei_index(
    .clk          ( clk           ),
    .reset        ( reset         ),
    .delay_in     ( wei_col_index ),
    .delay_num_clk( 2'd1          ),
    .delay_out    ( wei_col_index_d   )
    );
  delay #(
    .DATA_WIDTH( 1'b1 )
    )
  delay_val_num_equal_d(
    .clk          ( clk           ),
    .reset        ( reset         ),
    .delay_in     ( count_val_num == row_val_num ),
    .delay_num_clk( 2'd1          ),
    .delay_out    ( val_num_equal_d   )
    );
  
  // delay #(
  //   .DATA_WIDTH( 1 )
  //   )
  // delay_refresh_act_array_d(
  //   .clk          ( clk           ),
  //   .reset        ( reset         ),
  //   .delay_in     ( count_block_plus ),
  //   .delay_num_clk( 2'd1          ),
  //   .delay_out    ( count_block_plus_d   )
  //   );

endmodule
