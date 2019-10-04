library verilog;
use verilog.vl_types.all;
entity mem_controller is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        wr_req_act_flag : in     vl_logic;
        wr_data_act_flag: in     vl_logic_vector(15 downto 0);
        wr_req_act      : in     vl_logic;
        wr_data_act     : in     vl_logic_vector(23 downto 0);
        wr_req_wei_flag : in     vl_logic;
        wr_data_wei_flag: in     vl_logic_vector(8 downto 0);
        wr_req_wei      : in     vl_logic;
        wr_data_wei     : in     vl_logic_vector(7 downto 0);
        mode            : in     vl_logic;
        start           : in     vl_logic;
        en              : out    vl_logic;
        state           : out    vl_logic_vector(2 downto 0);
        parallel_out    : out    vl_logic_vector(71 downto 0);
        serial_out      : out    vl_logic_vector(7 downto 0);
        act_index       : out    vl_logic_vector(3 downto 0);
        wei_col_index   : out    vl_logic_vector(1 downto 0);
        wei_row_index   : out    vl_logic_vector(1 downto 0);
        row_index       : out    vl_logic_vector(3 downto 0);
        row_val_num     : out    vl_logic_vector(3 downto 0);
        zero_flag       : out    vl_logic;
        cnt             : in     vl_logic_vector(3 downto 0);
        wait_state      : in     vl_logic;
        row_finish_done_0: out    vl_logic;
        row_finish_done_1: in     vl_logic;
        row_cal_done    : out    vl_logic
    );
end mem_controller;
