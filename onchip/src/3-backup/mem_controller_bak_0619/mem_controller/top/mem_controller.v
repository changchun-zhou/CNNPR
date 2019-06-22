
`define IF_WIDTH  16
`define KERNEL_WIDTH 3

`define IF_SIZE  256
`define KERNEL_SIZE  9
`define ACT_INDEX_WIDTH 4 // mode0 mode1
`define WEI_INDEX_WIDTH 2//2 only for mode1

module mem_controller #(
  parameter DATA_WIDTH  =  8,
  parameter READ_FLAG_LENGTH   = 6,
  parameter READ_REQ_ACT_FLAG = 9'b000_000_111,
  parameter READ_REQ_ACT = 9'b000_000_001,
  parameter ADDR_WIDTH = 4,

  parameter PARALLEL_WIDTH = DATA_WIDTH * `KERNEL_SIZE ,//72
  parameter SHIFT_WIDTH = DATA_WIDTH*`KERNEL_WIDTH,
  parameter NUM_BLOCK = ( `IF_WIDTH / `KERNEL_WIDTH + 1 ) * ( `IF_WIDTH / `KERNEL_WIDTH + 1 ),//29
  parameter BLOCK_ADDR_WIDTH = `C_LOG_2 ( NUM_BLOCK )//5


)(
	input	wire	                        clk,    // Clock
	input	wire	                        reset,  // Asynchronous reset active low
//initial
  input                               wr_req_pflag,   
  input                               wr_data_pflag0,        
  input                               wr_data_pflag1,
  input                               wr_data_pflag2,
  input                               wr_data_pflag3,
  input                               wr_data_pflag4,
  input                               wr_data_pflag5,
  input                               wr_data_pflag6,
  input                               wr_data_pflag7,
  input                               wr_data_pflag8,
  input                               wr_req_p,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p0,        
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p1,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p2,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p3,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p4,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p5,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p6,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p7,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p8,
  input                               wr_req_sflag,
  input [ `IF_WIDTH        - 1 : 0 ]  wr_data_sflag,
  input                               wr_req_s,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_s,
  input                               mode,   //
  input                               start,

  output reg                          en,
  output [ PARALLEL_WIDTH   - 1 : 0 ] parallel_out,
  output [ DATA_WIDTH       - 1 : 0 ] serial_out,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] act_index,
  output [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_index, // only [1:0] for mode1
  output [ `ACT_INDEX_WIDTH     : 0 ] row_index,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] row_val_num, //0->1 1->2 2->3  4 bit
  output                              zero_flag,  //0

  input  [ `ACT_INDEX_WIDTH - 1 : 0 ] cnt,
  input                               row_finish_done_0, //weight loop
  input                               row_finish_done_1,  //activation loop not used
  input                               row_cal_done
  
);
  reg [ 1 : 0] state;
  reg  signed [ `ACT_INDEX_WIDTH   : 0 ] row_index_signed;
  assign  row_index = row_index_signed[3:0];

  reg                           start_on;
  reg                           start_d;
  reg                           start_dd;
  reg                           start_ddd;
  wire[`KERNEL_SIZE      - 1 : 0 ] wr_data_pflag;
  wire[ PARALLEL_WIDTH   - 1 : 0 ] parallel_out_wire;
  wire index_finish;
  assign wr_data_pflag = {wr_data_pflag8 ,   
  wr_data_pflag7,
  wr_data_pflag6,
  wr_data_pflag5,
  wr_data_pflag4,
  wr_data_pflag3,
  wr_data_pflag2,
  wr_data_pflag1,
  wr_data_pflag0} ;
  wire [ DATA_WIDTH       - 1 : 0 ] wr_data_p [ 0 : `KERNEL_SIZE     - 1 ];
  assign wr_data_p[0] = wr_data_p0;
  assign wr_data_p[1] = wr_data_p1;
  assign wr_data_p[2] = wr_data_p2;
  assign wr_data_p[3] = wr_data_p3;
  assign wr_data_p[4] = wr_data_p4;
  assign wr_data_p[5] = wr_data_p5;
  assign wr_data_p[6] = wr_data_p6;
  assign wr_data_p[7] = wr_data_p7;
  assign wr_data_p[8] = wr_data_p8;
// FSM-state
  parameter PREP = 2'b00;
  parameter COMP = 2'b01;
  parameter WAIT = 2'b11;


  always @(posedge clk) begin : proc_state
    if(reset) begin
      state <= PREP;
    end else begin
      case (state)
        PREP: if ( en )
                state <= WAIT;
        COMP: if (row_cal_done)
                state <= WAIT;
        WAIT: state <= COMP;
        default: state <= PREP;
      endcase
    end
  end


  parameter PARALLEL_READ = 2'b01;
  parameter PARALLEL_WAIT = 2'b11;

  wire read_wei_finish;
  reg  read_wei_finish_d;
  reg  read_wei_finish_dd;

  reg [1 : 0 ] state_parallel;
  wire parallel_row_read_finish;
  reg parallel_row_read_finish_d;
  always @(posedge clk ) begin : proc_parallel_row_read_finish_d
    if(reset) begin
      parallel_row_read_finish_d <= 0;
    end else begin
      parallel_row_read_finish_d <= parallel_row_read_finish;
    end
  end

  wire row_index_count_3;
  always @(posedge clk ) begin
    if (reset) begin
      // reset
      state_parallel <= PARALLEL_WAIT;
    end
    else  begin
      case ( state_parallel )
      PARALLEL_WAIT: if( mode == 1 ) begin
                        if( start || en || row_index_count_3 ) // start and every row begin
                          state_parallel <= PARALLEL_READ;
                      end else if( read_wei_finish )// according to weight read finish signal.
                          state_parallel <= PARALLEL_READ;
      PARALLEL_READ: if ( parallel_row_read_finish )
                        state_parallel <= PARALLEL_WAIT;
      default: state_parallel <= PARALLEL_WAIT;
      endcase     
    end
  end
  reg flag_state_parallel;
  reg flag_state_parallel_d;
  always @(posedge clk ) begin
    if (reset) begin
      // reset
      flag_state_parallel <= 0;
      flag_state_parallel_d <= 0;
    end
    else begin
      flag_state_parallel <= state_parallel == PARALLEL_READ;
      flag_state_parallel_d <= flag_state_parallel;      
    end
  end
  parameter SERIAL_READ = 2'b01;
  parameter SERIAL_WAIT = 2'b11;

  reg [1 : 0 ] state_serial;
  reg flag_wei_read;
  always @(posedge clk ) begin
    if (reset) begin
      // reset
      state_serial <= SERIAL_WAIT;
      flag_wei_read <= 0;
    end
    else  begin
      case ( state_serial )
      SERIAL_WAIT: if( mode == 1 ) begin
                        if( parallel_row_read_finish && !flag_wei_read) begin // ADD parallel finish
                          state_serial <= SERIAL_READ;
                          flag_wei_read <= 1;
                        end
                    //mode 0 continous read
                    end else if( start ) // || start_d || index_finish )   
                          state_serial <= SERIAL_READ;
      SERIAL_READ: if ( mode == 1 )// index_finish ahead one clk
                        state_serial <= SERIAL_WAIT;
                  // mode0 read weight finish.
                   else if ( read_wei_finish_d )//!(start || start_d || index_finish))
                        state_serial <= SERIAL_WAIT;
      default: state_serial <= SERIAL_WAIT;
      endcase     
    end
  end

 // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //---------------------------------     G L O B A L  ---------------------------------------------------------------------------------------------
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
//---------D E L A Y------------------------
  wire [ `ACT_INDEX_WIDTH - 1 : 0 ] position_1_act;
  wire [ `ACT_INDEX_WIDTH - 1 : 0 ] valid_act_index;
  reg [ `ACT_INDEX_WIDTH - 1 : 0 ] valid_act_index_d;
  reg [ `ACT_INDEX_WIDTH - 1 : 0 ] valid_act_index_dd;
    reg                           s_read_req;
  reg row_cal_done_d;
  wire [ 5 : 0] valid_num_0;
  reg  [ 5 : 0] valid_num_0_d;
  reg  [ 5 : 0] valid_num_0_dd;
  always @(posedge clk ) begin : proc_start_on
       if(reset) begin
         start_on <= 0;
         start_d  <= 0;
         start_dd <= 0;
         start_ddd <= 0;
         read_wei_finish_d <= 0;
         read_wei_finish_dd <= 0;
         valid_act_index_d <= 0;
         valid_act_index_dd <= 0;
         valid_num_0_d <= 0;
         valid_num_0_dd <= 0;
         row_cal_done_d <= 0;
       end else begin
         if(start) begin
           start_on <= 1;
         end
       start_d <= start; //delay 2 clk
       start_dd   <= start_d;
       start_ddd <= start_dd;
//       en     <= start_dd;
       read_wei_finish_d <= read_wei_finish;
       read_wei_finish_dd <= read_wei_finish_d;

       valid_act_index_d <= valid_act_index;
       valid_act_index_dd <= valid_act_index_d;

       valid_num_0_d <= valid_num_0;
       valid_num_0_dd <= valid_num_0_d;

       row_cal_done_d <= row_cal_done;
     end
  end
//---------------------------------------
wire [ `IF_WIDTH    - 1 : 0 ] flag_serial;
reg signed  [ `IF_WIDTH           : 0 ] flag_serial_reg;

  reg   [ ADDR_WIDTH  - 1 : 0 ] rd_addr_s;
wire [ `ACT_INDEX_WIDTH - 1 : 0]rd_addr_serial;
reg  [ `WEI_INDEX_WIDTH * `KERNEL_SIZE    - 1 : 0 ] wei_index_array_full;
reg flag_en;
reg  [ 3:0] m;
  always @(posedge clk ) begin : proc_en
    if(reset) begin
      en <= 0;
      flag_en <= 0;
    end else if ( !flag_en && ( ( (mode == 1 ) && (flag_serial_reg == 0 ) && ( wei_index_array_full != 0) ) || ( mode == 0 && m == 6 ) )  )begin // rd_addr_sflag == 9
      en <= 1;
      flag_en <= 1;
    end else 
      en <= 0;
  end

