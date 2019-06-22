//set clk period
//set reset high/low
//set mode
 `define MODE1 1
// `define JOINT_DEBUG 1
//`define MODE0 1
`include "def_params.vh" 
module mem_controller_tb;
    parameter PERIOD = 5;//200MHZ 
      parameter NUM = 3;
	reg clk;
	reg reset;

	reg 							wr_req_act_flag;
	reg [ `IF_WIDTH     - 1 : 0 ] 	wr_data_act_flag ;
	reg [ `IF_WIDTH     - 1 : 0 ]	wr_req_act;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act0 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act1 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act2 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act3 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act4 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act5 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act6 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act7 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act8 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act9 ;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act10;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act11;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act12;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act13;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act14;
	reg [ `DATA_WIDTH       - 1 :0] wr_data_act15;
    reg [ `DATA_WIDTH 		- 1 : 0 ] wr_data_act[ `IF_WIDTH  - 1 : 0 ];
	reg 							wr_req_wei_flag;
	reg [ `KERNEL_SIZE		  - 1 : 0 ]	wr_data_wei_flag;
	reg 							wr_req_wei ;
	reg [ `DATA_WIDTH      - 1 : 0 ] wr_data_wei;

	reg 							mode;
	reg 							start;
	wire 							en;
	reg [ `ACT_INDEX_WIDTH - 1 : 0 ] cnt;
	reg 							wait_state;
	reg 							row_finish_done_0;
	reg 							row_finish_done_1;
	reg 							row_cal_done;

	reg [ `IF_WIDTH     - 1 : 0 ] wr_data_act_flag_mem [ 0 : `IF_WIDTH - 1];
	reg [ `DATA_WIDTH * `IF_WIDTH      - 1 : 0 ] wr_data_act_mem [ 0 : `IF_WIDTH - 1];
	reg [ `KERNEL_SIZE		  - 1 : 0 ]	wr_data_wei_flag_mem[ 0 : 1]; 
	reg [ `DATA_WIDTH      - 1 : 0 ] wr_data_wei_mem [ 0 : `KERNEL_SIZE     - 1 ];

	wire [ `PARALLEL_WIDTH   - 1 : 0 ] parallel_out;
	wire [ `DATA_WIDTH       - 1 : 0 ] serial_out;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] act_index;
	wire [ `WEI_INDEX_WIDTH  - 1 : 0 ] wei_index;
	wire [ `WEI_INDEX_WIDTH  - 1 : 0 ] wei_row_index;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_index;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_val_num;
    wire                         zero_flag; //0
	integer i,j,k,m,n,v_pe;
// //`ifdef SYNTH
// 	initial
// 	$sdf_annotate("../synthesis/gate/mem_controller.sdf", mem_controller,,,"MAXIMUM");
// //`endif
initial begin	
	clk = 0;
	reset = 1;
	#(PERIOD*0.7);
	reset = 0;
	#(PERIOD*0.5) 
	reset = 1;
	#(PERIOD*250);
	$finish;
end
initial begin
	$dumpfile("mem_controller_tb.vcd");
	$dumpvars;
end
always 
	# (PERIOD*0.5) clk = ~clk;

///////////////////////////////////////// Initial RAM //////////////////////////////////////////////////////////////////
initial begin
	wr_req_act_flag = 0;
	$readmemb("./DAT/wr_data_act_flag.dat", wr_data_act_flag_mem);
	#(PERIOD*3) 
	wr_req_act_flag = 1;
    for ( i = 0; i < `IF_WIDTH; i = i + 1 ) begin
    	wr_data_act_flag = wr_data_act_flag_mem[i];
    	$display("wr_data_act_flag_mem [%d] = %b", i, wr_data_act_flag_mem[i]);
    	#(PERIOD*1);
    end
    wr_req_act_flag = 0;
end

initial begin
	wr_req_act = 0;
	$readmemb("./DAT/wr_data_act.dat", wr_data_act_mem);
	#(PERIOD*3) 
	for ( j = 0; j < `IF_WIDTH ; j = j + 1 ) begin
		wr_req_act =  wr_data_act_flag ;
		{ wr_data_act[0], 	wr_data_act[1], 	wr_data_act[2], 	wr_data_act[3], //no sparity
		  wr_data_act[4], 	wr_data_act[5], 	wr_data_act[6], 	wr_data_act[7], 
		  wr_data_act[8], 	wr_data_act[9], 	wr_data_act[10], 	wr_data_act[11], 
		  wr_data_act[12], 	wr_data_act[13], 	wr_data_act[14], 	wr_data_act[15]} 
		  = wr_data_act_mem[j];
		$display("wr_data_act_mem [%d] = %h", j, wr_data_act_mem[j]);
    	#(PERIOD*1);
    end
    wr_req_act = 0;
end

initial begin
	wr_req_wei_flag = 0;
	$readmemb("./DAT/wr_data_wei_flag.dat", wr_data_wei_flag_mem);
	#(PERIOD*3) 
	wr_req_wei_flag = 1;
    for ( k = 0; k < 1; k = k + 1 ) begin
    	wr_data_wei_flag = wr_data_wei_flag_mem[k];
    	$display("wr_data_wei_flag_mem [%d] = %b", k, wr_data_wei_flag_mem[k]);
    	#(PERIOD*1);    
    end
    wr_req_wei_flag = 0;
end

initial begin
	wr_req_wei = 0;
	$readmemh("./DAT/wr_data_wei.dat", wr_data_wei_mem);
	#(PERIOD*3)
	wr_req_wei = 1;
	for ( m = 0; m < `KERNEL_SIZE ; m = m + 1 ) begin
		wr_data_wei = wr_data_wei_mem[m];
		$display("wr_data_wei_mem [%d] = %h", m, wr_data_wei_mem[m]);
    	#(PERIOD*1);
    end
    wr_req_wei = 0;
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////  Launch ////////////////////////////
initial begin
	start = 0; 
	cnt = 0; 
	row_finish_done_1 = 0;  
	#(PERIOD *31.6) //
	start = 1;           
	#(PERIOD*1)
	start = 0;
	cnt = 0;
	//#d row_finish_done_0 = 1
end

`ifdef JOINT_DEBUG
/////////////////////// IFN JOINT_DEBUG ////////////////////////////////////////////////////////////////////////////
`elsif MODE1
initial begin
	mode = 1;
	wait_state = 0;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	//
//    #(PERIOD*0.4)
	//
	#(PERIOD*0.05)
	#(PERIOD*44.5); //#890;//first state=wait end
	for ( v_pe = 0; v_pe < `IF_WIDTH; v_pe = v_pe + 1 ) begin
//---------row0-0--------------
// 1 valid weight
			row_finish_done_0 = 1;
	#(PERIOD*4)     						row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
	#(PERIOD*1);

//0 valid weight
	#0		row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
	#(PERIOD*1)


// 2 valid weights
	#(PERIOD*1) 	row_finish_done_0 = 1;
	#(PERIOD*1)		row_finish_done_0 = 0;
	#(PERIOD*1)		row_finish_done_0 = 1;
	#(PERIOD*1)		row_finish_done_0 = 0;
	#(PERIOD*1)		row_finish_done_0 = 1;
	#(PERIOD*1)		row_finish_done_0 = 0;
	#(PERIOD*1)		row_finish_done_0 = 1;
	#(PERIOD*1)		row_finish_done_0 = 0;
	#(PERIOD*1)		row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
	#(PERIOD*1);



//--row0-1


//--row0-2

// 3 valid weight
	// #(PERIOD*2)		row_finish_done_0 = 1;
	// #(PERIOD*1)		row_finish_done_0 = 0;
	// #(PERIOD*2)		row_finish_done_0 = 1;
	// #(PERIOD*1)		row_finish_done_0 = 0;
	// #(PERIOD*2)		row_finish_done_0 = 1;
	// #(PERIOD*1)		row_finish_done_0 = 0;
	// #(PERIOD*2)		row_finish_done_0 = 1;
	// #(PERIOD*1)		row_finish_done_0 = 0;
	// #(PERIOD*2)		row_finish_done_0 = 1; row_cal_done = 1;
	// #(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
	// #(PERIOD*1);
	end
end

`elsif MODE0
initial begin //based on < wr_data_act_flag.dat >
	mode = 0;
	wait_state = 0;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#(PERIOD*0.05)
	#(PERIOD*43.5) //#870//first state=3 end
//7 valid data
	#(PERIOD*7)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//4 valid data 
	#(PERIOD*4)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)     row_finish_done_0 = 0; row_cal_done = 0;
//5 valid data
	#(PERIOD*5)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//2 valid data
	#(PERIOD*2)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;

//5 valid data
	#(PERIOD*5)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//3 valid data
	#(PERIOD*3)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//4 valid data
	#(PERIOD*4)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//7 valid data
	#(PERIOD*7)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;

//2 valid data
	#(PERIOD*2)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//3 valid data
	#(PERIOD*3)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//7 valid data
	#(PERIOD*7)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//3 valid data
	#(PERIOD*3)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;

//3 valid data
	#(PERIOD*3)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//7 valid data
	#(PERIOD*7)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//6 valid data
	#(PERIOD*6)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;
//4 valid data
	#(PERIOD*4)  	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;

end

`endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


mem_controller mem_controller(
	.clk 				( clk				),
	.reset				( reset				),
	.wr_req_act_flag    ( wr_req_act_flag   ),		
	.wr_data_act_flag   ( wr_data_act_flag  ),	 
	.wr_req_act 		( wr_req_act        ),			 	
	.wr_data_act0 		( wr_data_act[0 ] ),
	.wr_data_act1 		( wr_data_act[1 ] ),
	.wr_data_act2 		( wr_data_act[2 ] ),
	.wr_data_act3 		( wr_data_act[3 ] ),
	.wr_data_act4 		( wr_data_act[4 ] ),
	.wr_data_act5 		( wr_data_act[5 ] ),
	.wr_data_act6 		( wr_data_act[6 ] ),
	.wr_data_act7 		( wr_data_act[7 ] ),
	.wr_data_act8 		( wr_data_act[8 ] ),
	.wr_data_act9 		( wr_data_act[9 ] ),
	.wr_data_act10		( wr_data_act[10] ),
	.wr_data_act11		( wr_data_act[11] ),
	.wr_data_act12		( wr_data_act[12] ),
	.wr_data_act13		( wr_data_act[13] ),
	.wr_data_act14		( wr_data_act[14] ),
	.wr_data_act15		( wr_data_act[15] ), 			   
	.wr_req_wei_flag 	( wr_req_wei_flag 		),
	.wr_data_wei_flag   ( wr_data_wei_flag 	),
	.wr_req_wei 	    ( wr_req_wei 			),
	.wr_data_wei 	    ( wr_data_wei 		),
	.mode 				( mode 				),
	.start 				( start 			),

	.en 				( en 				),
	.parallel_out 		( parallel_out 		),
	.serial_out 		( serial_out 		),
	.act_index  		( act_index 		),
	.wei_col_index 		( wei_index 		),
	.wei_row_index    	( wei_row_index		),
	.row_index 			( row_index 		),
	.row_val_num        ( row_val_num 		),
	.zero_flag          ( zero_flag 		),

	.cnt 				( cnt 				), //not used
	.wait_state         ( wait_state 		),
	.row_finish_done_0 	( row_finish_done_0 ), //input
	.row_finish_done_1	( row_finish_done_1 ), //input
	.row_cal_done 		( row_cal_done 		)
	);
endmodule
