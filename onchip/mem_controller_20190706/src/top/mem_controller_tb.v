//set clk period
//set reset high/low
//set mode
//  `define MODE1 1
 `define JOINT_DEBUG 1
// `define MODE0 1
`include "def_params.vh" 
module mem_controller_tb;
    parameter PERIOD = 5;//200MHZ 
      parameter NUM = 3;
	reg clk;
	reg reset;

	reg 							  wr_req_act_flag;
	reg [ `IF_WIDTH     	- 1 : 0 ] wr_data_act_flag ;
	reg 						      wr_req_act;
    reg [ `FM_DATA_WIDTH 	- 1 : 0 ] wr_data_act;
	reg 							  wr_req_wei_flag;
	reg [ `KERNEL_SIZE		- 1 : 0 ] wr_data_wei_flag;
	reg 							  wr_req_wei ;
	reg [ `DATA_WIDTH       - 1 : 0 ] wr_data_wei;

	reg 							  mode;
	reg 							  start;
	wire 							  en;
	wire [ 2                : 0 ] state;
	reg [ `ACT_INDEX_WIDTH 	- 1 : 0 ] cnt;
	reg 							  wait_state;
	reg 							  row_finish_done_0;
	wire                              row_finish_done_0_wire;
	reg 							  row_finish_done_1;
	reg   							  row_cal_done;
	wire 							  row_cal_done_wire;

	reg [ `IF_WIDTH     	- 1 : 0 ] wr_data_act_flag_mem 	[ 0 : `IF_WIDTH 	- 1 ];
	reg [ `FM_DATA_WIDTH    - 1 : 0 ] wr_data_act_mem 		[ `FM_WIDTH * `IF_WIDTH     - 1 : 0 ];
	reg [ `KERNEL_SIZE		- 1 : 0 ] wr_data_wei_flag_mem 	[ 0 : 			  	  1 ]; 
	reg [ `DATA_WIDTH       - 1 : 0 ] wr_data_wei_mem  		[ 0 : `KERNEL_SIZE	- 1 ];

	wire [ `PARALLEL_WIDTH 	- 1 : 0 ] parallel_out;
	wire [ `DATA_WIDTH      - 1 : 0 ] serial_out;
	wire [ `ACT_INDEX_WIDTH - 1 : 0 ] act_index;
	wire [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_index;
	wire [ `WEI_INDEX_WIDTH - 1 : 0 ] wei_row_index;
	wire [ `ACT_INDEX_WIDTH - 1 : 0 ] row_index;
	wire [ `ACT_INDEX_WIDTH - 1 : 0 ] row_val_num;
    wire                         	  zero_flag; //0
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
//	$finish;
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
	#(PERIOD*3.1) 
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
	#(PERIOD*3.1) 
	wr_req_act = 1;
	for ( j = 0; j < `FM_WIDTH * `IF_WIDTH ; j = j + 1 ) begin
		wr_data_act = { wr_data_act_mem[j][0			 	+: `DATA_WIDTH ],
						wr_data_act_mem[j][`DATA_WIDTH 		+: `DATA_WIDTH ],
						wr_data_act_mem[j][`DATA_WIDTH *2	+: `DATA_WIDTH ]};
		$display("wr_data_act_mem [%d] = %h", j, wr_data_act_mem[j]);
    	#(PERIOD*1);
    end
    wr_req_act = 0;
end

initial begin
	wr_req_wei_flag = 0;
	$readmemb("./DAT/wr_data_wei_flag.dat", wr_data_wei_flag_mem);
	#(PERIOD*3.1) 
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
	#(PERIOD *99.6) //
	start = 1;           
	#(PERIOD*1)
	start = 0;
	cnt = 0;
	//#d row_finish_done_0 = 1
	#(PERIOD*250);
	$finish;
end

`ifdef JOINT_DEBUG

/////////////////////// IFN JOINT_DEBUG ////////////////////////////////////////////////////////////////////////////
initial begin
	mode = 1;
	wait_state = 0;
end

`elsif MODE1
initial begin
	mode = 1;
	wait_state = 0;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#(PERIOD*100.6)
	#(PERIOD*2); //#890;//first state=tran end
	for ( v_pe = 0; v_pe < `IF_WIDTH; v_pe = v_pe + 1 ) begin
//---------row0-0--------------
// 1 valid weight
					row_finish_done_0 = 1;
	#(PERIOD*4)     						row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; 	row_cal_done = 0;
	#(PERIOD*1);

//0 valid weight
	#0				row_finish_done_0 = 1; 	row_cal_done = 1; 
	#(PERIOD*1)		row_finish_done_0 = 0; 	row_cal_done = 0;	wait_state = 1;
	#(PERIOD*1)
    #(PERIOD*2); 												wait_state = 0;//`WAIT 2 CLK 
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
	#(PERIOD*1)		row_finish_done_0 = 1; 	row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; 	row_cal_done = 0;
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
	$finish;
end

`elsif MODE0
initial begin //based on < wr_data_act_flag.dat >
	mode = 0;
	wait_state = 0;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#(PERIOD*101.6) //#870//first state=2 begin
//7 valid data
	#(PERIOD*7)	row_finish_done_0 = 1; row_cal_done = 1;
	#(PERIOD*1)		row_finish_done_0 = 0; row_cal_done = 0;	wait_state = 1;
	#(PERIOD*3)     wait_state = 0;
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
	$finish;
end

`endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


mem_controller mem_controller(
	.clk 				( clk				),
	.reset				( reset				),
	.wr_req_act_flag    ( wr_req_act_flag   ),		
	.wr_data_act_flag   ( wr_data_act_flag  ),	 
	.wr_req_act 		( wr_req_act        ),			 	
	.wr_data_act 		( wr_data_act 	 	),			   
	.wr_req_wei_flag 	( wr_req_wei_flag 	),
	.wr_data_wei_flag   ( wr_data_wei_flag 	),
	.wr_req_wei 	    ( wr_req_wei 	  	),
	.wr_data_wei 	    ( wr_data_wei 		),
	.mode 				( mode 				),
	.start 				( start 			),

	.en 				( en 				),
	.state              ( state             ),
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
	.row_finish_done_0 	( row_finish_done_0_wire ), //input
	.row_finish_done_1	( row_finish_done_1 ), //input
	.row_cal_done 		( row_cal_done_wire 		)
	);
endmodule
