library verilog;
use verilog.vl_types.all;
entity delay is
    generic(
        DATA_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        delay_in        : in     vl_logic_vector;
        delay_num_clk   : in     vl_logic_vector(1 downto 0);
        delay_out       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end delay;
