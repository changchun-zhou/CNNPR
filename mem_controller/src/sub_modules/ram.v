module ram //2 clk delay
#(
  parameter DATA_WIDTH    = 10,
  parameter ADDR_WIDTH    = 12,
  parameter RAM_TYPE      = "block",
  parameter IF_WIDTH  =   34
)
(
  input  wire                         clk,
  input  wire                         reset,

  input  wire                         rd_req,
  output reg  [ DATA_WIDTH  -1 : 0 ]  rd_data,

  input  wire                         wr_req,
  input  wire [ DATA_WIDTH  -1 : 0 ]  wr_data

);

  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : 1<<ADDR_WIDTH ];
  reg[ADDR_WIDTH-1:0] rd_addr;
  reg[ADDR_WIDTH-1:0] wr_addr;
  always @( posedge clk or negedge reset ) begin : proc_wr_addr
        if(~reset) begin
          wr_addr <= 0;
        end else if( wr_req )begin
          wr_addr <= wr_addr + 1;
        end
      end 
  always @(posedge clk or negedge reset ) begin : proc_rd_addr
       if(~reset) begin
         rd_addr <= 0;
       end else if ( rd_req ) begin
         rd_addr <= rd_addr + 1;
       end
     end   
  always @(posedge clk)
  begin: RAM_WRITE
    if (wr_req)
      mem[wr_addr] <= wr_data;
  end

  always @(posedge clk or negedge reset )
  begin: RAM_READ
    if (~reset)
      rd_data <= 0;
    else if (rd_req)
      rd_data <= mem[rd_addr];
  end
endmodule
