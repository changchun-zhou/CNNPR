library verilog;
use verilog.vl_types.all;
entity ram_flag is
    generic(
        DATA_WIDTH      : integer := 1;
        ADDR_WIDTH      : integer := 4;
        RAM_TYPE        : string  := "block";
        READ_FLAG_LENGTH: integer := 6
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        ram_mode        : in     vl_logic;
        s_write_req     : in     vl_logic;
        s_write_addr    : in     vl_logic_vector;
        s_write_data    : in     vl_logic_vector;
        s_read_req      : in     vl_logic;
        s_read_addr     : in     vl_logic_vector;
        s_read_data_p   : out    vl_logic;
        s_read_data_s   : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_TYPE : constant is 1;
    attribute mti_svvh_generic_type of READ_FLAG_LENGTH : constant is 1;
end ram_flag;
