library verilog;
use verilog.vl_types.all;
entity mem_controller_tb is
    generic(
        PERIOD          : integer := 5;
        NUM             : integer := 3
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PERIOD : constant is 1;
    attribute mti_svvh_generic_type of NUM : constant is 1;
end mem_controller_tb;
