`include "def_params.vh"
module FSM_3
(
    input clk,
    input reset,
    input condition0_1,
    input condition1_2,
    input condition2_1,
    output reg [ 2 : 0 ] state
    );

always @(posedge clk or negedge reset) begin : proc_state
    if(~reset) begin
      state <= `PREP;
    end else begin
      case (state)
        `PREP: if ( condition0_1 )
                state <= `TRAN;
        `TRAN: if ( condition1_2 )
                state <= `COMP;
        `COMP: if ( condition2_1 )
                state <= `TRAN;
        default: state <= `PREP;
      endcase
    end
  end

endmodule // FSM_3