module sparsity #(
	parameter integer DATA_WIDTH 	= 1,
	parameter integer ADDR_WIDTH 	= 6,
	parameter integer BLOCK_WIDTH	= 10,
  parameter NUM_BLOCK = 16,
	parameter IF_WIDTH	= 	34	
	)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input read_req,
//	input write_req,
//	input [NUM_BLOCK - 1 : 0] valid,  
//	input [ 32	- 1 : 0 ] 	j,					
//	input  flag_in,
	output flag
//	output reg [1 : 0] 				jump,
//	output 		[2:0]				num_block,
//  output reg    [ ADDR_WIDTH  - 1 : 0 ] rd_addr			
);
  reg    [ ADDR_WIDTH  - 1 : 0 ] rd_addr;  
  reg  	[ ADDR_WIDTH	- 1 : 0 ]	wr_addr;
  wire  wr_data;
  wire 								block_valid;
  reg								flag_pad;
  reg   write_req;
  always @(posedge clk or negedge rst_n) begin : proc_rd_addr
  	if(~rst_n) begin
  		rd_addr <= 0;
//  		jump 	<= 0;
  		flag_pad <= 1;
      write_req <= 0;
  	end else if(clk_en) begin
      rd_addr <= rd_addr + 1;
    end
  end

  ram #(
  	.DATA_WIDTH               ( DATA_WIDTH              ),
    .ADDR_WIDTH               ( ADDR_WIDTH        		)
  )
  ram_flag0 (
    .clk                      ( clk                     ),  //input
    .rst_n                    ( rst_n                   ),  //input
    .s_write_req              ( write_req      ),  //input
    .s_write_data             ( wr_data     ),  //input

    .s_write_addr             ( wr_addr              ),  //input
    .s_read_req               ( read_req       			),  //input
    .s_read_data              ( flag      				),  //output
    .s_read_addr              ( rd_addr              	),   //input
    .initial_flag			( 1'b1 ),
    .initial_ifmap			(1'b0),
    .column                 (0)
  );
endmodule