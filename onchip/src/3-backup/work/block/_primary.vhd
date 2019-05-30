library verilog;
use verilog.vl_types.all;
entity \block\ is
    generic(
        DATA_WIDTH      : integer := 16;
        ADDR_WIDTH      : integer := 1
    );
    port(
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        rst_n           : in     vl_logic;
        new_if          : in     vl_logic;
        valid           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end \block\;
