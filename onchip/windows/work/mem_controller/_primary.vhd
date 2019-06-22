library verilog;
use verilog.vl_types.all;
entity mem_controller is
    generic(
        READ_REQ_ACT_FLAG: vl_logic_vector(0 to 8) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        wr_req_act_flag : in     vl_logic;
        wr_data_act_flag: in     vl_logic_vector(15 downto 0);
        wr_req_act      : in     vl_logic_vector(15 downto 0);
        wr_data_act0    : in     vl_logic_vector(7 downto 0);
        wr_data_act1    : in     vl_logic_vector(7 downto 0);
        wr_data_act2    : in     vl_logic_vector(7 downto 0);
        wr_data_act3    : in     vl_logic_vector(7 downto 0);
        wr_data_act4    : in     vl_logic_vector(7 downto 0);
        wr_data_act5    : in     vl_logic_vector(7 downto 0);
        wr_data_act6    : in     vl_logic_vector(7 downto 0);
        wr_data_act7    : in     vl_logic_vector(7 downto 0);
        wr_data_act8    : in     vl_logic_vector(7 downto 0);
        wr_data_act9    : in     vl_logic_vector(7 downto 0);
        wr_data_act10   : in     vl_logic_vector(7 downto 0);
        wr_data_act11   : in     vl_logic_vector(7 downto 0);
        wr_data_act12   : in     vl_logic_vector(7 downto 0);
        wr_data_act13   : in     vl_logic_vector(7 downto 0);
        wr_data_act14   : in     vl_logic_vector(7 downto 0);
        wr_data_act15   : in     vl_logic_vector(7 downto 0);
        wr_req_wei_flag : in     vl_logic;
        wr_data_wei_flag: in     vl_logic_vector(8 downto 0);
        wr_req_wei      : in     vl_logic;
        wr_data_wei     : in     vl_logic_vector(7 downto 0);
        mode            : in     vl_logic;
        start           : in     vl_logic;
        en              : out    vl_logic;
        parallel_out    : out    vl_logic_vector(71 downto 0);
        serial_out      : out    vl_logic_vector(7 downto 0);
        act_index       : out    vl_logic_vector(3 downto 0);
        wei_index       : out    vl_logic_vector(1 downto 0);
        row_index       : out    vl_logic_vector(3 downto 0);
        row_val_num     : out    vl_logic_vector(3 downto 0);
        zero_flag       : out    vl_logic;
        cnt             : in     vl_logic_vector(3 downto 0);
        row_finish_done_0: in     vl_logic;
        row_finish_done_1: in     vl_logic;
        row_cal_done    : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of READ_REQ_ACT_FLAG : constant is 1;
end mem_controller;
