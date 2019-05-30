
`timescale 1ns/1ps

`define IF_WIDTH  16
`define KERNEL_WIDTH 3

`define IF_SIZE  256
`define KERNEL_SIZE  9
`define ACT_INDEX_WIDTH 4 // mode0 mode1

module mem_controller #(
  parameter DATA_WIDTH  =  8,

  parameter PARALLEL_WIDTH = DATA_WIDTH * `KERNEL_SIZE ,//72
  parameter SHIFT_WIDTH = DATA_WIDTH*KERNEL_WIDTH,
  parameter WEI_INDEX_WIDTH = 2,//2 only for mode1
  parameter NUM_BLOCK = `IF_WIDTH * `IF_WIDTH / `KERNEL_SIZE,//29
  parameter BLOCK_ADDR_WIDTH = `C_LOG_2 ( NUM_BLOCK )//5


)(
	input	wire	                        clk,    // Clock
	input	wire	                        reset,  // Asynchronous reset active low
//initial
  input                               wr_req_pflag ,   
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
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_p8  ,
  input                               wr_req_sflag,
  input [ `IF_WIDTH        - 1 : 0 ]  wr_data_sflag,
  input                               wr_req_s,
  input [ DATA_WIDTH       - 1 : 0 ]  wr_data_s,
  input                               mode,   //
  input                               start,
  output reg                             en,
  output reg [ PARALLEL_WIDTH   - 1 : 0 ] parallel_out,
  output reg [ DATA_WIDTH       - 1 : 0 ] serial_out,
  output [ `ACT_INDEX_WIDTH - 1 : 0 ] act_index,
  output [ `ACT_INDEX_WIDTH  - 1 : 0 ] wei_index, // only [1:0] for mode1
  output reg [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_index,
  output reg [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_val_num, //0->1 1->2 2->3  4 bit
  output                              zero_flag,  //0

  input  [ `ACT_INDEX_WIDTH  - 1 : 0 ] cnt,
  input                               row_finish_done_0, //weight loop
  input                               row_finish_done_1,  //activation loop not used
  input                               row_cal_done
  
);
  reg                           start_on;
  reg                           start_d;
  reg                           start_dd;
  reg                           start_ddd;
  wire[`KERNEL_SIZE     - 1 : 0 ] wr_data_pflag;

  wire index_finish;
  assign wr_data_pflag = {wr_data_pflag0 ,   
wr_data_pflag1,
wr_data_pflag2,
wr_data_pflag3,
wr_data_pflag4,
wr_data_pflag5,
wr_data_pflag6,
wr_data_pflag7,
wr_data_pflag8} ;
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

  reg [ 1 : 0] state;
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

  reg [1 : 0 ] state_parallel;
  reg parallel_row_read_finish;
  always @(posedge clk ) begin
    if (reset) begin
      // reset
      state_parallel <= PARALLEL_WAIT;
    end
    else  begin
      case ( state_parallel )
      PARALLEL_WAIT: if( mode == 1 ) begin
                        if( start || en || row_cal_done )
                          state_parallel <= PARALLEL_READ;
                      end else 
                        if( start )
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

  always @(posedge clk ) begin
    if (reset) begin
      // reset
      state_serial <= SERIAL_WAIT;
    end
    else  begin
      case ( state_serial )
      SERIAL_WAIT: if( mode == 1 ) begin
                        if( parallel_row_read_finish )// ADD parallel finish
                          state_serial <= SERIAL_READ;
                    end else if( start | start_d | index_finish ) //mode 0
                          state_serial <= SERIAL_READ;
      SERIAL_READ: if ( mode == 1 )// index_finish ahead one clk
                        state_serial <= SERIAL_WAIT;
                   else if ( !(start | start_d | index_finish))
                        state_serial <= SERIAL_WAIT;
      default: state_serial <= SERIAL_WAIT;
      endcase     
    end
  end

 // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //---------------------------------     G L O B A L  ---------------------------------------------------------------------------------------------
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  always @(posedge clk ) begin : proc_start_on
       if(reset) begin
         start_on <= 0;
         start_d  <= 0;
         start_dd <= 0;
         start_ddd <= 0;
       end else begin
         if(start) begin
           start_on <= 1;
         end
       start_d <= start; //delay 2 clk
       start_dd   <= start_d;
       start_ddd <= start_dd;
//       en     <= start_dd;
     end
  end

wire [ `ACT_INDEX_WIDTH - 1 : 0]rd_addr_serial;
  always @(posedge clk ) begin : proc_en
    if(reset) begin
      en <= 0;
    end else if ( (mode == 1 && rd_addr_serial == 5) || ( mode == 0 && start_ddd) ) begin // 3 delay: mode0 -> mode1
      en <= 1;
    end else 
      en <= 0;
  end

//DELAY
  reg [ `ACT_INDEX_WIDTH       - 1 : 0 ]     wei_index_d;
  wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] act_index_0;
  always @(posedge clk ) begin : proc_delay
    if(reset) begin
      wei_index_d <= 0;
    end else begin
      wei_index_d <= wei_index;
    end
  end
  reg [ `ACT_INDEX_WIDTH - 1 : 0 ]   act_index_reg;
  assign act_index = ( mode == 1) ? act_index_reg + wei_index_d : wei_index;// wei_index for serial
  assign zero_flag = row_val_num == 15;  //0 weight 4'd0 - 1 = 15
//---------------------------------------------------------------------------------------
  reg [ WEI_INDEX_WIDTH    - 1 : 0 ] row_index_count;

  wire row_index_count_1;
  wire row_index_count_2;
  wire row_index_count_3;
 always @ (posedge clk ) begin
  if(!reset) begin
    row_index_count <= 0;
  end 
  else if (!row_cal_done) begin
    if(row_index_count!=3)
      row_index_count <= row_index_count + 1;
    else 
      row_index_count <= 0;
  end
 end
 
  assign row_index_count_1 = row_index_count == 1;
  assign row_index_count_2 = row_index_count == 2;
  assign row_index_count_3 = row_index_count == 3;
// always @(row_index_count_3 or reset) begin : proc_row_index
  always @(posedge clk ) begin
  if(reset) begin
    if (mode == 1)
       row_index <= 2;
    else 
      row_index <= -1;
  end else if( ( mode == 1) && row_index_count_3) begin
    row_index <= row_index + 3;
  end else if( (mode == 0) && state == 3)
    row_index <= row_index + 1;
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
//-------------------------Parallel A ----------------------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  reg    [ BLOCK_ADDR_WIDTH  - 1 : 0 ] wr_addr_pflag;
  wire                           read_req_pflag;
  wire                           rd_data_pflag [ 0 : `KERNEL_SIZE     - 1 ];
  reg    [ BLOCK_ADDR_WIDTH  - 1 : 0 ] rd_addr_pflag;
  reg flag_reused;
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
  always @(posedge clk ) begin : proc_rd_addr_pflag
    if(reset) begin
      rd_addr_pflag <= 0;
    end else if(state_parallel == PARALLEL_READ) begin
      rd_addr_pflag <= rd_addr_pflag + 1;
    end
  end

  // always @(posedge clk ) begin
  //   if (reset) begin
  //     // reset
  //     parallel_row_read_finish <= 0;
  //   end else if ( mode == 1 ) begin
  //       if ( rd_addr_pflag != 0 && rd_addr_pflag % 5 == 0)
  //         parallel_row_read_finish <= 1;
  //       else 
  //         parallel_row_read_finish <= 0;     
  //   end else begin
  //       if ( state_parallel == PARALLEL_READ)
  //         parallel_row_read_finish <= 1;
  //   end
  // end
  assign parallel_row_read_finish = (mode==1)? rd_addr_pflag != 0 && rd_addr_pflag % 5 == 0 : state_parallel == PARALLEL_READ;
  always @(posedge clk ) begin : proc_wr_addr_pflag
    if(reset) begin
      wr_addr_pflag <= 0;
    end else if(wr_req_pflag) begin
      wr_addr_pflag <= wr_addr_pflag + 1;
    end
  end

  genvar gv_j;
  generate
    for (gv_j = 0; gv_j < `KERNEL_SIZE; gv_j = gv_j + 1)
    begin : parallel_flag  //16%5 = 1 : flag=0 for two columns padding flag to 18
      ram #(
        .DATA_WIDTH               ( 1                  ),
        .ADDR_WIDTH               ( BLOCK_ADDR_WIDTH   )
      )
      ram_pflag (
        .clk                      ( clk                     ),  //input
        .reset                    ( reset                   ),  //input
        .s_write_req              ( wr_req_pflag            ),  //input
        .s_write_data             ( wr_data_pflag[gv_j]     ),  //input
        .s_write_addr             ( wr_addr_pflag           ),  //input

        .s_read_req               ( state_parallel == PARALLEL_READ ),  //input
        .s_read_data              ( rd_data_pflag[gv_j]     ),  //output
        .s_read_addr              ( rd_addr_pflag           )   //input
      );
    end
  endgenerate

  wire  [ DATA_WIDTH  - 1 : 0 ] rd_data_p [ 0 : `KERNEL_SIZE -1 ];
  genvar gv_i;
  generate
  	for (gv_i = 0; gv_i < `KERNEL_SIZE ; gv_i  = gv_i + 1)
  	begin : parallel_data
	  column_parallel #(
	  )
	  column_parallel (
      .clk          ( clk                   ), 
      .reset	      ( reset                 ), 
      .wr_req_p     ( wr_req_p              ),  //input
      .wr_data_p    ( wr_data_p[gv_i]       ), 

      .rd_req_p     ( rd_data_pflag[gv_i]   ), 
      .rd_data_pflag( rd_data_pflag[gv_i]   ),
      .rd_data_p    ( rd_data_p[gv_i]       )
	  );
	end
  endgenerate

  wire [ PARALLEL_WIDTH   - 1 : 0 ] parallel_in;
  assign parallel_in = (mode == 1) ? {  rd_data_p [ 6 ], rd_data_p [ 7 ], rd_data_p [ 8 ],
                          rd_data_p [ 3 ], rd_data_p [ 4 ], rd_data_p [ 5 ],
                          rd_data_p [ 0 ], rd_data_p [ 1 ], rd_data_p [ 2 ] } : 0;  //9 reshape

  //-----------------------------------PARALLEL------------------------------------------------------
//parallel_out
//act_index: only for mode1
//------------------- mode 1 --------------------------------------------------------------------------
  reg [ PARALLEL_WIDTH * 6  - 1 : 0 ] parallel_array;
  reg [ PARALLEL_WIDTH * 6  - 1 : 0 ] parallel_array_reg;
//  always @(read_req_pflag or reset) begin : proc_parallel_array
  always @(posedge clk ) begin
    if(reset) begin
      act_index_reg  <= 0;
      //read_req_pflag_dd
    end else if( ( mode == 1 ) && (flag_state_parallel_d == 1 ) ) begin // mode1 begin or the first reuse.
      parallel_array_reg <= {parallel_in, parallel_array [ PARALLEL_WIDTH * 2 - 1 : PARALLEL_WIDTH ]};
      if (state == 3) 
        act_index_reg <= 0;
      else 
        act_index_reg <= act_index_reg + 3;//baseset 
    end
  end
 
//only mode1 for this act_index_reg
 always @(posedge clk or negedge reset) begin : proc_act_index_reg 
   if(reset) begin
    act_index_reg  <= 0;
   end else if ( mode  == 1 )begin
     if (state == 3 ) 
        act_index_reg <= 0;
     else if( read_req_pflag ) // begin or every weight row finished
        act_index_reg <= act_index_reg + 3;
   end
 end

 always @(posedge clk ) begin : proc_parallel_array
   if(reset) begin
     parallel_array <= 0;
     ////read_req_pflag: start, start_d,start_dd, 3clk delay, || row_finish_done_0 for begin; then row_index_count_3
   end else if ( (mode == 1) && ( en || row_index_count_3) ) begin // begin stream or every row done refresh
     parallel_array <= parallel_array_reg; // 3x18 
   end else if ( start_dd )
     parallel_array <= parallel_array_reg; // only the first 9 weights.
 end

  always @(posedge clk ) begin
    if(reset) begin
      parallel_out <= 0;
    end else if(mode == 1) begin
        if( flag_reused == 0 )
           parallel_out <= parallel_array[ wei_index*SHIFT_WIDTH+: 3*SHIFT_WIDTH ];
         else  
            parallel_out <= parallel_array[ ( act_index_reg + wei_index )*SHIFT_WIDTH+: 3*SHIFT_WIDTH ];
  //      act_index <= act_index_reg + wei_index; //offset  assign act_index
    end else if(mode == 0) begin
        parallel_out <= parallel_in;
    end     
  end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //-----------------Serial B-------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //--------  one line flag -------------------
//mode1:weight
wire [ `IF_WIDTH    - 1 : 0 ] flag_serial;
reg [ `ACT_INDEX_WIDTH * `IF_WIDTH    - 1 : 0 ] wei_index_array_full;
wire [ WEI_INDEX_WIDTH * 3    - 1 : 0 ] valid_row;

reg   [ `IF_WIDTH          - 1 : 0 ] flag_serial_reg;

//---------------------------------- begin sparity ----------------------------------------------------------------------------
  reg [ `ACT_INDEX_WIDTH       - 1 : 0 ] rd_addr;
  reg [`ACT_INDEX_WIDTH -1 : 0 ]rd_addr_d;
  reg [`ACT_INDEX_WIDTH -1 : 0 ]wr_addr;
  wire [`IF_WIDTH - 1 : 0 ]flag_array;
  reg                        start_on_d;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row0;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row1;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row2;

  always @(posedge clk) begin : proc_rd_addr
     if(reset) begin
       rd_addr <= 0;
    end else if(mode == 1 && rd_req) begin// add 
      rd_addr <= rd_addr + 1; //
    end
  end

  wire [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index;

  assign valid_index = `C_LOG_2( (-flag_serial_reg) & flag_serial_reg );// 11000 -> 3
  wire index_finish;
  always @(posedge clk ) begin : proc_flag_serial_reg
    if(reset) begin
      flag_serial_reg <= 0;
    end else if ( start_dd || index_finish )begin// start delay
      flag_serial_reg <= flag_serial;// refresh 
    end else 
      flag_serial_reg <= flag_serial_reg >> valid_index;// when finished one line ?
  end
  assign index_finish = flag_serial_reg == 0; // ahead 2 clk over row_cal_done_1
  always @(posedge clk ) begin : proc_wei_index_array_full
    if(reset) begin
      wei_index_array_full <= 0;
    end else if( mode == 1) begin
       wei_index_array_full <= {wei_index_array_full[ `ACT_INDEX_WIDTH * ( `IF_WIDTH - 1)  - 1 : 0 ], valid_index};//stack wei_index
    end
  end

  wire [ 5 : 0] valid_num_0;

  assign flag_array = flag_serial;
  assign valid_row0 = ( flag_array[8] + flag_array[7] + flag_array[6]);
  assign valid_row1 = ( flag_array[5] + flag_array[4] + flag_array[3]);
  assign valid_row2 = ( flag_array[2] + flag_array[1] + flag_array[0]);

  assign valid_num_0 = flag_array[15] + flag_array[14] + flag_array[13] + flag_array[12] + flag_array[11] + flag_array[10] + flag_array[9] + flag_array[8] + 
                       flag_array[7] + flag_array[6] + flag_array[5] + flag_array[4] + flag_array[3] + flag_array[2] + flag_array[1] + flag_array[0];
  assign valid_row  = (mode == 1) ? {valid_row2, valid_row1, valid_row0} : valid_num_0;


  always @(posedge clk ) begin
    if(reset) begin
      wr_addr <= 0;
    end else if(wr_req) begin
      wr_addr <= wr_addr + 1;
    end
  end
ram #(
    .DATA_WIDTH               ( `IF_WIDTH              ),
    .ADDR_WIDTH               ( `ACT_INDEX_WIDTH                    )
  ) ram_sflag (
    .clk                      ( clk                     ),  //input
    .reset                    ( reset                   ),  //input
    .s_write_req              ( wr_req                  ),  //input
    .s_write_data             ( wr_data                 ),  //input

    .s_write_addr             ( wr_addr                 ),  //input
    .s_read_req               ( rd_req                  ),  //input
    .s_read_data              ( flag_serial             ),  //output
    .s_read_addr              ( rd_addr                 )   //input
  );
