`timescale 1ns/1ps

`define C_LOG_2(n) ( (n) <= (1<<0) ? 0 : (n) <= (1<<1) ? 1 :(n) <= (1<<2) ? 2 : (n) <= (1<<3) ? 3 :(n) <= (1<<4) ? 4 : (n) <= (1<<5) ? 5 :(n) <= (1<<6) ? 6 : (n) <= (1<<7) ? 7 :(n) <= (1<<8) ? 8 : (n) <= (1<<9) ? 9 :(n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :(n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :(n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 : 16 )
`define PREP  3'b000
`define TRAN  3'b010
`define COMP  3'b011
`define WAIT  3'b111
`define ERRO  3'bzzz

`define DATA_WIDTH  8
`define IF_WIDTH  16
`define KERNEL_WIDTH 3

`define IF_SIZE  256
`define KERNEL_SIZE  9
`define ACT_INDEX_WIDTH 4 // mode0 mode1
`define WEI_INDEX_WIDTH 2//2 only for mode1
`define ADDR_WIDTH 4
`define PARALLEL_WIDTH 72
`define FM_WIDTH 6
`define FM_DATA_WIDTH 24