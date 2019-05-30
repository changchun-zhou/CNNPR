library verilog;
use verilog.vl_types.all;
entity sparsity is
    generic(
        DATA_WIDTH      : integer := 16;
        ADDR_WIDTH      : integer := 4;
        WEI_INDEX_WIDTH : integer := 2
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        wr_req          : in     vl_logic;
        wr_data         : in     vl_logic_vector;
        rd_req          : in     vl_logic;
        row_cal_done    : in     vl_logic;
        start_dd        : in     vl_logic;
        rd_addr         : out    vl_logic_vector(3 downto 0);
        flag_serial     : out    vl_logic_vector(15 downto 0);
        flag_serial_reg : out    vl_logic_vector;
        finish_wei      : out    vl_logic;
        wei_index_array_full: out    vl_logic_vector(63 downto 0);
        valid_row       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 2;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of WEI_INDEX_WIDTH : constant is 1;
end sparsity;
