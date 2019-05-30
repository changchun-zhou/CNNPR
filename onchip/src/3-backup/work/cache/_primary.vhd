library verilog;
use verilog.vl_types.all;
entity cache is
    generic(
        CACHE_WIDTH     : integer := 162;
        ADDR_WIDTH      : integer := 6
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in         : in     vl_logic_vector;
        read_req        : in     vl_logic;
        data_out        : out    vl_logic_vector;
        empty           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CACHE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end cache;
