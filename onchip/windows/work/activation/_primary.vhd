library verilog;
use verilog.vl_types.all;
entity activation is
    generic(
        READ_REQ_ACT    : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        mode            : in     vl_logic;
        en              : in     vl_logic;
        start           : in     vl_logic;
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
        row_cal_done    : in     vl_logic;
        state           : in     vl_logic_vector(1 downto 0);
        row_index_count_3: in     vl_logic;
        zero_flag       : in     vl_logic;
        valid_act_index : out    vl_logic_vector(3 downto 0);
        serial_act      : out    vl_logic_vector(7 downto 0);
        parallel_act    : out    vl_logic_vector(127 downto 0);
        row_val_num_act_real: out    vl_logic_vector(4 downto 0);
        rd_req_act_flag_paulse_dd: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of READ_REQ_ACT : constant is 1;
end activation;
