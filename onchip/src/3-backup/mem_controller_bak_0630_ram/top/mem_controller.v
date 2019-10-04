//======================================================
// Copyright (C) 2019 By ZHOU
// mail@Changchun.zhou, All Rights Reserved
//======================================================
// Module : mem_controller
// Author : Changchun.zhou
// Contact : zhouchch@pku.edu.cn
// Date : June.23.2019
//=======================================================
// Description : wait_state ahead 1 clk over `WAIT
//========================================================

`include "def_params.vh" 
module mem_controller #(
  parameter READ_REQ_ACT_FLAG = 9'b000_000_111,
  parameter NUM = 3

)(
	input	wire	                        clk,    // Clock
	input	wire	                        reset,  // Asynchronous reset active low
//initial
  input                               wr_req_act_flag,   
  input [ `IF_WIDTH         - 1 : 0 ] wr_data_act_flag,
  input [ `IF_WIDTH         - 1 : 0 ] wr_req_act,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act0 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act1 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act2 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act3 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act4 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act5 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act6 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act7 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act8 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act9 ,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act10,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act11,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act12,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act13,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act14,
  input [ `DATA_WIDTH       - 1 :0]   wr_data_act15,
  input                               wr_req_wei_flag,
  input [ `KERNEL_SIZE      - 1 : 0 ] wr_data_wei_flag,
  input                               wr_req_wei,
  input [ `DATA_WIDTH       - 1 : 0 ] wr_data_wei,
  input                               mode,   //
  input                               start,

  output                              en,
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
  input                               row_finish_done_0, //weight loop
  input                               row_finish_done_1,  //activation loop not used
  input                               row_cal_done 
);
//========================================================================================================
// Constant Definition :
//========================================================================================================
//local parameter 

//========================================================================================================
// Variable Definition :
//========================================================================================================
  reg  [ 2                                            : 0 ] state;
  reg  [ 2                                            : 0 ] next_state;
  wire [ `ACT_INDEX_WIDTH                         - 1 : 0 ] valid_act_index;
  wire [ `ACT_INDEX_WIDTH                         - 1 : 0 ] valid_act_index_d;
  reg  [ `ACT_INDEX_WIDTH                         - 1 : 0 ] act_index_1;
  wire [ `DATA_WIDTH * `KERNEL_SIZE               - 1 : 0 ] parallel_out_wei;
  reg  [ `PARALLEL_WIDTH                          - 1 : 0 ] parallel_out_act;
  wire [ `WEI_INDEX_WIDTH                         - 1 : 0 ] wei_col_index_d;
  wire [ `WEI_INDEX_WIDTH * 2                     - 1 : 0 ] wei_index_comb;
  wire [ 2                                        - 1 : 0 ] row_val_num_wei_real;
  wire [ 5                                        - 1 : 0 ] row_val_num_act_real;
  wire                                                      row_cal_done_3;
  wire [ `DATA_WIDTH * `IF_WIDTH                  - 1 : 0 ] parallel_act;
  wire [ `DATA_WIDTH * `IF_WIDTH * `KERNEL_WIDTH  - 1 : 0 ] parallel_array;
  wire [ `DATA_WIDTH                              - 1 : 0 ] act_serial_out;
  wire                                                      rd_req_act_flag_paulse_dd;
  wire [ `DATA_WIDTH                              - 1 : 0 ] wei_serial_out;

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
      next_state <= `PREP;
    end else begin
      case (state)
        `PREP: if ( en )
                next_state <= `TRAN;
        `TRAN: if ( wait_state )
                  next_state <= `WAIT;
               else
                  next_state <= `COMP;
        `COMP: if ( row_cal_done )
                next_state <= `TRAN;
        `WAIT: if( wait_state )
                  next_state <= `WAIT;
               else
                  next_state <= `COMP;
        default: next_state <= `PREP;
      endcase
    end
  end
 
 //--OUTPUT  --
  assign parallel_out = mode ? parallel_out_act : parallel_out_wei;
  assign serial_out = mode? wei_serial_out : act_serial_out;
  assign act_index = mode? act_index_1 : valid_act_index_d;
  assign row_val_num = mode?  (row_val_num_wei_real - 1) : (row_val_num_act_real - 1);
  assign zero_flag   = row_val_num == 15;  //0 weight 4'd0 - 1 = 15

  assign wei_index_comb = { wei_col_index_d, wei_col_index };
  always @(posedge clk or negedge reset) begin : proc_act_index_1_parallel_out_act
    if(~reset) begin
      act_index_1 <= 0;
      parallel_out_act <= 0;
    end else if(mode) begin
      //every row initial
      if( state == `TRAN) begin
        act_index_1 <= wei_col_index;
        parallel_out_act <= { parallel_array[ ( wei_col_index  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                            parallel_array[ ( wei_col_index  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                            parallel_array[ ( wei_col_index                   )*`DATA_WIDTH +: 3*`DATA_WIDTH ] };
      //every row end
      end else if( row_cal_done ) begin
        act_index_1 <= 0;
        parallel_out_act <= 0;
      //every row compute
      end else if( state == `COMP )
        case ( wei_index_comb ) 
          4'b00_00 :  begin 
                        act_index_1 <= act_index_1 + 3;
                        parallel_out_act <= { parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 3*`DATA_WIDTH ] };
                      end
          4'b00_01 :  begin
                        act_index_1 <= act_index_1 + 1;
                        parallel_out_act <= { 48'd0, 
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: `DATA_WIDTH ] };
                      end                      
          4'b00_10 :  begin
                        act_index_1 <= act_index_1 + 2;
                        parallel_out_act <= { 24'd0,
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 2*`DATA_WIDTH ] };
                      end
          4'b01_00 :  begin
                        act_index_1 <= act_index_1 + 2;
                        parallel_out_act <= { 24'd0,
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 2*`DATA_WIDTH ] };
                      end
          4'b01_01 :  begin
                        act_index_1 <= act_index_1 + 3;
                        parallel_out_act <= { parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 3*`DATA_WIDTH ] };
                      end
          4'b01_10 :  begin
                        act_index_1 <= act_index_1 + 1;
                        parallel_out_act <= { 48'd0,
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: `DATA_WIDTH ] };
                      end
          4'b10_00 :  begin
                        act_index_1 <= act_index_1 + 1;
                        parallel_out_act <= { 48'd0,
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: `DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: `DATA_WIDTH ] };
                      end
          4'b10_01 :  begin
                        act_index_1 <= act_index_1 + 2;
                        parallel_out_act <= { 24'd0,
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 2*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 2*`DATA_WIDTH ] };
                      end
          4'b10_10 :  begin
                        act_index_1 <= act_index_1 + 3;
                        parallel_out_act <= { parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                                            parallel_array[ ( act_index_1 + 3                   )*`DATA_WIDTH +: 3*`DATA_WIDTH ] };
                      end
          default  :  begin
                        act_index_1 <= 4'bzzzz;
                        parallel_out_act <= 72'bz;
                      end
        endcase
    end
  end