//DELAY
  reg [ `WEI_INDEX_WIDTH       - 1 : 0 ]     wei_index_d;
  wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] act_index_0;
  always @(posedge clk ) begin : proc_delay
    if(reset) begin
      wei_index_d <= 0;
    end else begin
      wei_index_d <= wei_index;
    end
  end
  reg [ `ACT_INDEX_WIDTH - 1 : 0 ]   act_index_base;
  assign act_index = ( mode == 1) ? act_index_base + wei_index_d : valid_act_index_d;// wei_index for serial
  assign zero_flag = row_val_num == 15;  //0 weight 4'd0 - 1 = 15
//---------------------------------------------------------------------------------------
  reg [ `WEI_INDEX_WIDTH    - 1 : 0 ] row_index_count;

  wire row_index_count_1;
  wire row_index_count_2;

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

 reg flag_stream_act_1;
always @(posedge clk ) begin
  if (reset) begin
    // reset
    flag_stream_act_1 <= 0;
  end else if ( mode == 1)  begin
     if ( start || row_index_count_2 ) begin//begin or 
        flag_stream_act_1 <= 1;    
     end else if ( row_index_count_2 )
        flag_stream_act_1 <= 0;
  end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------ACTIVATION  ----------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  reg    [ BLOCK_ADDR_WIDTH  - 1 : 0 ]  wr_addr_pflag;
  wire                                  read_req_pflag;
  wire   [ `KERNEL_SIZE     - 1 : 0 ]   rd_act_flag_p ;
  wire   [ `KERNEL_SIZE     - 1 : 0 ]  rd_req_act_flag;
  wire   [ READ_FLAG_LENGTH  - 1 : 0 ]  rd_act_flag_s   [ 0 : `KERNEL_SIZE     - 1 ];
  reg    [ BLOCK_ADDR_WIDTH  - 1 : 0 ]  rd_addr_pflag;
  reg                                   flag_reused;
  // 3 start is to stream B0B1B2 to parallel_array
