module fifo_async_rd#(
  parameter   data_width = 16,
  parameter   addr_width = 8,
  parameter   data_depth = 1 << addr_width
                
) (
  input                           rst_n,
  input                           wr_clk,
  input                           wr_en,
  input      [data_width-1:0]     din,         
  input                           rd_clk,
  input                           rd_en,
  output reg                      valid,
  output reg [data_width-1:0]     dout,
  output                          empty,
  output                          full ,
  output reg                      full_level               
);
// wire full;
wire  full_ahead;
wire full_ahead1;
wire full_ahead2;
wire full_ahead3;
wire full_ahead4;
wire full_ahead5;
reg  full_ahead_d1;
reg  full_ahead_d2;
reg  full_ahead_d3;
reg  full_ahead_d4;
reg  full_ahead_d5;
reg full_ahead_d, full_ahead_dd;
wire full_ahead_paulse;


reg    [addr_width:0]    wr_addr_ptr;
reg    [addr_width:0]    rd_addr_ptr;
wire   [addr_width-1:0]  wr_addr;
wire   [addr_width-1:0]  rd_addr;

wire   [addr_width:0]    wr_addr_gray;
wire   [addr_width:0]    wr_addr_gray_ahead;
wire   [addr_width:0]    wr_addr_gray_ahead1;
wire   [addr_width:0]    wr_addr_gray_ahead2;
wire   [addr_width:0]    wr_addr_gray_ahead3;
wire   [addr_width:0]    wr_addr_gray_ahead4;
wire   [addr_width:0]    wr_addr_gray_ahead5;
reg    [addr_width:0]    wr_addr_gray_d1;
reg    [addr_width:0]    wr_addr_gray_d2;
wire   [addr_width:0]    rd_addr_gray;
reg    [addr_width:0]    rd_addr_gray_d1;
reg    [addr_width:0]    rd_addr_gray_d2;


reg [data_width-1:0] fifo_ram [data_depth-1:0];

//=========================================================write fifo 
always@(posedge wr_clk )
    begin
       if(wr_en && (~full))
          fifo_ram[wr_addr] <= din;
       else
          fifo_ram[wr_addr] <= fifo_ram[wr_addr];
    end   
  
   
//========================================================read_fifo
always@(posedge rd_clk or negedge rst_n)
   begin
      if(!rst_n)
         begin
            dout <= 'h0;
            valid <= 1'b0;
         end
      else if(rd_en && (~empty))
         begin
            dout <= fifo_ram[rd_addr];
            valid <= 1'b1;
         end
      else
         begin
            dout <=   'h0;
            valid <= 1'b0;
         end
   end
assign wr_addr = wr_addr_ptr[addr_width-1-:addr_width];
assign rd_addr = rd_addr_ptr[addr_width-1-:addr_width];
//===========================================================
always@(posedge wr_clk or negedge rst_n)
   begin
    if( !rst_n ) begin
      rd_addr_gray_d1 <= 0;
      rd_addr_gray_d2 <= 0;
    end else begin
      rd_addr_gray_d1 <= rd_addr_gray;
      rd_addr_gray_d2 <= rd_addr_gray_d1;
    end
   end
always@(posedge wr_clk or negedge rst_n)
   begin
      if(!rst_n)
         wr_addr_ptr <= 'h0;
      else if(wr_en && (~full))
         wr_addr_ptr <= wr_addr_ptr + 1;
      else 
         wr_addr_ptr <= wr_addr_ptr;
   end
//=========================================================rd_clk
always@(posedge rd_clk or negedge rst_n)
      begin
        if( !rst_n ) begin
          wr_addr_gray_d1 <= 0;
          wr_addr_gray_d2 <= 0;
        end else begin
         wr_addr_gray_d1 <= wr_addr_gray;
         wr_addr_gray_d2 <= wr_addr_gray_d1;
       end
      end
always@(posedge rd_clk or negedge rst_n)
   begin
      if(!rst_n)
         rd_addr_ptr <= 'h0;
      else if(rd_en && (~empty))
         rd_addr_ptr <= rd_addr_ptr + 1;
      else 
         rd_addr_ptr <= rd_addr_ptr;
   end

//========================================================== translation gary code
assign wr_addr_gray = (wr_addr_ptr >> 1) ^ wr_addr_ptr;
assign rd_addr_gray = (rd_addr_ptr >> 1) ^ rd_addr_ptr;

assign full = (wr_addr_gray == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ;
assign empty = ( rd_addr_gray == wr_addr_gray_d2 );

// =====================================================================

assign wr_addr_gray_ahead1 = ( (wr_addr_ptr + 8 ) >> 1) ^ (wr_addr_ptr + 8 ); //ahead 2 wr_clk
assign wr_addr_gray_ahead2 = ( (wr_addr_ptr + 7 ) >> 1) ^ (wr_addr_ptr + 7 ); //ahead 2 wr_clk
assign wr_addr_gray_ahead3 = ( (wr_addr_ptr + 6 ) >> 1) ^ (wr_addr_ptr + 6 ); //ahead 2 wr_clk
assign wr_addr_gray_ahead4 = ( (wr_addr_ptr + 5 ) >> 1) ^ (wr_addr_ptr + 5 ); //ahead 2 wr_clk
assign wr_addr_gray_ahead5 = ( (wr_addr_ptr + 4 ) >> 1) ^ (wr_addr_ptr + 4 ); //ahead 2 wr_clk

assign full_ahead1 = (wr_addr_gray_ahead1 == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ; //paulse
assign full_ahead2 = (wr_addr_gray_ahead2 == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ; //paulse
assign full_ahead3 = (wr_addr_gray_ahead3 == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ; //paulse
assign full_ahead4 = (wr_addr_gray_ahead4 == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ; //paulse
assign full_ahead5 = (wr_addr_gray_ahead5 == {~(rd_addr_gray_d2[addr_width-:2]),rd_addr_gray_d2[addr_width-2:0]}) ; //paulse

always @ ( posedge wr_clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      {full_ahead_d1, full_ahead_d2, full_ahead_d3, full_ahead_d4, full_ahead_d5}   <= 5'd0;
    end else begin
      {full_ahead_d1, full_ahead_d2, full_ahead_d3, full_ahead_d4, full_ahead_d5}   <= 
      {full_ahead1, full_ahead2, full_ahead3, full_ahead4, full_ahead5};
    end
end

always @ ( posedge wr_clk or negedge rst_n ) begin
    if ( !rst_n ) begin
      full_level   <= 1'd0;
    end else begin
      full_level   <= full_ahead_d1|| full_ahead_d2|| full_ahead_d3|| full_ahead_d4|| full_ahead_d5;
    end
end


assign full_ahead_paulse = full_ahead_d && ~full_ahead_dd; //posedge 由于延时，定会超过wr_addr_gray_ahead，定有paulse

// always @ ( posedge wr_clk or negedge rst_n ) begin
//     if ( !rst_n ) begin
//       full_level   <= 1'd0;
//     end else if( full_ahead_paulse )begin
//       full_level   <= ~full_level;
//     end
// end


endmodule
