module ram_ifm //2 clk delay
#(
  parameter DATA_WIDTH    = 10,
  parameter  ADDR_WIDTH    = 12,
  parameter         RAM_TYPE      = "block",
  parameter IF_WIDTH  =   34
)
(
  input  wire                         clk,
  input  wire                         rst_n,

  input  wire                         s_read_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_read_addr,
  output reg  [ DATA_WIDTH  -1 : 0 ]  s_read_data,

  input  wire                         s_write_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_write_addr,
  input  wire [ DATA_WIDTH  -1 : 0 ]  s_write_data,
  input    wire                           initial_flag,
  input    wire                           initial_ifmap,
  input        [ 32 - 1 : 0 ]   column
);

  (* RAM_STYLE = RAM_TYPE *)
  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : 1<<ADDR_WIDTH ];
  reg[ADDR_WIDTH-1:0] rd_addr;
  reg[ADDR_WIDTH-1:0] wr_addr;
  reg[DATA_WIDTH-1:0] wr_data;

  reg rd_addr_v;
  reg wr_addr_v;
  reg [4:0]i;
  initial begin
      $readmemh("F:/Programdata/CNNPR/source/src/ifmapt1.dat", mem);
  end
  always @(posedge clk)
    if (~rst_n)
      rd_addr_v <= 1'b0;
    else
      rd_addr_v <= s_read_req;

  always @(posedge clk)
  begin
    if (~rst_n)
      rd_addr <= 0;
    else if (s_read_req)
      rd_addr <= s_read_addr;
  end

  always @(posedge clk)
  begin
    if (~rst_n)
    begin
      wr_addr <= 0;
    end
    else if (s_write_req)
    begin
      wr_addr <= s_write_addr;
    end
  end

  always @(posedge clk)
    if (~rst_n)
      wr_addr_v <= 1'b0;
    else
      wr_addr_v <= s_write_req;

  always @(posedge clk)
    if (~rst_n)
      wr_data <= 0;
    else if (s_write_req)
      wr_data <= s_write_data;


  always @(posedge clk)
  begin: RAM_WRITE
    if (wr_addr_v)
      mem[wr_addr] <= wr_data;
  end

  always @(posedge clk)
  begin: RAM_READ
    if (~rst_n)
      s_read_data <= 0;
    else if (rd_addr_v)
      s_read_data <= mem[rd_addr];
  end
endmodule
