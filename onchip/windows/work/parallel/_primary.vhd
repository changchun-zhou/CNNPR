library verilog;
use verilog.vl_types.all;
entity parallel is
    generic(
        PARALLEL_WIDTH  : integer := 72;
        SHIFT_WIDTH     : integer := 24;
        WEI_INDEX_WIDTH : integer := 2
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        en              : in     vl_logic;
        parallel_in     : in     vl_logic_vector;
        wei_index       : in     vl_logic_vector(3 downto 0);
        read_req_pflag  : in     vl_logic;
        row_cal_done    : in     vl_logic;
        flag_reused     : in     vl_logic;
        state           : in     vl_logic_vector(1 downto 0);
        flag_stream_act_1: in     vl_logic;
        row_index_count_3: in     vl_logic;
        start_dd        : in     vl_logic;
        flag_state_parallel_d: in     vl_logic;
        parallel_out    : out    vl_logic_vector;
        act_index_reg   : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PARALLEL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SHIFT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of WEI_INDEX_WIDTH : constant is 1;
end parallel;
