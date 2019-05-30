library verilog;
use verilog.vl_types.all;
entity mem_controller_tb is
    generic(
        DATA_WIDTH      : integer := 8;
        IF_WIDTH        : integer := 16;
        KERNEL_WIDTH    : integer := 3;
        IF_SIZE         : vl_notype;
        KERNEL_SIZE     : vl_notype;
        PARALLEL_WIDTH  : vl_notype;
        ACT_INDEX_WIDTH : vl_notype;
        WEI_INDEX_WIDTH : vl_notype;
        NUM_BLOCK       : vl_notype;
        BLOCK_ADDR_WIDTH: vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of KERNEL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IF_SIZE : constant is 3;
    attribute mti_svvh_generic_type of KERNEL_SIZE : constant is 3;
    attribute mti_svvh_generic_type of PARALLEL_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of ACT_INDEX_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of WEI_INDEX_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of NUM_BLOCK : constant is 3;
    attribute mti_svvh_generic_type of BLOCK_ADDR_WIDTH : constant is 3;
end mem_controller_tb;
