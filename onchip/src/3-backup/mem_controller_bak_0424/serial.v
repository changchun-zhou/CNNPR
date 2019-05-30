module serial #(
  parameter DATA_WIDTH  =  8,
   parameter WEI_INDEX_WIDTH = 2
   )(
	input                                             clk,    // Clock
	input                                             reset,  // Asynchronous reset active low
  input                                             mode,
	input       [ `ACT_INDEX_WIDTH * `IF_WIDTH   - 1 : 0 ]     wei_index_array_full, 
  input       [ DATA_WIDTH            - 1 : 0 ]     column_out_serial,
  input       [ `IF_WIDTH    - 1 : 0 ]              flag_serial,
  input                                             finish_wei,
  input       [ WEI_INDEX_WIDTH * 3   - 1 : 0 ]     valid_row,
  input                                             row_cal_done,
  input       [ `ACT_INDEX_WIDTH     - 1 : 0 ]      valid_index,

  output      [ `ACT_INDEX_WIDTH       - 1 : 0 ]     wei_index,
  output reg     [ `ACT_INDEX_WIDTH       - 1 : 0 ]     row_val_num,//4 bit
  output  reg    [ DATA_WIDTH            - 1 : 0 ]     serial_out
);
  
   
   reg  [ 5       - 1 : 0 ]     row_valid_num_a;
   reg  [ WEI_INDEX_WIDTH       - 1 : 0 ]     j;
   reg  [ DATA_WIDTH * 3        - 1 : 0 ]     serial_array;
   reg  [ WEI_INDEX_WIDTH       - 1 : 0 ]     count_array;
   reg  [ `ACT_INDEX_WIDTH * `IF_WIDTH    - 1 : 0 ]     wei_index_array;
   reg                                        flag_serial_d;
   reg finish_wei_d, finish_wei_dd;
   reg [ DATA_WIDTH            - 1 : 0 ] column_out_serial_d;
   integer i;
  always @(posedge clk ) begin : proc_serial_out
    if(reset) begin
      serial_array <= 0;
      serial_out   <= 0;
      row_val_num  <= 0;
    end else if(mode == 1) begin 
      if( !finish_wei_dd && flag_serial_d) begin
        serial_array <= {column_out_serial, serial_array [ DATA_WIDTH * 3        - 1 : 8 ]}; //stream weight to serial
      end else if(finish_wei_dd) begin
        serial_out <= serial_array[ DATA_WIDTH* i +:DATA_WIDTH ]; //loop weight for a weight row
      end
    end else if (mode == 0) begin     
      column_out_serial_d <= column_out_serial;
      serial_out <= column_out_serial_d;//delay
    end
    row_val_num <= row_valid_num_a - 1; //delay1 clk
    flag_serial_d <= flag_serial;
    finish_wei_d <= finish_wei;
    finish_wei_dd <= finish_wei_d;
  end
  
  always @(posedge clk) begin : proc_wei_index_array //wei_index_array loop
    if(reset) begin
      j <= 0;
      count_array    <= 0;
      row_valid_num_a<= 0;
      wei_index_array<= 0;
    end else if ( (finish_wei || row_cal_done) && mode == 1 ) begin //
      row_valid_num_a <= valid_row[ j  +: 1 ];
      wei_index_array <= wei_index_array_full[ 2*count_array +: 2*3]; //row_wei loop
      count_array <= count_array + row_valid_num_a;
      if( j < row_valid_num_a << 1)
        j <= j + 2'd2;
      else
        j <= 2'd0;
    end else if ((finish_wei || row_cal_done) && mode == 0) begin
      row_valid_num_a <= valid_row;
      wei_index_array <= wei_index_array_full;
    end
  end
  
  always @(posedge clk ) begin : proc_i //loop
      if(reset) begin
        i <= 0;
      end else if (row_cal_done) // new row
        i <= 0;
      else if( i < row_val_num ) begin
        i <= i + 1;
      end else
        i <= 0;
    end
    // for mode1 wei_index[1:0] valid
  reg [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index_d;
  reg [ `ACT_INDEX_WIDTH     - 1 : 0 ] valid_index_dd;  
  always @(posedge clk ) begin : proc_valid_index_d
    if(reset) begin
      valid_index_d <= 0;
    end else begin
      valid_index_d <= valid_index;
      valid_index_dd <= valid_index_d; // 2 clk delay
    end
  end
  assign wei_index = (mode == 1)? wei_index_array[2*i +: 2] : valid_index_dd; //wei_index loop

endmodule