//  assign read_req_pflag = (mode == 1)? ( start_dd | start_d | start | (row_finish_done_0 && flag_stream_act_1 ) ) : start_dd;//


  always @(posedge clk) begin
    if (reset) begin
      // reset
      flag_reused <= 0;
    end else if ( row_cal_done ) begin
      flag_reused <= 1;     
    end else if (row_index_count_3 )
      flag_reused <= 0; // one clk delay
  end

//  wire parallel_addr;
//  assign parallel_addr = 
  always @(posedge clk ) begin : proc_rd_addr_pflag
    if(reset) begin
      rd_addr_pflag <= 0;
    end else if(state_parallel == PARALLEL_READ) begin
      if( mode == 1 ) //
        rd_addr_pflag <= rd_addr_pflag + 1;
      else if( row_index_count_2 )// 3 rows finished
        rd_addr_pflag <= rd_addr_pflag + 6;
    end
  end

//mode1: rd_addr_pflag= 5, 11, 17, 23
  assign parallel_row_read_finish = (mode==1)? ( rd_addr_pflag + 1 ) % 6 == 0 : state_parallel == PARALLEL_READ;//en or every second row finished
  always @(posedge clk ) begin : proc_wr_addr_pflag
    if(reset) begin
      wr_addr_pflag <= 0;
    end else if(wr_req_pflag) begin
      wr_addr_pflag <= wr_addr_pflag + 1;
    end
  end
  
  wire [ 1: 0]block_index; //row_num of activation in GRID
  assign block_index = row_index_signed % 3;

  reg  [ 1 : 0 ] shift_pflag;
  always @(posedge clk ) begin : proc_shift_pflag
    if(reset) begin
      shift_pflag <= 0;
    end else if( en || row_cal_done ) begin // ahead 1 clk
      shift_pflag <= ( row_index_signed + 2 ) % 3; //f->1 1->2 1->3 2->1
    end
  end
  assign rd_req_act_flag = ( mode == 1 ) ? ( state_parallel == PARALLEL_READ ? 9'b111111111 : 9'd0 ) : READ_REQ_ACT_FLAG <<< 3*shift_pflag;
  genvar gv_j;
  generate
    for (gv_j = 0; gv_j < `KERNEL_SIZE; gv_j = gv_j + 1)
    begin : parallel_flag  //16%5 = 1 : flag=0 for two columns padding flag to 18
      ram_flag #(
        .DATA_WIDTH               ( 1                  ),
        .ADDR_WIDTH               ( BLOCK_ADDR_WIDTH   )
      )
      ram_flag (
        .clk                      ( clk                     ),  //input
        .reset                    ( reset                   ),  //input
        .ram_mode                 ( mode                    ),
        .s_write_req              ( wr_req_pflag            ),  //input
        .s_write_data             ( wr_data_pflag[gv_j]     ),  //input
        .s_write_addr             ( wr_addr_pflag           ),  //input

        .s_read_req               ( rd_req_act_flag[gv_j]   ),//( state_parallel == PARALLEL_READ ),  //input
        .s_read_data_p            ( rd_act_flag_p[gv_j]     ),  //output
        .s_read_data_s            ( rd_act_flag_s[gv_j]     ),
        .s_read_addr              ( rd_addr_pflag           )   //input
      );
    end
  endgenerate
// if mode == 0 
//---------- mode0 rd_act_flag_s reshape---------------
  wire [ READ_FLAG_LENGTH  - 1 : 0 ] rd_act_flag_s0;
  wire [ READ_FLAG_LENGTH  - 1 : 0 ] rd_act_flag_s1;
  wire [ READ_FLAG_LENGTH  - 1 : 0 ] rd_act_flag_s2;
  wire [ READ_FLAG_LENGTH * `KERNEL_WIDTH - 1 : 0 ] row_act_flag;
  reg  [ READ_FLAG_LENGTH * `KERNEL_WIDTH - 1 : 0 ] row_act_flag_reg;


//valid 3 blocks
  reg  [ 1 : 0 ] shift_pflag_d;
  always @(posedge clk ) begin : proc_shift_pflag_d
    if(reset) begin
      shift_pflag_d <= 0;
    end else begin
      shift_pflag_d <= shift_pflag;
    end
  end
  assign rd_act_flag_s0 = rd_act_flag_s [ 3*shift_pflag_d ];
  assign rd_act_flag_s1 = rd_act_flag_s [ 3*shift_pflag_d + 1 ];
  assign rd_act_flag_s2 = rd_act_flag_s [ 3*shift_pflag_d + 2 ];
//reshape, cross
  assign row_act_flag = { rd_act_flag_s2[5], rd_act_flag_s1[5], rd_act_flag_s0[5],
                          rd_act_flag_s2[4], rd_act_flag_s1[4], rd_act_flag_s0[4],
                          rd_act_flag_s2[3], rd_act_flag_s1[3], rd_act_flag_s0[3],
                          rd_act_flag_s2[2], rd_act_flag_s1[2], rd_act_flag_s0[2],
                          rd_act_flag_s2[1], rd_act_flag_s1[1], rd_act_flag_s0[1],
                          rd_act_flag_s2[0], rd_act_flag_s1[0], rd_act_flag_s0[0]};

  assign valid_num_0 =  rd_act_flag_s0[0]+ rd_act_flag_s1[0]+ rd_act_flag_s2[0]+
                        rd_act_flag_s0[1]+ rd_act_flag_s1[1]+ rd_act_flag_s2[1]+
                        rd_act_flag_s0[2]+ rd_act_flag_s1[2]+ rd_act_flag_s2[2]+
                        rd_act_flag_s0[3]+ rd_act_flag_s1[3]+ rd_act_flag_s2[3]+
                        rd_act_flag_s0[4]+ rd_act_flag_s1[4]+ rd_act_flag_s2[4]+
                        rd_act_flag_s0[5]+ rd_act_flag_s1[5]+ rd_act_flag_s2[5];
  assign position_1_act = `C_LOG_2( (~row_act_flag_reg + 1 ) & row_act_flag_reg );// addr of 1

  reg [ `ACT_INDEX_WIDTH  - 1 : 0 ] valid_act_index_reg;
  always @(posedge clk or negedge reset) begin : proc_valid_act_index_reg
    if(reset) begin
      valid_act_index_reg <= 0;
    end else if( row_act_flag_reg != 0 ) begin
      valid_act_index_reg <= valid_act_index + 1;
    end
  end

  assign valid_act_index = position_1_act + valid_act_index_reg;
  always @(posedge clk ) begin : proc_row_act_flag_reg
    if(reset) begin
      row_act_flag_reg <= 0;
    end else if ( en || row_cal_done )  begin // one time for a row data
      row_act_flag_reg <= row_act_flag;
    end else
      row_act_flag_reg <= row_act_flag_reg >> ( position_1_act + 1);//
  end

//----------------------------------------------------------------------------
  wire  [ DATA_WIDTH  - 1 : 0 ] rd_data_p [ 0 : `KERNEL_SIZE -1 ];

  wire [ `KERNEL_SIZE     - 1 : 0 ] rd_req_act;
  assign rd_req_act = ( mode == 1 )? rd_act_flag_p : READ_REQ_ACT <<< ( 3*block_index + valid_act_index % 3 );//mode0: only read a column.
  
  genvar gv_i;
  generate
  	for (gv_i = 0; gv_i < `KERNEL_SIZE ; gv_i  = gv_i + 1)
  	begin : parallel_data
	  column_parallel #(
	  )
	  column_parallel (
      .clk          ( clk                   ), 
      .reset	      ( reset                 ), 
      .mode         ( mode                  ),
      .wr_req_p     ( wr_req_p              ),  //input
      .wr_data_p    ( wr_data_p[gv_i]       ), 

      .rd_en        ( (mode == 1 || row_act_flag_reg != 0) ),
      .rd_req_p     ( rd_req_act[gv_i]      ), 
  //    .rd_data_pflag( rd_data_pflag         ),
      .rd_data_p    ( rd_data_p[gv_i]       )
	  );
	end
  endgenerate
  wire [ DATA_WIDTH -1 : 0 ] serial_in;
  reg   [ `ACT_INDEX_WIDTH  - 1 : 0 ] column_parallel_index;
  always @(posedge clk or negedge reset) begin : proc_column_parallel_index
    if(reset) begin
      column_parallel_index <= 0;
    end else begin
      column_parallel_index <= 3*block_index + valid_act_index % 3;
    end
  end
  assign serial_in = mode == 1 ? 8'bx: rd_data_p [ column_parallel_index ];
//-----------------------------------PARALLEL------------------------------------------------------
//parallel_out
//act_index: only for mode1
//------------------- mode 1 --------------------------------------------------------------------------
  reg  [ DATA_WIDTH * `KERNEL_WIDTH        - 1 : 0 ]     serial_array;
  reg  [ DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] serial_array_full;
  wire [ PARALLEL_WIDTH   - 1 : 0 ] parallel_in;
  assign parallel_in = (mode == 1) ? {  rd_data_p [ 2 ], rd_data_p [ 5 ], rd_data_p [ 8 ],
                                        rd_data_p [ 1 ], rd_data_p [ 4 ], rd_data_p [ 7 ],
                                        rd_data_p [ 0 ], rd_data_p [ 3 ], rd_data_p [ 6 ] } : serial_array_full;  //9 reshape

  reg [ PARALLEL_WIDTH * 6  - 1 : 0 ] parallel_array;
  reg [ PARALLEL_WIDTH * 6  - 1 : 0 ] parallel_array_reg;
