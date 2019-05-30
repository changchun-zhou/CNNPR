library verilog;
use verilog.vl_types.all;
entity ram is
    generic(
        DATA_WIDTH      : integer := 10;
        ADDR_WIDTH      : integer := 12;
        RAM_TYPE        : string  := "block";
        IF_WIDTH        : integer := 34
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        s_read_req      : in     vl_logic;
        s_read_addr     : in     vl_logic_vector;
        s_read_data     : out    vl_logic_vector;
        s_write_req     : in     vl_logic;
        s_write_addr    : in     vl_logic_vector;
        s_write_data    : in     vl_logic_vector;
        initial_flag    : in     vl_logic;
        initial_ifmap   : in     vl_logic;
        column          : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of RAM_TYPE : constant is 1;
    attribute mti_svvh_generic_type of IF_WIDTH : constant is 1;
end ram;
