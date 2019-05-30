module block #(
	parameter	DATA_WIDTH	=	16,
	parameter	ADDR_WIDTH  =	1	//two ifmap
	) (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input new_if, //new input feature map
	output  [DATA_WIDTH - 1: 0] valid
);
  reg  [ ADDR_WIDTH	- 1 : 0 ]	rd_addr;
  reg  [ ADDR_WIDTH - 1 : 0 ] wr_addr;
  reg                         write_req;
  reg  [DATA_WIDTH - 1: 0]    write_data;
  always @(posedge clk or negedge rst_n) begin : proc_rd_addr
  	if(~rst_n) begin
  		rd_addr <= 0;
  	end else if(clk_en) begin
  		if(new_if)
  			rd_addr <= rd_addr + 1;
  	end
  end
  
  ram #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( ADDR_WIDTH        )
  ) ram_bank (
    .clk                      ( clk                      ),  //input
    .rst_n                    ( rst_n                    ),  //input
    .s_write_req              ( write_req      ),  //input
    .s_write_data             ( write_data     ),  //input
    .s_write_addr             ( wr_addr              ),  //input
    .s_read_req               ( new_if       				),  //input
    .s_read_data              ( valid      ),  //output
    .s_read_addr              ( rd_addr              ) ,  //input
    .initial_flag (1'b0),
    .initial_ifmap(1'b0),
    .column       (0)
  );
endmodule