//  always @(read_req_pflag or reset) begin : proc_parallel_array
  always @(posedge clk ) begin
    if(reset) begin
      act_index_base  <= 0;
      parallel_array_reg <= 0;
      //read_req_pflag_dd
    end else if( ( mode == 1 ) && (flag_state_parallel_d == 1 ) ) begin // mode1 begin or the first reuse. cache in; delay 2 clk state_parallel=read
      parallel_array_reg <= {parallel_in, parallel_array_reg [ PARALLEL_WIDTH * 6 - 1 : PARALLEL_WIDTH ]};// --->>
    end
  end
 
//only mode1 for this act_index_base
 always @(posedge clk or negedge reset) begin : proc_act_index_reg 
   if(reset) begin
    act_index_base  <= 0;
   end else if ( mode  == 1 )begin
 //    if (state == 3 ) 
 //       act_index_base <= 0;
      if( row_cal_done )
        act_index_base <= 0;
      else if( row_finish_done_0 )// begin or every weight row finished
          if ( act_index_base >= 12 )// finish
            act_index_base <= 0;
          else
            act_index_base <= act_index_base + 3;
   end else begin
        act_index_base <= 0000000000000;
   end
 end

 always @(posedge clk ) begin : proc_parallel_array
   if(reset) begin
     parallel_array <= 0;
     ////read_req_pflag: start, start_d,start_dd, 3clk delay, || row_finish_done_0 for begin; then row_index_count_3
   end else if ( (mode == 1 ) && ( en || row_index_count_3) ) begin // begin stream or every row done refresh
     parallel_array <= parallel_array_reg; // 3x18 
   end else if ( ( mode == 0 ) && start_dd )
     parallel_array <= parallel_array_reg; // only the first 9 weights.
 end

  assign parallel_out_wire = parallel_array[ ( act_index_base + wei_index_d )*SHIFT_WIDTH+: 3*SHIFT_WIDTH ];
  assign parallel_out = (mode == 1)? { parallel_out_wire [23:16], parallel_out_wire [47:40], parallel_out_wire [71:64],
                                       parallel_out_wire [15:8 ], parallel_out_wire [39:32], parallel_out_wire [63:56],
                                       parallel_out_wire [7 :0 ], parallel_out_wire [31:24], parallel_out_wire [55:48] } 
                                    //[2, 5, 8, 1, 4, 7, 0, 3, 6]
                                    : serial_array_full;



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //----------------- WEIGHTS ( serial )-------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //--------  one line flag -------------------
//mode1:weight


