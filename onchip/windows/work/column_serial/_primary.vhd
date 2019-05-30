library verilog;
use verilog.vl_types.all;
entity column_serial is
    generic(
        DATA_WIDTH      : integer := 8;
        ADDR_WIDTH      : integer := 6
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        wr_req_p        : in     vl_logic;
        wr_data_p       : in     vl_logic_vector;
        rd_req_p        : in     vl_logic;
        rd_data_p       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end column_serial;
