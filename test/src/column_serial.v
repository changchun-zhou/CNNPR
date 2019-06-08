module column_serial #(	parameter DATA_WIDTH	=	8,
				parameter ADDR_WIDTH  =	6
)(
	input  clk,    // Clock
	input  reset,  // Asynchronous reset active low

  input  wr_req_p,
  input  [ DATA_WIDTH  - 1 : 0 ] wr_data_p,

	input  rd_req_p,	  // 0 or 1
  output	[ DATA_WIDTH	- 1 : 0 ]	rd_data_p
);
  reg   [ ADDR_WIDTH	- 1 : 0 ]	rd_addr;
  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr_p;
  reg   [ ADDR_WIDTH  - 1 : 0 ] wr_addr;

  always @(posedge clk ) begin : proc_rd_addr
  	if(reset) begin
  		rd_addr <= 0;
  	end 
    else begin
      if(rd_req_p)
  			rd_addr <= rd_addr + 1;// what if rd_addr > 1 << ADDR_WIDTH？
      else
        rd_addr <= rd_addr;
  	end
  end

  always @(posedge clk ) begin : proc_wr_addr_p
    if(reset) begin
      wr_addr_p <= 0;
    end else if(wr_req_p) begin
      wr_addr_p <= wr_addr_p + 1;
    end
  end

  ram #(
    .DATA_WIDTH               ( DATA_WIDTH      ),
    .ADDR_WIDTH               ( ADDR_WIDTH      )
  ) ram_bank (
    .clk                      ( clk             ),  //input
    .reset                    ( reset           ),  //input
    .s_write_req              ( wr_req_p       ),  //input
    .s_write_data             ( wr_data_p      ),  //input
    .s_write_addr             ( wr_addr_p      ),  //input

    .s_read_req               ( rd_req_p       	  ),  //input
    .s_read_data              ( rd_data_p         ),  //output
    .s_read_addr              ( rd_addr         )   //input
  );
endmodule