`timescale 1ns / 1ps

module uart_tb;

    // Testbench Signals
    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire baud_tick;
    wire tx;
    wire tx_busy;
    wire tx_done;

    // Baud Generator Instance
    baud_generator baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    // UART Transmitter Instance
    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
	);

    // 50 MHz Clock Generation
    initial
    begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
	    // Reset Generation
    initial
    begin
        rst = 1'b1;
        tx_start = 1'b0;
        data_in = 8'h00;

        #100;

        rst = 1'b0;
    end
	    // Test Stimulus
    initial
    begin
        #150;

		data_in = 8'h55;
		tx_start = 1'b1;

		#110000;

		tx_start = 1'b0;

        #120000;

        $stop;
    end

endmodule