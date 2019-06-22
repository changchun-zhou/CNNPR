`include "def_params.vh" 
module weight
(
    input                                clk,
    input                                reset,
    input                                mode,
    input                                start,
    input [ 2 : 0 ]                      state,
    input                                row_cal_done,
    input                                wr_req_wei_flag,
    input [ `KERNEL_SIZE       - 1 : 0 ] wr_data_wei_flag,
    input                                wr_req_wei,
    input [ `DATA_WIDTH        - 1 : 0 ] wr_data_wei,
    output reg[ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_col_index,
    output[ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_row_index,
    output[ `WEI_INDEX_WIDTH   - 1 : 0 ] row_val_num_wei_real,
    output reg [ `DATA_WIDTH        - 1 : 0 ] wei_serial_out,
    output[ `DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_parallel_out,
    output reg                              en
    );

  wire rd_req_wei_flag;
  wire refresh_seq;
  wire [ `ACT_INDEX_WIDTH   - 1 : 0 ] i;
  wire [ `KERNEL_SIZE          - 1 : 0 ] rd_data_wei_flag;
  wire [ `KERNEL_SIZE          - 1 : 0 ] rd_data_wei_flag_dd;
  wire [ `DATA_WIDTH        - 1 : 0 ] rd_data_wei;
  wire [ `DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_array_full;
  wire [ `WEI_INDEX_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_index_array_full;
  wire [ `WEI_INDEX_WIDTH * 2            - 1 : 0 ] wei_index_row_col;
  wire [ `WEI_INDEX_WIDTH * 2            - 1 : 0 ] wei_row_col;
  wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] count_val_num;
  wire [ `WEI_INDEX_WIDTH * `KERNEL_WIDTH - 1 : 0 ] valid_num_index_array;

  assign rd_req_wei_flag = start;
  wire rd_req_wei_flag_d;
  wire rd_req_wei_flag_dd;

  assign refresh_seq = rd_req_wei_flag_d;

ram #(
    .DATA_WIDTH               ( `KERNEL_SIZE              ),
    .ADDR_WIDTH               ( `ACT_INDEX_WIDTH                    )
  ) ram_wei_flag (
    .clk                      ( clk                     ),  //input
    .reset                    ( reset                   ),  //input
    .wr_req                   ( wr_req_wei_flag         ),  //input
    .wr_data                  ( wr_data_wei_flag        ),  //input

    .rd_req                   ( rd_req_wei_flag         ),  //input
    .rd_data                  ( rd_data_wei_flag        )  //output
  );
column_parallel #(
    .DATA_WIDTH               ( `DATA_WIDTH      ),
    .ADDR_WIDTH               ( `ADDR_WIDTH      )
  ) column_parallel_wei (
    .clk                      ( clk             ),  //input
    .reset                    ( reset           ),  //input
    .mode                     ( mode            ),
    .wr_req_p                 ( wr_req_wei       ),  //input
    .wr_data_p                ( wr_data_wei      ),  //input
    .rd_en                    ( rd_data_wei_flag[ 8 - i ]             ),
    .rd_req_p                   ( rd_data_wei_flag[ 8 - i ]    ),  //input
    .rd_data_p                  ( rd_data_wei    )  //output
  );
