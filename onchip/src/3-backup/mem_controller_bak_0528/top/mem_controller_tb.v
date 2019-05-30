`timescale 1ps/1ps
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
//`define MODE1 1
// `define MODE0 1
module mem_controller_tb #(
  parameter DATA_WIDTH  =  8,
  parameter IF_WIDTH =   16,
  parameter KERNEL_WIDTH = 3,

  parameter IF_SIZE = IF_WIDTH*IF_WIDTH,
  parameter KERNEL_SIZE = KERNEL_WIDTH * KERNEL_WIDTH,
  parameter PARALLEL_WIDTH = DATA_WIDTH * KERNEL_SIZE ,
  parameter ACT_INDEX_WIDTH  = `C_LOG_2 ( IF_WIDTH ), //4
  parameter WEI_INDEX_WIDTH = `C_LOG_2 ( KERNEL_WIDTH ),//4
  parameter NUM_BLOCK = ( IF_WIDTH / KERNEL_WIDTH + 1 ) * ( IF_WIDTH / KERNEL_WIDTH + 1 ),//36
  parameter BLOCK_ADDR_WIDTH = `C_LOG_2 ( NUM_BLOCK )
	);
	reg clk;
	reg reset;

	reg 							wr_req_pflag;
	reg [ KERNEL_SIZE     - 1 : 0 ] wr_data_pflag ;
	reg 							wr_req_p;
	reg [ DATA_WIDTH      - 1 : 0 ] wr_data_p [ 0 : NUM_BLOCK - 1];
	reg 							wr_req_sflag ;
	reg [ IF_WIDTH		  - 1 : 0 ]	wr_data_sflag;
	reg 							wr_req_s ;
	reg [ DATA_WIDTH      - 1 : 0 ] wr_data_s;

	reg 							mode;
	reg 							start;
	wire 							en;
	reg [ ACT_INDEX_WIDTH - 1 : 0 ] cnt;
	reg 							row_finish_done_0;
	reg 							row_finish_done_1;
	reg 							row_cal_done;

	reg [ KERNEL_SIZE     - 1 : 0 ] wr_data_pflag_mem [ 0 : NUM_BLOCK - 1];
	reg [ DATA_WIDTH      - 1 : 0 ] wr_data_p_mem     [ 0 : NUM_BLOCK - 1];
	reg [ IF_WIDTH		  - 1 : 0 ]	wr_data_sflag_mem [ 0 : IF_WIDTH     - 1 ];
	reg [ DATA_WIDTH      - 1 : 0 ] wr_data_s_mem [ 0 : IF_SIZE     - 1 ];

	wire [ PARALLEL_WIDTH   - 1 : 0 ] parallel_out;
	wire [ DATA_WIDTH       - 1 : 0 ] serial_out;
	wire [ ACT_INDEX_WIDTH  - 1 : 0 ] act_index;
	wire [ ACT_INDEX_WIDTH  - 1 : 0 ] wei_index;
	wire [ ACT_INDEX_WIDTH  - 1 : 0 ] row_index;
	wire [ ACT_INDEX_WIDTH  - 1 : 0 ] row_val_num;
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
initial begin
	wr_req_pflag = 0;
	$readmemb("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_pflag.dat", wr_data_pflag_mem);
	#60 
	wr_req_pflag = 1;
    for ( i = 0; i < NUM_BLOCK; i = i + 1 ) begin
    	wr_data_pflag = wr_data_pflag_mem[i];
    	$display("wr_data_pflag_mem [%d] = %b", i, wr_data_pflag_mem[i]);
    	#20;
    end
    wr_req_pflag = 0;
end

initial begin
	wr_req_p = 0;
	$readmemh("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_p.dat", wr_data_p_mem);
	#60
	wr_req_p = 1;
	for ( j = 0; j < NUM_BLOCK ; j = j + 1 ) begin
		wr_data_p[0] = wr_data_p_mem[j];
		wr_data_p[1] = wr_data_p_mem[j];
		wr_data_p[2] = wr_data_p_mem[j];
		wr_data_p[3] = wr_data_p_mem[j];
		wr_data_p[4] = wr_data_p_mem[j];
		wr_data_p[5] = wr_data_p_mem[j];
		wr_data_p[6] = wr_data_p_mem[j];
		wr_data_p[7] = wr_data_p_mem[j];
		wr_data_p[8] = wr_data_p_mem[j];
		$display("wr_data_p_mem [%d] = %h", j, wr_data_p_mem[j]);
    	#20;
    end
    wr_req_p = 0;
end

initial begin
	wr_req_sflag = 0;
	$readmemb("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_sflag.dat", wr_data_sflag_mem);
	#60 
	wr_req_sflag = 1;
    for ( k = 0; k < KERNEL_SIZE; k = k + 1 ) begin
    	wr_data_sflag = wr_data_sflag_mem[k];
    	$display("wr_data_sflag_mem [%d] = %b", k, wr_data_sflag_mem[k]);
    	#20;    
    end
    wr_req_sflag = 0;
end

initial begin
	wr_req_s = 0;
	$readmemh("F:/1-DL_hardware/CNNPR/onchip/src/DAT/wr_data_s.dat", wr_data_s_mem);
	#60
	wr_req_s = 1;
	for ( m = 0; m < KERNEL_SIZE ; m = m + 1 ) begin
		wr_data_s = wr_data_s_mem[m];
		$display("wr_data_s_mem [%d] = %h", m, wr_data_s_mem[m]);
    	#20;
    end
    wr_req_s = 0;
end

initial begin
	start = 0; 
	cnt = 0; 
 
	row_finish_done_1 = 0;  
	#632
	start = 1;           
	#20
	start = 0;
	cnt = 0;
	//#d row_finish_done_0 = 1
end

`ifdef MODE1
initial begin
	mode = 1;
	row_cal_done = 0;
	row_finish_done_0 = 0;
	#1
	#990;
	for ( v_pe = 0; v_pe < IF_WIDTH; v_pe = v_pe + 1 ) begin
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

