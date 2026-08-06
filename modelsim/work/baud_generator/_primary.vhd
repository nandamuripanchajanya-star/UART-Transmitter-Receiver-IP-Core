library verilog;
use verilog.vl_types.all;
entity baud_generator is
    generic(
        BAUD_DIV        : integer := 5208
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        baud_tick       : out    vl_logic
    );
end baud_generator;
