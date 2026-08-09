`timescale 1ns / 1ps

module uart_top_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire tx_busy;
wire tx_done;

wire [7:0] data_out;
wire rx_busy;
wire rx_done;


// =========================
// UART TOP MODULE
// =========================

uart_top dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .data_out(data_out),
    .rx_busy(rx_busy),
    .rx_done(rx_done)
);


// =========================
// 50 MHz Clock
// =========================

initial
begin
    clk = 1'b0;

    forever
        #10 clk = ~clk;
end


// =========================
// Reset
// =========================

initial
begin
    rst = 1'b1;
    tx_start = 1'b0;
    data_in = 8'h00;

    #100;

    rst = 1'b0;
end


// =========================
// Test Stimulus
// =========================

initial
begin

    // Wait for reset
    #150;


    // =========================
    // Test 1
    // =========================

    data_in = 8'h55;

    @(posedge clk);
    tx_start = 1'b1;

    @(posedge clk);
    tx_start = 1'b0;

    wait (rx_done == 1'b1);

    #100;

    if (data_out == data_in)
        $display("TOP TEST 1 PASSED: TX = %h, RX = %h",
                 data_in, data_out);
    else
        $display("TOP TEST 1 FAILED: TX = %h, RX = %h",
                 data_in, data_out);


    // =========================
    // Test 2
    // =========================

    #100;

    data_in = 8'hA5;

    @(posedge clk);
    tx_start = 1'b1;

    @(posedge clk);
    tx_start = 1'b0;

    wait (rx_done == 1'b1);

    #100;

    if (data_out == data_in)
        $display("TOP TEST 2 PASSED: TX = %h, RX = %h",
                 data_in, data_out);
    else
        $display("TOP TEST 2 FAILED: TX = %h, RX = %h",
                 data_in, data_out);


    // =========================
    // Test 3
    // =========================

    #100;

    data_in = 8'h00;

    @(posedge clk);
    tx_start = 1'b1;

    @(posedge clk);
    tx_start = 1'b0;

    wait (rx_done == 1'b1);

    #100;

    if (data_out == data_in)
        $display("TOP TEST 3 PASSED: TX = %h, RX = %h",
                 data_in, data_out);
    else
        $display("TOP TEST 3 FAILED: TX = %h, RX = %h",
                 data_in, data_out);


    // =========================
    // Test 4
    // =========================

    #100;

    data_in = 8'hFF;

    @(posedge clk);
    tx_start = 1'b1;

    @(posedge clk);
    tx_start = 1'b0;

    wait (rx_done == 1'b1);

    #100;

    if (data_out == data_in)
        $display("TOP TEST 4 PASSED: TX = %h, RX = %h",
                 data_in, data_out);
    else
        $display("TOP TEST 4 FAILED: TX = %h, RX = %h",
                 data_in, data_out);


    // =========================
    // Test 5
    // =========================

    #100;

    data_in = 8'h3C;

    @(posedge clk);
    tx_start = 1'b1;

    @(posedge clk);
    tx_start = 1'b0;

    wait (rx_done == 1'b1);

    #100;

    if (data_out == data_in)
        $display("TOP TEST 5 PASSED: TX = %h, RX = %h",
                 data_in, data_out);
    else
        $display("TOP TEST 5 FAILED: TX = %h, RX = %h",
                 data_in, data_out);


    // =========================
    // Test Complete
    // =========================

    $display("--------------------------------");
    $display("UART TOP MODULE TEST COMPLETE");
    $display("--------------------------------");

    $stop;

end

endmodule