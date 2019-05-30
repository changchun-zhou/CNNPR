library verilog;
use verilog.vl_types.all;
entity serial is
    generic(
        DATA_WIDTH      : integer := 8;
        WEI_INDEX_WIDTH : integer := 2
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        wei_index_array_full: in     vl_logic_vector(63 downto 0);
        column_out_serial: in     vl_logic_vector;
        flag_serial     : in     vl_logic_vector(15 downto 0);
        finish_wei      : in     vl_logic;
        valid_row       : in     vl_logic_vector;
        row_cal_done    : in     vl_logic;
        valid_index     : in     vl_logic_vector(3 downto 0);
        wei_index       : out    vl_logic_vector(3 downto 0);
        row_val_num     : out    vl_logic_vector(3 downto 0);
        serial_out      : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of WEI_INDEX_WIDTH : constant is 1;
end serial;
