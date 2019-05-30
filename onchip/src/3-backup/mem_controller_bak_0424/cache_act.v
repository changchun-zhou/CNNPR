module cache_act (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input write_req,
	
);

  reg   write_req_d;
  reg   read_req_d;
  reg   [ ADDR_WIDTH - 1 : 0] wr_addr;
  reg   [ ADDR_WIDTH - 1 : 0] rd_addr;
  
  //
  always @(posedge clk or negedge rst_n) begin : proc_wr_addr
  	if(~rst_n) begin
  		wr_addr   <= 0;
  	end else if(clk_en && write_req)
	  		wr_addr <= wr_addr + 1; 
	  	else begin
	  		wr_addr <= wr_addr;
	  	end
  	end
  end

  always @(posedge clk or negedge rst_n) begin : proc_rd_addr
  	if(~rst_n) begin
  		rd_addr   <= 0;
  	end else if(clk_en && read_req)
	  		rd_addr <= rd_addr + 1; 
	  	else begin
	  		rd_addr <= rd_addr;
	  	end
  	end
  end
  
  assign index1 = rd_addr_flag >> 4; //
  assign index2 = ( rd_addr_flag % 16 ) / 3;  // NO.3x3
  ram #(
    .DATA_WIDTH               ( CACHE_WIDTH		),
    .ADDR_WIDTH               ( ADDR_WIDTH      )
  ) cache_act (
    .clk                      ( clk             ),  //input
    .rst_n                    ( rst_n           ),  //input
    .s_write_req              ( write_req     ),  //input
    .s_write_data             ( row_in     	),  //input
    .s_write_addr             ( wr_addr         ),  //input
    .s_read_req               ( read_req      ),  //input
    .s_read_data              ( row_out      	),  //output
    .s_read_addr              ( rd_addr         ),
    .initial_flag (1'b0),
    .initial_ifmap(1'b0),
    .column       (0)   //input
  );

endmodule