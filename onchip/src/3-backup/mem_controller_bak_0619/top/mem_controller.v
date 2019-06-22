

module mem_controller #(
  parameter READ_REQ_ACT_FLAG = 9'b000_000_111
  

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
  input [ `KERNEL_SIZE        - 1 : 0 ]  wr_data_wei_flag,

  input                               wr_req_wei,
  input [ `DATA_WIDTH       - 1 : 0 ] wr_data_wei,
  input                               mode,   //
  input                               start,

  output                              en,
  output [ `PARALLEL_WIDTH  - 1 : 0 ] parallel_out,
  output [ `DATA_WIDTH      - 1 : 0 ] serial_out,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] act_index,
  output [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_index, // only [1:0] for mode1
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] row_index,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] row_val_num, //0->1 1->2 2->3  4 bit
  output                              zero_flag,  //0

  input  [ `ACT_INDEX_WIDTH - 1 : 0 ] cnt,
  input                               row_finish_done_0, //weight loop
  input                               row_finish_done_1,  //activation loop not used
  input                               row_cal_done
  
);
  wire [ 1 : 0 ] state;
  wire [ 1 : 0 ] state_parallel;
  wire [ 1 : 0 ] state_serial;

  reg  signed [ `ACT_INDEX_WIDTH   : 0 ] row_index_signed;
  assign  row_index = row_index_signed[3:0];

  wire[ `PARALLEL_WIDTH   - 1 : 0 ] parallel_out_wire;
  wire index_finish;

  wire  [ 5       - 1 : 0 ]     row_val_num_real;
  wire  [ 2       - 1 : 0 ]     row_val_num_wei_real;
  wire  [ 5       - 1 : 0 ]     row_val_num_act_real;
// FSM-state

  FSM_3 #(
    )
  FSM_state (
    .clk(clk),
    .reset(reset),
    .condition0_1( en ), //PREPAR
    .condition1_2 ( 1'b1 ), //WAIT
    .condition2_1( row_cal_done ),//COMPUTE
    .state( state )
    );

 // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //---------------------------------     G L O B A L  ---------------------------------------------------------------------------------------------
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
//---------D E L A Y------------------------
  wire [ `ACT_INDEX_WIDTH - 1 : 0 ] valid_act_index;
  wire [ `ACT_INDEX_WIDTH - 1 : 0 ] valid_act_index_d;
  delay #(
    .DATA_WIDTH(`ACT_INDEX_WIDTH)
    )
  delay_rd_req_act_flag(
    .clk(clk),
    .reset(reset),
    .delay_in(valid_act_index),
    .delay_num_clk( 2'd1 ),
    .delay_out(valid_act_index_d)
    );
//---------------------------------------
//DELAY
  wire [ `WEI_INDEX_WIDTH       - 1 : 0 ]     wei_index_d;
  delay #(
    .DATA_WIDTH( `WEI_INDEX_WIDTH )
    )
  delay_wei_index(
    .clk(clk),
    .reset(reset),
    .delay_in(wei_index),
    .delay_num_clk( 2'd1 ),
    .delay_out(wei_index_d)
    );

  wire [ `ACT_INDEX_WIDTH - 1 : 0 ]   act_index_base;
  assign act_index = ( mode == 1) ? act_index_base + wei_index_d : valid_act_index_d;// wei_index for serial
  assign zero_flag = row_val_num == 15;  //0 weight 4'd0 - 1 = 15
//---------------------------------------------------------------------------------------
  reg [ `WEI_INDEX_WIDTH    - 1 : 0 ] row_index_count;

  wire row_index_count_1;
  wire row_index_count_2;
  wire row_index_count_3;
 always @ (posedge clk ) begin
  if(reset) begin
    row_index_count <= 0; // reset to 0 every picture
  end 
  else if ( row_cal_done ) begin
    if(row_index_count < 3)
      row_index_count <= row_index_count + 1;
    else 
      row_index_count <= 1;
  end
 end
 
  assign row_index_count_1 = state == 3 && row_index_count == 1;
  assign row_index_count_2 = state == 3 && row_index_count == 2;
  assign row_index_count_3 = state == 3 && row_index_count == 3; // for mode0
// always @(row_index_count_3 or reset) begin : proc_row_index
  always @(posedge clk ) begin
  if(reset) begin
    if (mode == 1)
       row_index_signed <= 2;
    else 
      row_index_signed <= -1;
  end else if( ( mode == 1) && row_index_count_3) begin
    row_index_signed <= row_index_signed + 3;
  end else if( (mode == 0) && ( en || row_cal_done == 1 ))//start or every row ends
    row_index_signed <= row_index_signed + 1;
 end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------ACTIVATION  ----------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  wire [ `DATA_WIDTH * `IF_WIDTH  - 1 : 0 ] parallel_act;
  wire [ `DATA_WIDTH * `IF_WIDTH * `KERNEL_WIDTH - 1 : 0 ]parallel_array;
  wire [ `DATA_WIDTH              - 1 : 0 ] act_serial_out;
  wire [ (`ADDR_WIDTH + 1) * `KERNEL_WIDTH - 1 : 0 ] row_val_num_array;
  wire rd_req_act_flag_paulse_dd;
  activation #(
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
    .row_index_count_3 ( row_index_count_3 ),
    .zero_flag         ( zero_flag         ),
    .valid_act_index   ( valid_act_index   ),
    .parallel_act      ( parallel_act      ),
    .serial_act        ( act_serial_out    ),
    .row_val_num_act_real(row_val_num_act_real),
    .rd_req_act_flag_paulse_dd(rd_req_act_flag_paulse_dd)
    );


//-----------------------------------PARALLEL------------------------------------------------------
//parallel_out
//act_index: only for mode1
//------------------- mode 1 --------------------------------------------------------------------------
  reg  [ `DATA_WIDTH * `KERNEL_WIDTH  - 1 : 0 ] serial_array;
  reg  [ `DATA_WIDTH * `KERNEL_SIZE   - 1 : 0 ] serial_array_full;
  wire [ `DATA_WIDTH * `IF_WIDTH      - 1 : 0 ] parallel_in;


  loop_count #(
    .DATA_WIDTH( `ACT_INDEX_WIDTH )
    )
  loop_count_act_index_base(
    .clk(clk),
    .reset( reset | row_cal_done ),
    .count_condition( row_finish_done_0),
    .max( 4'd12),
    .stride(4'd3),
    .count(act_index_base)
    );
////////////////////////// MODE 1 //////////////////////////////////////////////////////////////////

  seq2parallel #(
    .IN_WIDTH( `DATA_WIDTH * `IF_WIDTH ),
    .OUT_WIDTH( `DATA_WIDTH * `IF_WIDTH * `KERNEL_WIDTH )
    )
  seq2parallel(
    .clk(clk),
    .reset(reset),
    .mode( mode ),
    .in_serial( parallel_act ),
    .begin_serial_in( rd_req_act_flag_paulse_dd ),// rd_req_act_flag to rd_data_act
    .refresh_parallel_array( en || row_index_count_3 ),
    .parallel_array( parallel_array )
    );
  wire [ `DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_parallel_out;
  assign parallel_out = mode ? { parallel_array[ ( act_index  +  `IF_WIDTH * 2 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                               parallel_array[ ( act_index  +  `IF_WIDTH * 1 )*`DATA_WIDTH +: 3*`DATA_WIDTH ],
                               parallel_array[ ( act_index                   )*`DATA_WIDTH +: 3*`DATA_WIDTH ] } : wei_parallel_out;
 
  //reshape

  // assign parallel_out = (mode == 1)? { parallel_out_wire [7 :0 ], parallel_out_wire [15:8 ], parallel_out_wire [23:16],
  //                                      parallel_out_wire [31:24], parallel_out_wire [39:32], parallel_out_wire [47:40],
  //                                      parallel_out_wire [55:48], parallel_out_wire [63:56], parallel_out_wire [71:64] } 
  //                                   //[2, 5, 8, 1, 4, 7, 0, 3, 6]
  //                                   : wei_parallel_out;
//  assign row_val_num_act_real = row_val_num_array[ (row_index % 3) * 5 +: 5];//5bit
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //----------------- WEIGHTS ( serial )-------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//---------------------------------- begin sparity ----------------------------------------------------------------------------

//  wire rd_req_wei;
//  assign rd_req_wei = state_serial == SERIAL_READ;
 // wire read_wei_finish;//not used

 // assign read_wei_finish = rd_addr_sflag == `KERNEL_SIZE || row_cal_done; // mode0 weight read finish;
  
 //  assign index_finish = flag_serial_reg == 0; // ahead 2 clk over row_cal_done_1
 //  always @(posedge clk ) begin : proc_wei_index_array_full
 //    if(reset) begin
 //      wei_index_array_full <= 0;
 //      n <= 0;
 //    end else if( mode == 1 && flag_serial_reg != 0 ) begin //flag_serial_reg !=0 2 clk delay
 //       wei_index_array_full <= {wei_index_array_full[ `WEI_INDEX_WIDTH * ( `KERNEL_SIZE - 1)  - 1 : 0 ], valid_wei_index_back };//stack wei_index
 // //        wei_index_array_full[ `WEI_INDEX_WIDTH*n +: `WEI_INDEX_WIDTH ] = valid_wei_index_back;
 //         n <= n + 1;
 //    end
 //  end
 wire [ `DATA_WIDTH      - 1 : 0 ] wei_serial_out;
  weight #(
   )
  weight(
    .clk(clk),
    .reset(reset),
    .mode(mode),
    .start( start ),
    .state(state),
    .row_cal_done        (row_cal_done),
    .wr_req_wei_flag(wr_req_wei_flag),
    .wr_data_wei_flag(wr_data_wei_flag),
    .wr_req_wei          (wr_req_wei),
    .wr_data_wei         (wr_data_wei),
    .wei_index( wei_index),
    .row_val_num_wei_real( row_val_num_wei_real ),
    .wei_serial_out( wei_serial_out ),
    .wei_parallel_out(wei_parallel_out),
    .en(en)
    );
  assign serial_out = ( mode == 1)? wei_serial_out : act_serial_out;
  assign row_val_num_real = mode?  row_val_num_wei_real : row_val_num_act_real;
 //-----------------------------------------------------------------------------------------
  assign row_val_num = row_val_num_real - 1; //5bit to 4bit
//-------------------------- end serial -----------------------------------------------------------------------------

endmodule