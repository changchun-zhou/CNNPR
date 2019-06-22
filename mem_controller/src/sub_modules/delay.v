module delay #(
  parameter DATA_WIDTH = 8
)
(
    input clk,
    input reset,
    input [ DATA_WIDTH    - 1 : 0 ] delay_in,
    input [ 1 : 0 ]                 delay_num_clk,
    output reg [ DATA_WIDTH    - 1 : 0 ] delay_out
    );
  reg [ DATA_WIDTH        - 1 : 0 ] delay_in_d;
  always @(posedge clk or negedge reset) begin : proc_delay_out
      if(~reset) begin
          delay_out <= 0;
          delay_in_d <= 0;
      end else if ( delay_num_clk == 1 ) begin
          delay_out <= delay_in;
      end else if ( delay_num_clk == 2 ) begin
          delay_in_d <= delay_in;
          delay_out  <= delay_in_d;
      end
  end

endmodule // delay