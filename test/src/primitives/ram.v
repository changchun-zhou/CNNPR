module ram //2 clk delay
#(
  parameter DATA_WIDTH    = 10,
  parameter  ADDR_WIDTH    = 12,
  parameter         RAM_TYPE      = "block",
  parameter IF_WIDTH  =   34
)
(
  input  wire                         clk,
  input  wire                         reset,

  input  wire                         s_read_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_read_addr,
  output reg  [ DATA_WIDTH  -1 : 0 ]  s_read_data,

  input  wire                         s_write_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_write_addr,
  input  wire [ DATA_WIDTH  -1 : 0 ]  s_write_data

);

  (* RAM_STYLE = RAM_TYPE *)
  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : 1<<ADDR_WIDTH ];
  reg[ADDR_WIDTH-1:0] rd_addr;
  reg[ADDR_WIDTH-1:0] wr_addr;
  reg[DATA_WIDTH-1:0] wr_data;
  reg[ DATA_WIDTH  -1 : 0 ]  read_data_reg;

  reg rd_addr_v;
  reg wr_addr_v;
  reg [4:0]i;
      
  always @(posedge clk)
  begin: RAM_WRITE
    if (s_write_req)
      mem[s_write_addr] <= s_write_data;
  end

  always @(posedge clk)
  begin: RAM_READ
    if (reset)
      s_read_data <= 0;
    else if (s_read_req)
      s_read_data <= mem[s_read_addr];
    else 
      s_read_data <= s_read_data;
  end
endmodule
