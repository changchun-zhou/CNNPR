library verilog;
use verilog.vl_types.all;
entity seq2parallel is
    generic(
        IN_WIDTH        : integer := 128;
        OUT_WIDTH       : integer := 384;
        NUM             : vl_notype
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        in_serial       : in     vl_logic_vector;
        begin_serial_in : in     vl_logic;
        refresh_parallel_array: in     vl_logic;
        parallel_array  : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IN_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of NUM : constant is 3;
end seq2parallel;