// 0 valid weight
	// #0		row_finish_done_0 = 1; row_cal_done = 1;
	// #20		row_finish_done_0 = 0; row_cal_done = 0;
	// #20

//--row0-1

// 1 valid weight
			row_finish_done_0 = 1;
	#80     						row_cal_done = 1;
	#20		row_finish_done_0 = 0; row_cal_done = 0;
	#20;

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

`else
initial begin //based on < wr_data_pflag.dat >
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

mem_controller mem_controller(
	.clk 				( clk				),
	.reset				( reset				),
	.wr_req_pflag       ( wr_req_pflag      ),
	.wr_data_pflag0	    ( wr_data_pflag[8]	),	//transpose	 
	.wr_data_pflag1     ( wr_data_pflag[7]	),	 
	.wr_data_pflag2	    ( wr_data_pflag[6]  ),	 	
	.wr_data_pflag3	    ( wr_data_pflag[5]  ),	
	.wr_data_pflag4	    ( wr_data_pflag[4]  ),		
	.wr_data_pflag5	    ( wr_data_pflag[3]  ),	 
	.wr_data_pflag6	    ( wr_data_pflag[2]  ),		
	.wr_data_pflag7		( wr_data_pflag[1]  ),		
	.wr_data_pflag8		( wr_data_pflag[0]  ),	 
	.wr_req_p 			( wr_req_p          ),			 	
	.wr_data_p0 		( wr_data_p[8]      ), 			   
	.wr_data_p1 		( wr_data_p[7]      ),
	.wr_data_p2 		( wr_data_p[6]      ),
	.wr_data_p3 		( wr_data_p[5]      ),
	.wr_data_p4 		( wr_data_p[4]      ),
	.wr_data_p5 		( wr_data_p[3]      ),
	.wr_data_p6 		( wr_data_p[2]      ),
	.wr_data_p7 		( wr_data_p[1]      ),
	.wr_data_p8 		( wr_data_p[0]      ),  
	.wr_req_sflag 		( wr_req_sflag 		),
	.wr_data_sflag      ( wr_data_sflag 	),
	.wr_req_s 			( wr_req_s 			),
	.wr_data_s 			( wr_data_s 		),
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

	.cnt 				( cnt 				),
	.row_finish_done_0 	( row_finish_done_0 ), //input
	.row_finish_done_1	( row_finish_done_1 ), //input
	.row_cal_done 		( row_cal_done 		)
	);
endmodule