wire [ `WEI_INDEX_WIDTH * 3    - 1 : 0 ] valid_row;

//---------------------------------- begin sparity ----------------------------------------------------------------------------
  reg [ `ACT_INDEX_WIDTH       - 1 : 0 ] rd_addr_sflag;
  reg [`ACT_INDEX_WIDTH -1 : 0 ]rd_addr_d;
  reg [`ACT_INDEX_WIDTH -1 : 0 ]wr_addr;
  wire [`IF_WIDTH - 1 : 0 ]flag_array;
  reg                        start_on_d;  
  wire [ `WEI_INDEX_WIDTH - 1 : 0 ] valid_row0;
  wire [ `WEI_INDEX_WIDTH - 1 : 0 ] valid_row1;
  wire [ `WEI_INDEX_WIDTH - 1 : 0 ] valid_row2;

//  wire rd_req_wei;
//  assign rd_req_wei = state_serial == SERIAL_READ;
  reg rd_req_wei;
  always @(posedge clk ) begin : proc_rd_req_wei
    if(reset) begin
      rd_req_wei <= 0;
    end else if ( mode == 1 ) begin
      rd_req_wei <= parallel_row_read_finish && !flag_wei_read; //paulse
    end else if ( mode == 0 ) begin
      rd_req_wei <= start;
    end
  end
  always @(posedge clk) begin : proc_rd_addr
     if(reset) begin
       rd_addr_sflag <= 0;
    end else if( rd_req_wei && mode == 1 ) begin// && mode == 1   // add 
      rd_addr_sflag <= rd_addr_sflag + 1; //
    end else if( mode == 0 && state_serial == SERIAL_READ )//
      rd_addr_sflag <= rd_addr_sflag + 1; 
  end
  assign read_wei_finish = rd_addr_sflag == `KERNEL_SIZE || row_cal_done; // mode0 weight read finish;
  wire [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index;// position of 1
  reg  [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_wei_index_d;
  assign valid_index = `C_LOG_2( ( ~flag_serial_reg + 1 ) & flag_serial_reg );// mode1: 11000 -> 3

  wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] valid_wei_index;
   wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] valid_wei_index_back;
  always @(posedge clk ) begin : proc_valid_index_reg_d
    if(reset) begin
      valid_wei_index_d <= 0;
    end else if ( flag_serial_reg != 0) begin
      valid_wei_index_d <= valid_wei_index + 1;
    end
  end

  assign valid_wei_index = ( valid_index + valid_wei_index_d ) % 3;//0 1 2 0 1 2 
  assign valid_wei_index_back = 2 - valid_wei_index;
  reg flag_refresh_flag_serial;
  always @(posedge clk ) begin : proc_flag_refresh_flag_serial
    if(reset) begin
      flag_refresh_flag_serial <= 0;
    end else begin
      flag_refresh_flag_serial <= state_serial == SERIAL_READ;
    end
  end
  reg  [ 3:0] n;
  always @(posedge clk ) begin : proc_flag_serial_reg
    if(reset) begin
      flag_serial_reg <= 0;
    end else if ( flag_refresh_flag_serial )begin //one time
      flag_serial_reg <= flag_serial;// refresh 
    end else 
      flag_serial_reg <= flag_serial_reg >> ( valid_index + 1 ) ;// when finished one line ?
  end
  assign index_finish = flag_serial_reg == 0; // ahead 2 clk over row_cal_done_1
  always @(posedge clk ) begin : proc_wei_index_array_full
    if(reset) begin
      wei_index_array_full <= 0;
      n <= 0;
    end else if( mode == 1 && flag_serial_reg != 0 ) begin //flag_serial_reg !=0 2 clk delay
       wei_index_array_full <= {wei_index_array_full[ `WEI_INDEX_WIDTH * ( `KERNEL_SIZE - 1)  - 1 : 0 ], valid_wei_index_back };//stack wei_index
 //        wei_index_array_full[ `WEI_INDEX_WIDTH*n +: `WEI_INDEX_WIDTH ] = valid_wei_index_back;
         n <= n + 1;
    end
  end

  assign flag_array = flag_serial;
  assign valid_row0 = ( flag_array[8] + flag_array[7] + flag_array[6] );
  assign valid_row1 = ( flag_array[5] + flag_array[4] + flag_array[3] );
  assign valid_row2 = ( flag_array[2] + flag_array[1] + flag_array[0] );
 
  assign valid_row  = (mode == 1) ? {valid_row2, valid_row1, valid_row0} : valid_num_0;//no 2 clk delay

  always @(posedge clk ) begin
    if(reset) begin
      wr_addr <= 0;
    end else if(wr_req_sflag) begin
      wr_addr <= wr_addr + 1;
    end
  end
