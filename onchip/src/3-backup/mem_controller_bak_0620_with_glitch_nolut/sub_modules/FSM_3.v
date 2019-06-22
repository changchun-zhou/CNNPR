module FSM_3 #(
    parameter PREP = 2'b00, 
    parameter WAIT = 2'b11,
    parameter COMP = 2'b01
)
(
    input clk,
    input reset,
    input condition0_1,
    input condition1_2,
    input condition2_1,
    output reg [ 1 : 0 ] state
    );

always @(posedge clk) begin : proc_state
    if(reset) begin
      state <= PREP;
    end else begin
      case (state)
        PREP: if ( condition0_1 )
                state <= WAIT;
        WAIT: if ( condition1_2 )
                state <= COMP;
        COMP: if ( condition2_1 )
                state <= WAIT;
        default: state <= PREP;
      endcase
    end
  end

endmodule // FSM_3