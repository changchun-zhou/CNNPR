module cache #(
	parameter	CACHE_WIDTH	=	162,  //8*10
	parameter	ADDR_WIDTH	=	6
	)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input		[ CACHE_WIDTH		- 1 : 0 ] data_in,
	input 									  read_req,
	output 		[ CACHE_WIDTH		- 1 : 0 ] data_out,
	output 		reg							  empty 
);
  reg   write_req;
  reg   write_req_d;
  reg   read_req_d;
  reg   [ ADDR_WIDTH - 1 : 0] wr_addr;
  reg   [ ADDR_WIDTH - 1 : 0] rd_addr;
  
  //
  always @(posedge clk or negedge rst_n) begin : proc_wr_addr
  	if(~rst_n) begin
  		write_req <= 1;
  		wr_addr   <= 0;
  	end else if(clk_en) begin
  		write_req_d <= write_req;
  		if(write_req)
	  		if(wr_addr == 1 << ADDR_WIDTH)
	  			wr_addr <= 0;
	  		else
	  			wr_addr <= wr_addr + 1; //finish_block <= valid_cnt || exchange
	  	else begin
	  		wr_addr <= wr_addr;
	  	end
  	end
  end

  always @(posedge clk or posedge rst_n) begin : proc_rd_addr
  	if (~rst_n) begin
  		// reset
  		rd_addr <= 0;
  		read_req_d <= 0;
  		empty <= 0;
  	end
  	else if (clk_en) begin
  		read_req_d <= read_req;
  		if(read_req)// delay
  			if(rd_addr == wr_addr)
  				empty <= 1;//????
	 		  else if(rd_addr == 1 << ADDR_WIDTH)
  				rd_addr <= 0;
  			else
  				rd_addr <= rd_addr + 1;
  		else
  			rd_addr <= rd_addr; 
  	end
  end

  ram #(
    .DATA_WIDTH               ( CACHE_WIDTH		),
    .ADDR_WIDTH               ( ADDR_WIDTH      )
  ) cache (
    .clk                      ( clk             ),  //input
    .rst_n                    ( rst_n           ),  //input
    .s_write_req              ( write_req_d     ),  //input
    .s_write_data             ( data_in     	),  //input
    .s_write_addr             ( wr_addr         ),  //input
    .s_read_req               ( read_req_d      ),  //input
    .s_read_data              ( data_out      	),  //output
    .s_read_addr              ( rd_addr         ),
    .initial_flag (1'b0),
    .initial_ifmap(1'b0),
    .column       (0)   //input
  );
endmodule