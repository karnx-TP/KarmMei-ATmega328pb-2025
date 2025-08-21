library verilog;
use verilog.vl_types.all;
entity ser2par_tb is
    generic(
        CLK_PERIOD      : integer := 10;
        bitlen          : integer := 8;
        data8bit        : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_PERIOD : constant is 1;
    attribute mti_svvh_generic_type of bitlen : constant is 1;
    attribute mti_svvh_generic_type of data8bit : constant is 1;
end ser2par_tb;
