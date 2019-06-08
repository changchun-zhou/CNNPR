module sparsity #(
	parameter integer DATA_WIDTH 	= 1,
  parameter ADDR_WIDTH = 4,
  parameter WEI_INDEX_WIDTH = 2

	)(
	input clk,    // Clock
	input reset,  // Asynchronous reset active low
  input mode,
  input wr_req,
  input wr_data,

	input  rd_req,
  output reg [`IF_SIZE -1 : 0 ]rd_addr,
	output flag_serial,
  output reg finish_wei,
  output reg [ `ACT_INDEX_WIDTH * `IF_WIDTH    - 1 : 0 ] wei_index_array_full,
  output  [ WEI_INDEX_WIDTH * 3    - 1 : 0 ] valid_row	
);
  reg [`IF_SIZE -1 : 0 ]rd_addr_d;
  reg [`IF_SIZE -1 : 0 ]wr_addr;
  reg [`IF_WIDTH - 1 : 0 ]flag_array;
  reg                        start_on_d;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row0;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row1;
  wire [ WEI_INDEX_WIDTH - 1 : 0 ] valid_row2;

  always @(posedge clk) begin : proc_rd_addr_finish_wei
    if(reset) begin
      rd_addr <= 0;
    end else if(mode == 1) begin
      if(rd_req ) begin      
          if (rd_addr < `KERNEL_WIDTH * `KERNEL_WIDTH )begin //0 1 2; 3 4 5
            rd_addr <= rd_addr + 1; //9 
            rd_addr_d<=rd_addr;    
          end else 
            finish_wei <= 1;
      end
      start_on_d <= rd_req;
    end else if (mode == 0) begin
      if(rd_req)
        rd_addr <= rd_addr + 1;
    end
  end
  always @(posedge clk ) begin : proc_wei_index_array_full
    if(reset) begin
    end else if(flag_serial) begin
       wei_index_array_full <= {wei_index_array_full[ `ACT_INDEX_WIDTH * 15  - 1 : 0 ], rd_addr_d};//stack wei_index
    end
  end

  always @(posedge clk ) begin : proc_flag_array
    if(reset) begin
      flag_array <= 0;
    end else if (mode == 1) begin
      if(start_on_d && !finish_wei) begin
        flag_array <= {flag_array[ `IF_WIDTH - 2 : 0], flag_serial}; //for mode0, cache one line:16
      end
    end else if( mode == 0) begin
      if(start_on_d)
        flag_array <= {flag_array[ `IF_WIDTH - 2 : 0], flag_serial}; //for mode0, cache one line:16
    end
  end
wire [ 5 : 0] valid_num_0;
  assign valid_row0 = ( flag_array[8] + flag_array[7] + flag_array[6]);
  assign valid_row1 = ( flag_array[5] + flag_array[4] + flag_array[3]);
  assign valid_row2 = ( flag_array[2] + flag_array[1] + flag_array[0]);
  assign valid_num_0 = flag_array[15] + flag_array[14] + flag_array[13] + flag_array[12] + flag_array[11] + flag_array[10] + flag_array[9] + flag_array[8] + 
                       flag_array[7] + flag_array[6] + flag_array[5] + flag_array[4] + flag_array[3] + flag_array[2] + flag_array[1] + flag_array[0];
  assign valid_row  = (mode == 1) ? {valid_row2, valid_row1, valid_row0} : valid_num_0;


  always @(posedge clk ) begin
    if(reset) begin
      wr_addr <= 0;
    end else if(wr_req) begin
      wr_addr <= wr_addr + 1;
    end
  end
ram #(
  	.DATA_WIDTH               ( DATA_WIDTH              ),
    .ADDR_WIDTH               ( `IF_SIZE        		      )
  ) ram_sflag (
    .clk                      ( clk                     ),  //input
    .reset                    ( reset                   ),  //input
    .s_write_req              ( wr_req                  ),  //input
    .s_write_data             ( wr_data                 ),  //input

    .s_write_addr             ( wr_addr                 ),  //input
    .s_read_req               ( rd_req       			    ),  //input
    .s_read_data              ( flag_serial      				),  //output
    .s_read_addr              ( rd_addr              	  )   //input
  );
endmodule