library verilog;
use verilog.vl_types.all;
entity seq2index is
    generic(
        DATA_WIDTH      : integer := 16;
        INDEX_WIDTH     : integer := 4
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        refresh_seq     : in     vl_logic;
        seq             : in     vl_logic_vector;
        shift           : in     vl_logic;
        index           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of INDEX_WIDTH : constant is 1;
end seq2index;
