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

    wire [7:0] data_out;
    wire rx_busy;
    wire rx_done;


    // Baud Generator
    baud_generator baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );


    // UART Transmitter
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


    // UART Receiver
    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(tx),
        .data_out(data_out),
        .rx_busy(rx_busy),
        .rx_done(rx_done)
    );


    // 50 MHz Clock
    initial
    begin
        clk = 1'b0;

        forever
            #10 clk = ~clk;
    end


    // Reset
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

        #20;

        tx_start = 1'b0;

        // Wait for complete transmission
        #5000;

        if (data_out == 8'h55)
        begin
            $display("UART TEST PASSED");
            $display("Transmitted Data = %h", data_in);
            $display("Received Data    = %h", data_out);
        end
        else
        begin
            $display("UART TEST FAILED");
            $display("Transmitted Data = %h", data_in);
            $display("Received Data    = %h", data_out);
        end

        $stop;
    end

endmodule
