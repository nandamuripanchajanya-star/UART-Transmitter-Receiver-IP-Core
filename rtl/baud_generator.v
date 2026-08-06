
`timescale 1ns / 1ps

module baud_generator (
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

    // 50 MHz Clock and 9600 Baud Rate
    parameter BAUD_DIV = 5208;

    // Counter to divide the clock
    reg [12:0] counter;

    // Baud Rate Generator
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            counter   <= 13'd0;
            baud_tick <= 1'b0;
        end
        else
        begin
            if (counter == BAUD_DIV - 1)
            begin
                counter   <= 13'd0;
                baud_tick <= 1'b1;
            end
            else
            begin
                counter   <= counter + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule