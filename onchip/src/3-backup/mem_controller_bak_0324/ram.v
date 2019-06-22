module ram //2 clk delay
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
  // initial  
  //     begin
  //     $readmemb("F:/Programdata/CNNPR/source/src/flagt1.dat", mem);
  //     end
      
  always @(posedge clk)
  begin: RAM_WRITE
    if (s_write_req)
      mem[s_write_addr] <= s_write_data;
  end

  always @(posedge clk or negedge rst_n)
  begin: RAM_READ
    if (~rst_n)
      s_read_data <= 0;
    else if (s_read_req)
      s_read_data <= mem[s_read_addr];
    else
      s_read_data <= s_read_data;
  end
endmodule