//-- RON_INDEX 
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

//=================================================================================================================
// Sub-Module :
//================================================================================================================
//---ACTIVATION 
  activation #(
     .READ_REQ_ACT( 16'b000_0000_0000_0001 )
    )
  activation_0(
    .clk               ( clk               ),
    .reset             ( reset             ),
    .mode              ( mode              ),
    .en                ( en                ),
    .start             ( start             ),
    .wr_req_act_flag   ( wr_req_act_flag   ),
    .wr_data_act_flag  ( wr_data_act_flag  ),
    .wr_req_act        ( wr_req_act        ),
    .wr_data_act0      ( wr_data_act0      ),
    .wr_data_act1      ( wr_data_act1      ),
    .wr_data_act2      ( wr_data_act2      ),
    .wr_data_act3      ( wr_data_act3      ),
    .wr_data_act4      ( wr_data_act4      ),
    .wr_data_act5      ( wr_data_act5      ),
    .wr_data_act6      ( wr_data_act6      ),
    .wr_data_act7      ( wr_data_act7      ),
    .wr_data_act8      ( wr_data_act8      ),
    .wr_data_act9      ( wr_data_act9      ),
    .wr_data_act10     ( wr_data_act10     ),
    .wr_data_act11     ( wr_data_act11     ),
    .wr_data_act12     ( wr_data_act12     ),
    .wr_data_act13     ( wr_data_act13     ),
    .wr_data_act14     ( wr_data_act14     ),
    .wr_data_act15     ( wr_data_act15     ),
    .row_cal_done      ( row_cal_done      ),
    .state             ( state             ),
    .next_state        ( next_state        ),
    .row_cal_done_3    ( row_cal_done_3    ),
    .zero_flag         ( zero_flag         ),
    .valid_act_index   ( valid_act_index   ),
    .parallel_act      ( parallel_act      ),
    .act_serial_out    ( act_serial_out    ),
    .row_val_num_act_real(row_val_num_act_real),
    .rd_req_act_flag_paulse_dd(rd_req_act_flag_paulse_dd)
    );

  seq2parallel #(
    .IN_WIDTH( `DATA_WIDTH * `IF_WIDTH ),
    .OUT_WIDTH( `DATA_WIDTH * `IF_WIDTH * `KERNEL_WIDTH )
    )
  seq2parallel_parallel_array(
    .clk                    ( clk               ),
    .reset                  ( reset             ),
    .mode                   ( mode              ),
    .in_serial              ( parallel_act      ),
    .begin_serial_in        ( mode && rd_req_act_flag_paulse_dd ),// rd_req_act_flag to rd_data_act
    .refresh_parallel_array ( next_state==`TRAN ),//( en || row_cal_done ), //every row but only third is valid
    .parallel_array         ( parallel_array    )
    );

//---WEIGHT  
  weight
  weight(
    .clk                  ( clk                   ),
    .reset                ( reset                 ),
    .mode                 ( mode                  ),
    .start                ( start                 ),
    .state                ( state                 ),
    .next_state           ( next_state            ),
    .row_cal_done         ( row_cal_done          ),
    .wr_req_wei_flag      ( wr_req_wei_flag       ),
    .wr_data_wei_flag     ( wr_data_wei_flag      ),
    .wr_req_wei           ( wr_req_wei            ),
    .wr_data_wei          ( wr_data_wei           ),
    .wei_col_index        ( wei_col_index         ),
    .wei_row_index        ( wei_row_index         ),
    .row_val_num_wei_real ( row_val_num_wei_real  ),
    .wei_serial_out       ( wei_serial_out        ),
    .parallel_out_wei     ( parallel_out_wei      ),
    .en                   ( en                    ),
    .row_cal_done_3       ( row_cal_done_3        )
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

endmodule
