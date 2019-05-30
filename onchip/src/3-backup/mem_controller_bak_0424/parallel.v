module parallel #(  //sipo
	parameter PARALLEL_WIDTH = 72,
	parameter SHIFT_WIDTH   = 24,
  parameter WEI_INDEX_WIDTH = 2
)(
	input clk,    // Clock
	input reset,  // Asynchronous reset active low
  input mode,
  input en,
	input [ PARALLEL_WIDTH		- 1 : 0 ] 	parallel_in, 
  input [ `ACT_INDEX_WIDTH		- 1 : 0 ] wei_index,// although 2->4 , value is same. right
	input 									              read_req_pflag,
	input 									              row_cal_done,
  input                                 flag_reused,
  input [ 1 : 0]                        state,
  input                                 flag_stream_act_1,
  input                                 row_index_count_3,
  input                                 start_dd,
  input                                 flag_state_parallel_d,

  output reg [ PARALLEL_WIDTH		- 1 : 0 ] parallel_out, 
	output reg [ `ACT_INDEX_WIDTH 	- 1 : 0 ] act_index_reg
	
);
//parallel_out
//act_index: only for mode1
//------------------- mode 1 --------------------------------------------------------------------------
  reg [ PARALLEL_WIDTH * 6	- 1 : 0 ] parallel_array;
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
  //	    act_index <= act_index_reg + wei_index; //offset  assign act_index
    end else if(mode == 0) begin
        parallel_out <= parallel_in;
    end	    
  end


endmodule