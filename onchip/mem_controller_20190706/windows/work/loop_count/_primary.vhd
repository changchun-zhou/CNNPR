library verilog;
use verilog.vl_types.all;
entity loop_count is
    generic(
        DATA_WIDTH      : integer := 4
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        reset2          : in     vl_logic;
        count_condition : in     vl_logic;
        max             : in     vl_logic_vector;
        stride          : in     vl_logic_vector;
        count           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end loop_count;
