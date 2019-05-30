`timescale 1ns/1ps

module mem_controller_tb #(
	parameter CACHE_WIDTH = 162
	)();
	reg clk;
	reg clk_en;
	reg rst_n;
	reg	read_req02;
	reg	read_req13;
	wire [ CACHE_WIDTH	- 1 : 0 ]	cache_out02;
	wire [ CACHE_WIDTH	- 1 : 0 ]	cache_out13;
	wire empty02;
	wire empty13;

initial begin
	
	clk = 0;
	clk_en = 1;
	rst_n = 1;
	read_req02 = 0;
	read_req13 = 0;
	#10;
	rst_n = 0;
	#30 
	rst_n = 1;
end
initial begin
	$fsdbDumpfile("mem_controller_tb.fsdb");
	$fsdbdumpvars;
	$finish();
end
always 
	#10 clk = ~clk;

mem_controller mem_controller(
	.clk        (clk),
	.clk_en     (clk_en),
	.rst_n      (rst_n),
	.read_req02 (read_req02),
	.read_req13 (read_req13),
	.cache_out02(cache_out02),
	.cache_out13(cache_out13),
	.empty02    (empty02),
	.empty13    (empty13)
	);
endmodule