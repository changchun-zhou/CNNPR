library verilog;
use verilog.vl_types.all;
entity mem_controller is
    generic(
        IF_WIDTH        : integer := 34;
        DATA_WIDTH      : integer := 8;
        NUM_BLOCK       : integer := 16;
        CACHE_WIDTH     : integer := 162;
        BLOCK_WIDTH     : integer := 10
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        rst_n           : in     vl_logic;
        read_req02      : in     vl_logic;
        read_req13      : in     vl_logic;
        cache_out02     : out    vl_logic_vector;
        cache_out13     : out    vl_logic_vector;
        empty02         : out    vl_logic;
        empty13         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of NUM_BLOCK : constant is 1;
    attribute mti_svvh_generic_type of CACHE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of BLOCK_WIDTH : constant is 2;
end mem_controller;