ram #(
    .DATA_WIDTH               ( `IF_WIDTH              ),
    .ADDR_WIDTH               ( `ACT_INDEX_WIDTH                    )
  ) ram_sflag (
    .clk                      ( clk                     ),  //input
    .reset                    ( reset                   ),  //input
    .s_write_req              ( wr_req_sflag                  ),  //input
    .s_write_data             ( wr_data_sflag                 ),  //input
    .s_write_addr             ( wr_addr                 ),  //input

    .s_read_req               ( rd_req_wei                  ),  //input
    .s_read_data              ( flag_serial             ),  //output
    .s_read_addr              ( rd_addr_sflag                 )   //input
  );
//----------------------------------------end sparity--------------------------------------------------------------------------------------


  wire [ DATA_WIDTH - 1 : 0 ] rd_data_wei;
  wire [ DATA_WIDTH - 1 : 0 ] s_read_data;
  wire rd_req_s;

  assign rd_req_s = flag_serial_reg != 0;
//---------------------------------------begin column_serial -------------------------------------------------------------------------------

  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr_s;

  reg  [ ADDR_WIDTH   - 1 : 0 ] k;

  reg                           s_read_req_d;
  reg                           flag_stream_wei;
  reg                           flag_stream_wei_d;
  always @(posedge clk ) begin : proc_s_read_req
    if(reset) begin
      s_read_req <= 0;
      s_read_req_d <= 0;
    end else if(mode == 1 && flag_serial_reg != 0) begin
        s_read_req <= 1;
    end else if( mode == 0 && flag_serial[k] == 1 ) begin
        s_read_req <= 1;
    end else begin
        s_read_req <= 0;
    end
    s_read_req_d <= s_read_req;
  end
  
  always @(posedge clk) begin : proc_rd_addr_s
    if(reset) begin
      rd_addr_s <= 0;
    end else if( s_read_req ) begin
      rd_addr_s <= rd_addr_s + 1;
    end
  end

  always @(posedge clk ) begin : proc_k
    if(reset) begin
      k <= 0;
    end else if ( mode == 0 && flag_serial != 0 ) begin
      if( k < `KERNEL_SIZE - 1 )
        k <= k + 1;
    end
  end

  always @(posedge clk ) begin : proc_flag_stream_wei
    if(reset) begin
      flag_stream_wei <= 0;
      flag_stream_wei_d <= 0;
    end else if ( mode == 0 && flag_serial != 0 )begin
      flag_stream_wei <= 1;
    end
    flag_stream_wei_d <= flag_stream_wei;
  end

  always @(posedge clk ) begin : proc_wr_addr_p
    if(reset) begin
      wr_addr_s <= 0;
    end else if(wr_req_s) begin
      wr_addr_s <= wr_addr_s + 1;
    end
  end

  ram #(
    .DATA_WIDTH               ( DATA_WIDTH      ),
    .ADDR_WIDTH               ( ADDR_WIDTH      )
  ) ram_bank (
    .clk                      ( clk             ),  //input
    .reset                    ( reset           ),  //input
    .s_write_req              ( wr_req_s       ),  //input
    .s_write_data             ( wr_data_s      ),  //input
    .s_write_addr             ( wr_addr_s      ),  //input

    .s_read_req               ( s_read_req    ),  //input
    .s_read_data              ( s_read_data    ),  //output
    .s_read_addr              ( rd_addr_s      )   //input
  );

   assign rd_data_wei = (mode ==1 )? s_read_data : s_read_req_d ? s_read_data : 0;//mode1->sparity;  mode0->not sparity;

   reg  [ 5       - 1 : 0 ]     row_val_num_a;
   integer     j;

   reg  [ `ACT_INDEX_WIDTH       - 1 : 0 ]     count_array;
   reg  [ `ACT_INDEX_WIDTH * `IF_WIDTH    - 1 : 0 ]     wei_index_array;
   reg                                        flag_serial_d;
   reg finish_wei_d, finish_wei_dd;
   reg [ DATA_WIDTH            - 1 : 0 ] column_out_serial_d;
   integer i;
  //---------------------------    SERIAL  ------------------------------------------------------------------------------
  wire finish_wei;


  always @(posedge clk ) begin : proc_serial_array
    if(reset) begin
      serial_array_full <= 0;
