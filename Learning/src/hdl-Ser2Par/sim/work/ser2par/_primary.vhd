library verilog;
use verilog.vl_types.all;
entity ser2par is
    generic(
        bitlen          : integer := 8
    );
    port(
        RstB            : in     vl_logic;
        Clk             : in     vl_logic;
        SerDataIn       : in     vl_logic;
        SerDataEn       : in     vl_logic;
        ParDataOut      : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bitlen : constant is 1;
end ser2par;
