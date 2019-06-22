library verilog;
use verilog.vl_types.all;
entity weight is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        start           : in     vl_logic;
        state           : in     vl_logic_vector(1 downto 0);
        row_cal_done    : in     vl_logic;
        wr_req_wei_flag : in     vl_logic;
        wr_data_wei_flag: in     vl_logic_vector(8 downto 0);
        wr_req_wei      : in     vl_logic;
        wr_data_wei     : in     vl_logic_vector(7 downto 0);
        wei_index       : out    vl_logic_vector(1 downto 0);
        row_val_num_wei_real: out    vl_logic_vector(1 downto 0);
        wei_serial_out  : out    vl_logic_vector(7 downto 0);
        wei_parallel_out: out    vl_logic_vector(71 downto 0);
        en              : out    vl_logic
    );
end weight;
