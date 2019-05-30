library verilog;
use verilog.vl_types.all;
entity sparsity is
    generic(
        DATA_WIDTH      : integer := 1;
        ADDR_WIDTH      : integer := 6;
        BLOCK_WIDTH     : integer := 10;
        NUM_BLOCK       : integer := 16;
        IF_WIDTH        : integer := 34
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        rst_n           : in     vl_logic;
        read_req        : in     vl_logic;
        valid           : in     vl_logic_vector;
        j               : in     vl_logic_vector(31 downto 0);
        flag            : out    vl_logic;
        jump            : out    vl_logic_vector(1 downto 0);
        finish_block    : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of BLOCK_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of NUM_BLOCK : constant is 1;
    attribute mti_svvh_generic_type of IF_WIDTH : constant is 1;
end sparsity;
