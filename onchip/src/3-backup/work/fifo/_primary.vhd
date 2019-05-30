library verilog;
use verilog.vl_types.all;
entity fifo is
    generic(
        DATA_WIDTH      : integer := 64;
        ADDR_WIDTH      : integer := 4;
        RAM_DEPTH       : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector;
        empty           : out    vl_logic;
        full            : out    vl_logic;
        fifo_count      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_DEPTH : constant is 3;
end fifo;
