module column_parallel #(	parameter DATA_WIDTH	=	8,
				parameter ADDR_WIDTH  =	6
)(
	input  clk,    // Clock
	input  reset,  // Asynchronous reset active low
  input  mode,

  input  wr_req_p,
  input  [ DATA_WIDTH  - 1 : 0 ] wr_data_p,

  input  rd_en,
	input  rd_req_p,	  // 0 or 1
//  input  rd_data_pflag,
  output	[ DATA_WIDTH	- 1 : 0 ]	rd_data_p
);
  reg   [ ADDR_WIDTH	- 1 : 0 ]	rd_addr;
  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr_p;
  wire 	[ DATA_WIDTH	- 1 : 0	]	rd_data;
  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr;
  reg								flag_d;
  always @(posedge clk) begin : proc_flag_delay //2 clk delay
  	if(reset) begin
  		flag_d <= 0;
  	end else begin
 // 		flag_d <= rd_data_pflag;
      flag_d <= rd_req_p; 
  	end
  end
  assign rd_data_p = flag_d ? rd_data : 0; //3 clk
  ram #(
    .DATA_WIDTH               ( DATA_WIDTH      ),
    .ADDR_WIDTH               ( ADDR_WIDTH      )
  ) ram_bank (
    .clk                      ( clk             ),  //input
    .reset                    ( reset           ),  //input
    .wr_req                   ( wr_req_p       ),  //input
    .wr_data                  ( wr_data_p      ),  //input

    .rd_req               ( rd_req_p && rd_en      	  ),  //input
    .rd_data              ( rd_data         )  //output
  );
endmodule