loop_count 
loop_count_i(
  .clk           (clk),
  .reset         (reset),
  .reset2        ( 1'b0 ),
  .count_condition(refresh_seq || i != 0 ),//stop count
  .max           ( 4'd9 ),
  .stride        ( 4'd1),
  .count         (i)
  );
always @(posedge clk or negedge reset) begin : proc_en
  if(~reset) begin
    en <= 0;
  end else begin
    en <= i ==  9;
  end
end

seq2parallel #(
  .IN_WIDTH ( `DATA_WIDTH ),
  .OUT_WIDTH( `DATA_WIDTH * `KERNEL_SIZE )
  )
seq2parallel_wei_array_full(
  .clk(clk),
  .reset(reset),
  .mode(mode),
  .in_serial(rd_data_wei),
  .begin_serial_in( rd_req_wei_flag_dd ),
  .refresh_parallel_array( en ), // one refresh
  .parallel_array( wei_array_full )
  );
/////////////////////////// wei_index_array_full////////////////////////////////////////////////////////////
reg [ `WEI_INDEX_WIDTH * `KERNEL_WIDTH   - 1 : 0 ]  wei_index_array0, wei_index_array1, wei_index_array2;
//LUT wei_col_index
 always @(posedge clk or negedge reset) begin : proc_wei_index_array0
   if(~reset) begin
     wei_index_array0 <= 0;
   end else if( mode && en )
     case ( rd_data_wei_flag[ 8 : 6 ] )
      3'b000 : wei_index_array0 <= 6'b00_00_00;
      3'b001 : wei_index_array0 <= 6'b00_00_10;//index = 2
      3'b010 : wei_index_array0 <= 6'b00_00_01;//index = 1
      3'b011 : wei_index_array0 <= 6'b00_10_01;//
      3'b100 : wei_index_array0 <= 6'b00_00_00;
      3'b101 : wei_index_array0 <= 6'b00_10_00;
      3'b110 : wei_index_array0 <= 6'b00_01_00;
      3'b111 : wei_index_array0 <= 6'b10_01_00;
      default: wei_index_array0 <= 6'bz;
      endcase
 end
always @(posedge clk or negedge reset) begin : proc_wei_index_array1
   if(~reset) begin
     wei_index_array1 <= 0;
   end else if( mode && en )
     case ( rd_data_wei_flag[ 5 : 3 ] )
      3'b000 : wei_index_array1 <= 6'b00_00_00;
      3'b001 : wei_index_array1 <= 6'b00_00_10;//index = 2
      3'b010 : wei_index_array1 <= 6'b00_00_01;//index = 1
      3'b011 : wei_index_array1 <= 6'b00_10_01;//
      3'b100 : wei_index_array1 <= 6'b00_00_00;
      3'b101 : wei_index_array1 <= 6'b00_10_00;
      3'b110 : wei_index_array1 <= 6'b00_01_00;
      3'b111 : wei_index_array1 <= 6'b10_01_00;
      default: wei_index_array1 <= 6'bz;
      endcase
 end
always @(posedge clk or negedge reset) begin : proc_wei_index_array2
   if(~reset) begin
     wei_index_array2 <= 0;
   end else if( mode && en )
     case ( rd_data_wei_flag[ 2 : 0 ] )
      3'b000 : wei_index_array2 <= 6'b00_00_00;
      3'b001 : wei_index_array2 <= 6'b00_00_10;//index = 2
      3'b010 : wei_index_array2 <= 6'b00_00_01;//index = 1
      3'b011 : wei_index_array2 <= 6'b00_10_01;//
      3'b100 : wei_index_array2 <= 6'b00_00_00;
      3'b101 : wei_index_array2 <= 6'b00_10_00;
      3'b110 : wei_index_array2 <= 6'b00_01_00;
      3'b111 : wei_index_array2 <= 6'b10_01_00;
      default: wei_index_array2 <= 6'bz;
      endcase
 end 
 assign wei_index_array_full = { wei_index_array2, wei_index_array1, wei_index_array0 };

loop_count#(
  .DATA_WIDTH ( `WEI_INDEX_WIDTH )
  )
loop_count_wei_row_index(
  .clk           (clk),
  .reset         (reset),
  .reset2        ( !mode ),
  .count_condition( row_cal_done ),//0 1 2 
  .max           ( 2'd2 ),
  .stride        ( 2'd1 ),
  .count         ( wei_row_index )
  );
wire [ `WEI_INDEX_WIDTH     - 1 : 0 ] valid_num0, valid_num1, valid_num2;
assign valid_num0 = rd_data_wei_flag[8] + rd_data_wei_flag[7] + rd_data_wei_flag[6];
assign valid_num1 = rd_data_wei_flag[5] + rd_data_wei_flag[4] + rd_data_wei_flag[3];
assign valid_num2 = rd_data_wei_flag[2] + rd_data_wei_flag[1] + rd_data_wei_flag[0];
assign valid_num_index_array = { valid_num2, valid_num1, valid_num0 };
assign row_val_num_wei_real = valid_num_index_array[ wei_row_index *2 +:2];
loop_count#(
  .DATA_WIDTH( `WEI_INDEX_WIDTH )
  )
loop_count_count_val_num(
  .clk            (clk),
  .reset          ( reset ),
  .reset2         (en || row_cal_done || !mode),
  .count_condition( state != `PREP ),
  .max            ( row_val_num_wei_real - 1 ), //
  .stride         ( 2'd1 ),
  .count          ( count_val_num )
  );
 // wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_index_d;
  assign wei_index_row_col = { wei_row_index, count_val_num };
  always @( en or wei_index_row_col ) begin //
    case ( wei_index_row_col )
      4'b00_00 : wei_col_index = wei_index_array_full[ 1  : 0  ];
      4'b00_01 : wei_col_index = wei_index_array_full[ 3  : 2  ];
      4'b00_10 : wei_col_index = wei_index_array_full[ 5  : 4  ];
      4'b01_00 : wei_col_index = wei_index_array_full[ 7  : 6  ];
      4'b01_01 : wei_col_index = wei_index_array_full[ 9  : 8  ];
      4'b01_10 : wei_col_index = wei_index_array_full[ 11 : 10 ];
      4'b10_00 : wei_col_index = wei_index_array_full[ 13 : 12 ];
      4'b10_01 : wei_col_index = wei_index_array_full[ 15 : 14 ];
      4'b10_10 : wei_col_index = wei_index_array_full[ 17 : 16 ];
      default  : wei_col_index = 2'bzz;
    endcase // wei_index_row_col
  end

  assign wei_row_col = { wei_row_index, wei_col_index };
  always @(posedge clk or negedge reset) begin : proc_wei_serial_out
    if(~reset) begin
      wei_serial_out <= 0;
    end else if( mode )
      case ( wei_row_col )
        4'b00_00 : wei_serial_out <= wei_array_full [ 7  : 0  ];
        4'b00_01 : wei_serial_out <= wei_array_full [ 15 : 8  ];
        4'b00_10 : wei_serial_out <= wei_array_full [ 23 : 16 ];
        4'b01_00 : wei_serial_out <= wei_array_full [ 31 : 24 ];
        4'b01_01 : wei_serial_out <= wei_array_full [ 39 : 32 ];
        4'b01_10 : wei_serial_out <= wei_array_full [ 47 : 40 ];
        4'b10_00 : wei_serial_out <= wei_array_full [ 55 : 48 ];
        4'b10_01 : wei_serial_out <= wei_array_full [ 63 : 56 ];
        4'b10_10 : wei_serial_out <= wei_array_full [ 71 : 64 ];
        default  : wei_serial_out <= 8'bz;
      endcase
  end
  assign wei_parallel_out = wei_array_full;

  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_wei_flag_d(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_wei_flag),
    .delay_num_clk( 2'd1 ),
    .delay_out(rd_req_wei_flag_d)
    ); 
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_wei_flag_dd(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_wei_flag_d),
    .delay_num_clk( 2'd1 ),
    .delay_out(rd_req_wei_flag_dd)
    );
endmodule // weight
