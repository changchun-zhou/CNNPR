module weight #(
)
(
    input                                clk,
    input                                reset,
    input                                mode,
    input                                start,
    input                                wr_req_wei_flag,
    input [ `KERNEL_SIZE       - 1 : 0 ] wr_data_wei_flag,
    input                                wr_req_wei,
    input [ `DATA_WIDTH        - 1 : 0 ] wr_data_wei,
    output[ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_index,
    output[ `WEI_INDEX_WIDTH   - 1 : 0 ] row_val_num_wei_real,
    output[ `DATA_WIDTH        - 1 : 0 ] wei_serial_out,
    output[ `DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_parallel_out
    );

  reg rd_req_wei_flag;
  wire refresh_seq;
  wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] i;
  wire [ `IF_WIDTH          - 1 : 0 ] rd_data_wei_flag;
  wire [ `IF_WIDTH          - 1 : 0 ] rd_data_wei_flag_dd;
  wire [ `DATA_WIDTH        - 1 : 0 ] rd_data_wei;
  wire [ `DATA_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_array_full;
  wire [ `DATA_WIDTH * `KERNEL_WIDTH - 1 : 0 ]wei_array;
  reg [ `WEI_INDEX_WIDTH * `KERNEL_SIZE - 1 : 0 ] wei_index_array_full;
  wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_row_index;
  wire [ `WEI_INDEX_WIDTH   - 1 : 0 ] wei_col_index;
  wire [ `WEI_INDEX_WIDTH * `KERNEL_WIDTH - 1 : 0 ] valid_num_index_array;
  wire [ `WEI_INDEX_WIDTH * `KERNEL_WIDTH - 1 : 0 ] wei_index_array;
  always @(posedge clk ) begin : proc_rd_req_wei_flag
    if(reset) begin
      rd_req_wei_flag <= 0;
    end else begin
      rd_req_wei_flag <= start;
    end
  end

  wire rd_req_wei_flag_d;
  delay #(
    .DATA_WIDTH( 1 )
    )
  delay_rd_req_wei_flag_d(
    .clk(clk),
    .reset(reset),
    .delay_in(rd_req_wei_flag),
    .stride( 1 ),
    .delay_num_clk( 1 ),
    .delay_out(rd_req_wei_flag_d)
    ); 
  assign refresh_seq = rd_req_wei_flag_d;

// seq2index #(
//     )
// seq2index_wei(
//     .clk(clk),
//     .reset(reset),
//     .refresh_seq(refresh_seq),
//     .seq        (rd_data_wei_flag),
//     .index      (valid_wei_index)
//     );

ram #(
    .DATA_WIDTH               ( `IF_WIDTH              ),
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
    .wr_req                   ( wr_req_wei       ),  //input
    .wr_data                  ( wr_data_wei      ),  //input

    .rd_req                   ( rd_data_wei_flag[i]    ),  //input
    .rd_data                  ( rd_data_wei    )  //output
  );
loop_count #(
  )
loop_count_i(
  .clk           (clk),
  .reset         (reset),
  .count_conditon(refresh_seq),//stop count
  .max           ( `KERNEL_SIZE ),
  .stride        (1),
  .count         (i)
  );
wire rd_req_wei_flag_dd;
seq2parllel #(
  .IN_WIDTH ( `DATA_WIDTH ),
  .OUT_WIDTH( `DATA_WIDTH * `KERNEL_SIZE )
  )
seq2parllel_wei_array_full(
  .clk(clk),
  .reset(reset),
  .mode(mode),
  .in_serial(rd_data_wei),
  .begin_serial_in( rd_req_wei_flag_dd ),
  .refresh_parallel_array( ),
  .parallel_array( wei_array_full )
  );
always @(posedge clk ) begin : proc_wei_index_array_full
  if(reset) begin
    wei_index_array_full <= 0;
  end else begin
    wei_index_array_full[ `WEI_INDEX_WIDTH * i +: `WEI_INDEX_WIDTH ] <= ( rd_data_wei_flag[i]) ? i : 0 ;
  end
end

// seq2parllel #(
//   )
// seq2parllel_wei_index_full(
//   .clk(clk),
//   .reset(reset),
//   .mode(mode),
//   .in_serial( valid_wei_index ),
//   .begin_serial_in( refresh_seq ),
//   .refresh_parallel_array( ),
//   .parallel_array( wei_index_array_full )
//   );
loop_count#(
  .DATA_WIDTH ( `WEI_INDEX_WIDTH )
  )
loop_count_wei_row_index(
  .clk           (clk),
  .reset         (reset),
  .count_conditon( 00 ),
  .max           ( `KERNEL_WIDTH ),
  .stride        ( 1 ),
  .count         ( wei_row_index )
  );
assign valid_num_index_array = { rd_data_wei_flag[8] + rd_data_wei_flag[7] + rd_data_wei_flag[6],
                                 rd_data_wei_flag[5] + rd_data_wei_flag[4] + rd_data_wei_flag[3],
                                 rd_data_wei_flag[2] + rd_data_wei_flag[1] + rd_data_wei_flag[0]};
assign row_val_num_wei_real = valid_num_index_array[ wei_row_index << 1 +:2];
assign wei_index_array = wei_index_array_full[6*wei_row_index +:6];
assign wei_array       = wei_array_full [ `DATA_WIDTH*`KERNEL_WIDTH * wei_row_index +: `DATA_WIDTH*`KERNEL_WIDTH ];
loop_count#(
  .DATA_WIDTH( `WEI_INDEX_WIDTH )
  )
loop_count_wei_col_index(
  .clk           (clk),
  .reset         (reset),
  .count_conditon( 00000000000000 ),
  .max           ( row_val_num_wei_real ),
  .stride        ( 1 ),
  .count         ( wei_col_index )
  );

assign wei_index = wei_index_array[ wei_col_index << 1 +:2];
assign wei_serial_out = wei_array[ `DATA_WIDTH *wei_col_index +: `DATA_WIDTH];

assign wei_parallel_out = wei_array_full;
endmodule // weight