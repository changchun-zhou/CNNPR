module loop_count #(
  parameter DATA_WIDTH = 4
)
(
    input  clk,
    input  reset,
    input  count_condition,
    input  [ DATA_WIDTH   - 1 : 0 ] max,
    input  [ DATA_WIDTH   - 1 : 0 ] stride,
    output reg [ DATA_WIDTH   - 1 : 0 ] count 
    );
  always @(posedge clk ) begin : proc_count
      if(reset) begin
          count <= 0;
      end else if( count_condition )
        if (count < max )begin
            count <= count + stride;
        end else
            count <= 0;
  end

endmodule // loop_count