//----------------------------------------end sparity--------------------------------------------------------------------------------------


  wire [ DATA_WIDTH - 1 : 0 ] column_out_serial;
  wire rd_req_s;

  assign rd_req_s = flag_serial_reg != 0;
//---------------------------------------begin column_serial -------------------------------------------------------------------------------
  reg   [ ADDR_WIDTH  - 1 : 0 ] rd_addr_s;
  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr_s;

  always @(posedge clk ) begin : proc_rd_addr
    if(reset) begin
      rd_addr_s <= 0;
    end 
    else begin
      if(flag_serial)
        rd_addr_s <= rd_addr_s + 1;// what if rd_addr > 1 << ADDR_WIDTH？
      else
        rd_addr_s <= rd_addr_s;
    end
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

    .s_read_req               ( flag_serial          ),  //input
    .s_read_data              ( column_out_serial         ),  //output
    .s_read_addr              ( rd_addr_s         )   //input
  );
  wire [ `ACT_INDEX_WIDTH     - 1 : 0 ]      valid_index;
  //--------------------------- begin serial ------------------------------------------------------------------------------
   reg  [ 5       - 1 : 0 ]     row_valid_num_a;
   reg  [ WEI_INDEX_WIDTH       - 1 : 0 ]     j;
   reg  [ DATA_WIDTH * 3        - 1 : 0 ]     serial_array;
   reg  [ WEI_INDEX_WIDTH       - 1 : 0 ]     count_array;
   reg  [ `ACT_INDEX_WIDTH * `IF_WIDTH    - 1 : 0 ]     wei_index_array;
   reg                                        flag_serial_d;
   reg finish_wei_d, finish_wei_dd;
   reg [ DATA_WIDTH            - 1 : 0 ] column_out_serial_d;
   integer i;
  always @(posedge clk ) begin : proc_serial_out
    if(reset) begin
      serial_array <= 0;
      serial_out   <= 0;
      row_val_num  <= 0;
    end else if(mode == 1) begin 
      if( !finish_wei_dd && flag_serial_d) begin
        serial_array <= {column_out_serial, serial_array [ DATA_WIDTH * 3        - 1 : 8 ]}; //stream weight to serial
      end else if(finish_wei_dd) begin
        serial_out <= serial_array[ DATA_WIDTH* i +:DATA_WIDTH ]; //loop weight for a weight row
      end
    end else if (mode == 0) begin     
      column_out_serial_d <= column_out_serial;
      serial_out <= column_out_serial_d;//delay
    end
    row_val_num <= row_valid_num_a - 1; //delay1 clk
    flag_serial_d <= flag_serial;
    finish_wei_d <= finish_wei;
    finish_wei_dd <= finish_wei_d;
  end
  
  always @(posedge clk) begin : proc_wei_index_array //wei_index_array loop
    if(reset) begin
      j <= 0;
      count_array    <= 0;
      row_valid_num_a<= 0;
      wei_index_array<= 0;
    end else if ( (finish_wei || row_cal_done) && mode == 1 ) begin //
      row_valid_num_a <= valid_row[ j  +: 1 ];
      wei_index_array <= wei_index_array_full[ 2*count_array +: 2*3]; //row_wei loop
      count_array <= count_array + row_valid_num_a;
      if( j < row_valid_num_a << 1)
        j <= j + 2'd2;
      else
        j <= 2'd0;
    end else if ((finish_wei || row_cal_done) && mode == 0) begin
      row_valid_num_a <= valid_row;
      wei_index_array <= wei_index_array_full;
    end
  end
  
  always @(posedge clk ) begin : proc_i //loop
      if(reset) begin
        i <= 0;
      end else if (row_cal_done) // new row
        i <= 0;
      else if( i < row_val_num ) begin
        i <= i + 1;
      end else
        i <= 0;
    end
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
  assign wei_index = (mode == 1)? wei_index_array[2*i +: 2] : valid_index_dd; //wei_index loop
//-------------------------- end serial -----------------------------------------------------------------------------
endmodule