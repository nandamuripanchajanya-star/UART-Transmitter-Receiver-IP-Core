`timescale 1ns / 1ps

module uart_top (
    input  wire       clk,
    input  wire       rst,

    // Transmitter interface
    input  wire       tx_start,
    input  wire [7:0] data_in,

    // UART serial line
    output wire       tx,

    // Transmitter status
    output wire       tx_busy,
    output wire       tx_done,

    // Receiver interface
    output wire [7:0] data_out,

    // Receiver status
    output wire       rx_busy,
    output wire       rx_done
);


// Baud tick
wire baud_tick;


// =========================
// Baud Generator
// =========================

baud_generator baud_gen (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);


// =========================
// UART Transmitter
// =========================

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


// =========================
// UART Receiver
// =========================

uart_rx receiver (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(tx),
    .data_out(data_out),
    .rx_busy(rx_busy),
    .rx_done(rx_done)
);


endmodule
