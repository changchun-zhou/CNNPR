`timescale 1ps/1ps
//set clk period
//set reset high/low
//set mode

 `define MODE1 1
// `define JOINT_DEBUG 1
//`define MODE0 1

`define C_LOG_2(n) (\
(n) <= (1<<0) ? 0 : (n) <= (1<<1) ? 1 :\
(n) <= (1<<2) ? 2 : (n) <= (1<<3) ? 3 :\
(n) <= (1<<4) ? 4 : (n) <= (1<<5) ? 5 :\
(n) <= (1<<6) ? 6 : (n) <= (1<<7) ? 7 :\
(n) <= (1<<8) ? 8 : (n) <= (1<<9) ? 9 :\
(n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
(n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
(n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
(n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
(n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
(n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
(n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
(n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
(n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
(n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
(n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)
`define DATA_WIDTH  8
`define IF_WIDTH  16
`define KERNEL_WIDTH 3

`define IF_SIZE  256
`define KERNEL_SIZE  9
`define ACT_INDEX_WIDTH 4 // mode0 mode1
`define WEI_INDEX_WIDTH 2//2 only for mode1
`define ADDR_WIDTH 4
`define PARALLEL_WIDTH 72
module mem_controller_tb #(
	);
	reg clk;
	reg reset;

	reg 							wr_req_act_flag;
	reg [ `IF_WIDTH     - 1 : 0 ] 	wr_data_act_flag ;
	reg 							wr_req_act;
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
	reg 							row_finish_done_0;
	reg 							row_finish_done_1;
	reg 							row_cal_done;

	reg [ `IF_WIDTH     - 1 : 0 ] wr_data_act_flag_mem [ 0 : `IF_WIDTH - 1];
	reg [ `DATA_WIDTH * `IF_WIDTH      - 1 : 0 ] wr_data_act_mem [ 0 : `IF_WIDTH - 1];
	reg [ `KERNEL_SIZE		  - 1 : 0 ]	wr_data_wei_flag_mem; 
	reg [ `DATA_WIDTH      - 1 : 0 ] wr_data_wei_mem [ 0 : `KERNEL_SIZE     - 1 ];

	wire [ `PARALLEL_WIDTH   - 1 : 0 ] parallel_out;
	wire [ `DATA_WIDTH       - 1 : 0 ] serial_out;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] act_index;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] wei_index;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_index;
	wire [ `ACT_INDEX_WIDTH  - 1 : 0 ] row_val_num;
    wire                         zero_flag; //0
	integer i,j,k,m,n,v_pe;
initial begin	
	clk = 0;
	reset = 0;
	#10;
	reset = 1;
	#30 
	reset = 0;
	#5000
	$finish;
end
initial begin
	$dumpfile("mem_controller_tb.vcd");
	$dumpvars;
end
always 
	#10 clk = ~clk;

///////////////////////////////////////// Initial RAM //////////////////////////////////////////////////////////////////
initial begin
	wr_req_act_flag = 0;
	$readmemb("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_act_flag.dat", wr_data_act_flag_mem);
	#60 
	wr_req_act_flag = 1;
    for ( i = 0; i < `IF_WIDTH; i = i + 1 ) begin
    	wr_data_act_flag = wr_data_act_flag_mem[i];
    	$display("wr_data_act_flag_mem [%d] = %b", i, wr_data_act_flag_mem[i]);
    	#20;
    end
    wr_req_act_flag = 0;
end

initial begin
	wr_req_act = 0;
	$readmemh("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_act.dat", wr_data_act_mem);
	#60
	wr_req_act = 1;
	for ( j = 0; j < `IF_WIDTH ; j = j + 1 ) begin
		{ wr_data_act[0], 	wr_data_act[1], 	wr_data_act[2], 	wr_data_act[3], //no sparity
		  wr_data_act[4], 	wr_data_act[5], 	wr_data_act[6], 	wr_data_act[7], 
		  wr_data_act[8], 	wr_data_act[9], 	wr_data_act[10], 	wr_data_act[11], 
		  wr_data_act[12], 	wr_data_act[13], 	wr_data_act[14], 	wr_data_act[15]} 
		  = wr_data_act_mem[j];
		$display("wr_data_act_mem [%d] = %h", j, wr_data_act_mem[j]);
    	#20;
    end
    wr_req_act = 0;
end

initial begin
	wr_req_wei_flag = 0;
	$readmemb("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_wei_flag.dat", wr_data_wei_flag_mem);
	#60 
	wr_req_wei_flag = 1;
    for ( k = 0; k < 1; k = k + 1 ) begin
    	wr_data_wei_flag = wr_data_wei_flag_mem[k];
    	$display("wr_data_wei_flag_mem [%d] = %b", k, wr_data_wei_flag_mem[k]);
    	#20;    
    end
    wr_req_wei_flag = 0;
end

initial begin
	wr_req_wei = 0;
	$readmemh("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_wei.dat", wr_data_wei_mem);
	#60
	wr_req_wei = 1;
	for ( m = 0; m < `KERNEL_SIZE ; m = m + 1 ) begin
		wr_data_wei = wr_data_wei_mem[m];
		$display("wr_data_wei_mem [%d] = %h", m, wr_data_wei_mem[m]);
    	#20;
    end
    wr_req_wei = 0;
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////  Launch ////////////////////////////
initial begin
	start = 0; 
	cnt = 0; 
	row_finish_done_1 = 0;  
	#632 //
	start = 1;           
	#20
	start = 0;
	cnt = 0;
	//#d row_finish_done_0 = 1
end

`ifdef JOINT_DEBUG
/////////////////////// IFN JOINT_DEBUG ////////////////////////////////////////////////////////////////////////////
`elsif MODE1
initial begin
	mode = 1;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#1
	#970;
	for ( v_pe = 0; v_pe < `IF_WIDTH; v_pe = v_pe + 1 ) begin
//---------row0-0--------------

// 2 valid weights
	#20 	row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#20		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#20		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#20		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#20		row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
	#20;

//0 valid weight
	#0		row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
	#20

//--row0-1

// 1 valid weight
	// 		row_finish_done_0 = 1;
	// #80     						row_cal_done = 1;
	// #20		row_finish_done_0 = 0; row_cal_done = 0;
	// #20;

//--row0-2

// 3 valid weight
	#40		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#40		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#40		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#40		row_finish_done_0 = 1;
	#20		row_finish_done_0 = 0;
	#40		row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
	#20;
	end
end

`elsif MODE0
initial begin //based on < wr_data_act_flag.dat >
	mode = 0;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#1
	#870
//10 valid data
	#200	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
//13 valid data 
	#260	row_finish_done_0 = 1; row_cal_done = 1;
	#20     row_finish_done_0 = 0; row_cal_done = 0;
//13 valid data
	#260	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;

//8 valid data
	#160	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
//12 valid data
	#240	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
//14 valid data
	#280	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;

//7 valid data
	#140	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
//0 valid data
	#20  	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
//11 valid data
	#220  	row_finish_done_0 = 1; row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
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
	.wei_index 			( wei_index 		),
	.row_index 			( row_index 		),
	.row_val_num        ( row_val_num 		),
	.zero_flag          ( zero_flag 		),

	.cnt 				( cnt 				), //not used
	.row_finish_done_0 	( row_finish_done_0 ), //input
	.row_finish_done_1	( row_finish_done_1 ), //input
	.row_cal_done 		( row_cal_done 		)
	);
endmodule