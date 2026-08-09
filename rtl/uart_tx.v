`timescale 1ns / 1ps

module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] data_in,

    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

parameter IDLE  = 3'd0;
parameter START = 3'd1;
parameter DATA  = 3'd2;
parameter STOP  = 3'd3;

parameter BAUD_DIV = 16;

reg [2:0] state;
reg [2:0] bit_count;
reg [7:0] data_reg;
reg [12:0] bit_count_clk;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state        <= IDLE;
        bit_count    <= 3'd0;
        data_reg     <= 8'd0;
        bit_count_clk <= 13'd0;
        tx           <= 1'b1;
        tx_busy      <= 1'b0;
        tx_done      <= 1'b0;
    end
    else
    begin
        tx_done <= 1'b0;

        case (state)

            IDLE:
            begin
                tx            <= 1'b1;
                tx_busy       <= 1'b0;
                bit_count_clk <= 13'd0;

                if (tx_start)
                begin
                    data_reg      <= data_in;
                    bit_count     <= 3'd0;
                    tx_busy       <= 1'b1;
                    tx             <= 1'b0;
                    state         <= START;
                    bit_count_clk <= 13'd0;
                end
            end

            START:
            begin
                tx <= 1'b0;

                if (bit_count_clk == BAUD_DIV - 1)
                begin
                    bit_count_clk <= 13'd0;
                    state <= DATA;
                end
                else
                begin
                    bit_count_clk <= bit_count_clk + 1'b1;
                end
            end

            DATA:
            begin
                tx <= data_reg[bit_count];

                if (bit_count_clk == BAUD_DIV - 1)
                begin
                    bit_count_clk <= 13'd0;

                    if (bit_count == 3'd7)
                    begin
                        state <= STOP;
                    end
                    else
                    begin
                        bit_count <= bit_count + 1'b1;
                    end
                end
                else
                begin
                    bit_count_clk <= bit_count_clk + 1'b1;
                end
            end

            STOP:
            begin
                tx <= 1'b1;

                if (bit_count_clk == BAUD_DIV - 1)
                begin
                    bit_count_clk <= 13'd0;
                    state   <= IDLE;
                    tx_busy <= 1'b0;
                    tx_done <= 1'b1;
                end
                else
                begin
                    bit_count_clk <= bit_count_clk + 1'b1;
                end
            end

            default:
            begin
                state         <= IDLE;
                bit_count     <= 3'd0;
                bit_count_clk <= 13'd0;
                tx            <= 1'b1;
                tx_busy       <= 1'b0;
                tx_done       <= 1'b0;
            end

        endcase
    end
end

endmodule