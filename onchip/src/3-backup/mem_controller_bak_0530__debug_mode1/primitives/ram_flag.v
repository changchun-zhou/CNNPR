// support 6 bit read
// 1 bit write
module ram_flag //1 clk delay
#(
  parameter DATA_WIDTH    = 1,
  parameter ADDR_WIDTH    = 4,
  parameter RAM_TYPE      = "block",
  parameter READ_FLAG_LENGTH   = 6
)
(
  input  wire                         clk,
  input                               reset,
  input                               ram_mode,
  input                               s_write_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_write_addr,
  input  wire [ DATA_WIDTH  -1 : 0 ]  s_write_data,

  input  wire                         s_read_req,
  input  wire [ ADDR_WIDTH  -1 : 0 ]  s_read_addr,
  output reg                          s_read_data_p,
  output reg[READ_FLAG_LENGTH -1 : 0] s_read_data_s
);

  (* RAM_STYLE = RAM_TYPE *)
  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : 1<<ADDR_WIDTH ];
     
  always @(posedge clk)
  begin: RAM_WRITE
    if (s_write_req)
      mem[s_write_addr] <= s_write_data;
  end

  always @(posedge clk) begin: RAM_READ
    if (reset) begin
      s_read_data_s <= 0;
      s_read_data_p <= 0;
    end else if (ram_mode == 1 ) begin
        if ( s_read_req)
          s_read_data_p <= mem[s_read_addr];
        else
          s_read_data_p <= 0;
    end else if (ram_mode == 0) begin
      if ( s_read_req ) begin
        s_read_data_s[0] <= mem[s_read_addr    ];
        s_read_data_s[1] <= mem[s_read_addr + 1];
        s_read_data_s[2] <= mem[s_read_addr + 2];
        s_read_data_s[3] <= mem[s_read_addr + 3];
        s_read_data_s[4] <= mem[s_read_addr + 4];
        s_read_data_s[5] <= mem[s_read_addr + 5];
      end else begin
        s_read_data_s[0] <= 0;
        s_read_data_s[1] <= 0;
        s_read_data_s[2] <= 0;
        s_read_data_s[3] <= 0;
        s_read_data_s[4] <= 0;
        s_read_data_s[5] <= 0;
      end
    end       
  end
endmodule
