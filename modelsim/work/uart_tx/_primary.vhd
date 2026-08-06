library verilog;
use verilog.vl_types.all;
entity uart_tx is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        baud_tick       : in     vl_logic;
        tx_start        : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        tx              : out    vl_logic;
        tx_busy         : out    vl_logic;
        tx_done         : out    vl_logic
    );
end uart_tx;
