library verilog;
use verilog.vl_types.all;
entity column is
    generic(
        DATA_WIDTH      : integer := 8;
        ADDR_WIDTH      : integer := 6;
        BLOCK_WIDTH     : integer := 10
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        rst_n           : in     vl_logic;
        flag            : in     vl_logic;
        column_out      : out    vl_logic_vector;
        j               : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of BLOCK_WIDTH : constant is 1;
end column;