//      row_val_num  <= 0;
      m <= 0;
    end else if(mode == 1) begin 
//      if( !finish_wei_dd && flag_serial_d) begin
        if(s_read_req_d) begin
//          serial_array <= {rd_data_wei, serial_array [ DATA_WIDTH * 3        - 1 : 8 ]}; //stream weight to serial
            serial_array_full [ DATA_WIDTH*m +: DATA_WIDTH ] <= rd_data_wei;
            m <= m + 1;
      end       
    end else if ( mode == 0) begin
      if ( flag_stream_wei_d && ( m < `KERNEL_SIZE ) )  begin
            serial_array_full [ DATA_WIDTH*m +: DATA_WIDTH ] <= rd_data_wei;
            m <= m + 1;
      end
    end
 //   row_val_num <= row_val_num_a - 1; //delay1 clk
    flag_serial_d <= flag_serial;
    finish_wei_d <= finish_wei;
    finish_wei_dd <= finish_wei_d;
  end

  reg [ DATA_WIDTH - 1: 0 ] serial_out_reg;
  assign serial_out = ( mode == 1)? serial_out_reg : serial_in;
  always @(posedge clk) begin : proc_serial_out
    if(reset) begin
      serial_out_reg   <= 0;
    end else if(mode ==1 ) begin
//        if(finish_wei_dd) 
        begin
          serial_out_reg <= serial_array[ DATA_WIDTH* i +:DATA_WIDTH ]; //loop weight for a weight row
        end
    end else if ( mode == 0 ) begin
     // serial_out <= serial_in; ahead 1 clk
//        serial_out <= rd_data_p[ 3*block_index + valid_act_index % 3 ];
    end
  end


 //-----------------------------------------------------------------------------------------

  always @(posedge clk) begin : proc_wei_index_array //wei_index_array loop
    if(reset) begin
      j <= 0;
      row_val_num_a<= 0;
      wei_index_array<= 0;
    end else if ( mode == 1 && (en || row_cal_done)  ) begin //
      row_val_num_a <= valid_row[ j  +: 2 ]; // 2 bit
      wei_index_array <= wei_index_array_full[ `WEI_INDEX_WIDTH *count_array +: `WEI_INDEX_WIDTH * `KERNEL_WIDTH ]; //row_wei loop refresh wei_index_array
      serial_array <= serial_array_full[ DATA_WIDTH * count_array +: DATA_WIDTH * `KERNEL_WIDTH ];//refresh 
      if( en || (j < 2*row_val_num_a) )
        j <= j + 2;
      else
        j <= 0;
    end else if ( mode == 0 && state == WAIT) begin //refresh row_val_num
      row_val_num_a <= valid_row;
      wei_index_array <= wei_index_array_full;
    end
  end
  always @(posedge clk ) begin : proc_count_array  // delay one clk after row_val_num_a
    if(reset) begin
      count_array <= 0;
    end else if( mode ==1 && ( state == WAIT)) begin
//      if ( count_array <= ( valid_row[1:0] + valid_row[3:2] ) ) //< row0 + row1 num of valid weights; = for zero
        count_array <= ( count_array + row_val_num_a <= ( valid_row[1:0] + valid_row[3:2] )) ? ( count_array + row_val_num_a ) : 0;
//      else 
//        count_array <= 0;
    end
  end


  integer base_index;
  always @(posedge clk ) begin : proc_i //loop
      if(en || reset) begin
        i <= 0;
        base_index <= 0;
      end else if (row_cal_done) begin// next weight row
//        base_index <= base_index + row_val_num_a;
 //     else if ( row_index_count_3 ) begin//next activation row
        i <= 0 ;
 //       base_index <= 0;
      end else if( i < row_val_num  ) begin
        i <= i + 1;
      end else
        i <= 0;
    end
  assign row_val_num = row_val_num_a - 1;
    // for mode1 wei_index[1:0] valid
  reg [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index_d;
  reg [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index_dd;  
  always @(posedge clk ) begin : proc_valid_index_d
    if(reset) begin
      valid_index_d <= 0;
    end else begin
      valid_index_d <= valid_index;
      valid_index_dd <= valid_index_d; // 2 clk delay
    end
  end
 // assign wei_index = (mode == 1)? wei_index_array_full[2*(base_index + i ) +: 2] : valid_index_dd; //wei_index loop
  assign wei_index = (mode == 1)? wei_index_array[2*i +: 2] : valid_index_dd; //wei_index loop
//-------------------------- end serial -----------------------------------------------------------------------------

endmodule