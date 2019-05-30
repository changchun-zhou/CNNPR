`timescale 1ns/1ps

module mfpga(
	input												clk     ,
	input												reset,
	input											    m_rd_req_sw,

	input                                               s_ready ,
	output                                              m_clk   ,
	output                                              m_wr_req,
	output                                              m_rd_req, 	
	inout                                               data_ov ,
	inout        [ 31                     : 0 ]         data_out
  );
 	(*mark_debug = "true"*) wire   						clk     ;
 	(*mark_debug = "true"*) wire 						reset	;
 	(*mark_debug = "true"*) wire 						m_rd_req;
 	(*mark_debug = "true"*) wire                        s_ready ;
 	(*mark_debug = "true"*) wire                        m_clk   ;
 	(*mark_debug = "true"*) wire                        m_wr_req;
 	(*mark_debug = "true"*) wire                        m_rd_req;
 	(*mark_debug = "true"*) wire                        data_ov ;
 	(*mark_debug = "true"*) wire [ 31      : 0 ]  		data_out;


  wire													push;
  wire													full;

  assign m_clk = clk;
  assign m_rd_req = m_rd_req_sw; 
  assign push = data_ov & s_ready;

  fifo#(
    .DATA_WIDTH               ( 32          ),
    .ADDR_WIDTH               ( 10          )
  ) axi_rd_buffer (
    .clk                      ( clk         ),  //input
    .reset                    ( reset       ),  //input
    .push                     ( push       	),  //input RVALID
    .full                     ( full       	),  //output
    .data_in                  ( data_out    ),  //input M_AXI_RDATA
    .pop                      ( 1        	),  //input  
    .empty                    (       		),  //output
    .data_out                 (    			),  //output
    .fifo_count               (             )   //output
  );

endmodule