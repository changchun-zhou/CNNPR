library verilog;
use verilog.vl_types.all;
entity FSM_3 is
    generic(
        PREP            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        \WAIT\          : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        COMP            : vl_logic_vector(0 to 1) := (Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        condition0_1    : in     vl_logic;
        condition1_2    : in     vl_logic;
        condition2_1    : in     vl_logic;
        state           : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PREP : constant is 1;
    attribute mti_svvh_generic_type of \WAIT\ : constant is 1;
    attribute mti_svvh_generic_type of COMP : constant is 1;
end FSM_3;
