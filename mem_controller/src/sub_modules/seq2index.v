`include "def_params.vh" 
module seq2index #(
    parameter DATA_WIDTH = 16,
    parameter INDEX_WIDTH= 4
)
(
    input                           clk,
    input                           reset,
    input                           refresh_seq, //en||row_cal_done
    input  [ DATA_WIDTH - 1 : 0 ]   seq,
    output [INDEX_WIDTH - 1 : 0 ]   index
);
  reg [ DATA_WIDTH - 1 : 0 ] seq_reg;
  reg [ INDEX_WIDTH  - 1 : 0 ] index_reg;
  wire  [ INDEX_WIDTH  - 1 : 0 ] position_1;
  wire [ DATA_WIDTH  - 1 : 0 ] seq_reg_and;
  assign seq_reg_and = (~seq_reg + 1 ) & seq_reg ;
  assign position_1 = `C_LOG_2( seq_reg_and  );
  assign index = position_1 + index_reg;

  always @(posedge clk or negedge reset ) begin : proc_index_reg
    if(~reset  ) begin
      index_reg <= 0;
    end else if (refresh_seq) begin
      index_reg <= 0;
    end else if( seq_reg != 0 ) begin
      index_reg <= index + 1;
    end else if( seq_reg == 0 ) begin
      index_reg <= 0;
    end

  end
  
  always @(posedge clk or negedge reset  ) begin : proc_seq_reg
    if(~reset) begin
      seq_reg <= 0;
    end else if ( refresh_seq )  begin // one time for a row data
      seq_reg <= seq;
    end else
      seq_reg <= seq_reg >> ( position_1 + 1);//
  end

endmodule // seq2index
