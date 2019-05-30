module column #(	parameter DATA_WIDTH	=	8,
				parameter ADDR_WIDTH  =	6,
         parameter BLOCK_WIDTH  = 10

)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input flag,	  // 0 or 1
  output	[ DATA_WIDTH	- 1 : 0 ]	column_out
 // input   [ 32  - 1 : 0 ] j,
// input  [ ADDR_WIDTH - 1 : 0 ] rd_addr_flag
);
  reg  [ ADDR_WIDTH	- 1 : 0 ]	rd_addr;
  wire 	[ DATA_WIDTH	- 1 : 0	]	rd_data;
    reg  [ ADDR_WIDTH - 1 : 0 ] wr_addr;
  wire  [ DATA_WIDTH  - 1 : 0 ] write_data;
  reg                           write_req;

  reg               flag_pad;
  reg								flag_d;
  reg								flag_dd;
//  reg               flag_ddd;
//  reg [ ADDR_WIDTH - 1 : 0 ] rd_addr_flag_d;
  always @(posedge clk or negedge rst_n) begin : proc_flag_delay //2 clk delay
  	if(~rst_n) begin
  		flag_d <= 0;
  		flag_dd <= 0;
  	end else if(clk_en) begin
  		flag_d <= flag;
  		flag_dd <= flag_d;
//      flag_ddd<= flag_dd;
 //     rd_addr_flag_d <= rd_addr_flag;
  	end
  end
  assign column_out = flag_dd ? rd_data : 0; //3 clk
  always @(posedge clk or negedge rst_n) begin : proc_rd_addr
  	if(~rst_n) begin
  		rd_addr <= -1;
      flag_pad <= 1; //need back read
      write_req <=0;
  	end 
    else if(clk_en) begin
      if(flag)
  			rd_addr <= rd_addr + 1;// what if rd_addr > 1 << ADDR_WIDTH？
      else
        rd_addr <= rd_addr;
  	end
  end
  ram_ifm #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( ADDR_WIDTH        )
  ) ram_bank (
    .clk                      ( clk                      ),  //input
    .rst_n                    ( rst_n                    ),  //input
    .s_write_req              ( write_req      ),  //input
    .s_write_data             ( write_data     ),  //input
    .s_write_addr             ( wr_addr              ),  //input
    .s_read_req               ( flag_d       				),  //input
    .s_read_data              ( rd_data      ),  //output
    .s_read_addr              ( rd_addr              ),   //input
    .initial_flag             (1'b0),
    .initial_ifmap            (1'b1),
    .column                   (0)
  );
endmodule