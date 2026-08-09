`timescale 1ns / 1ps

module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       rx,

    output reg [7:0]  data_out,
    output reg        rx_busy,
    output reg        rx_done
);

parameter IDLE  = 3'd0;
parameter START = 3'd1;
parameter DATA  = 3'd2;
parameter STOP  = 3'd3;

parameter BAUD_DIV = 16;

reg [2:0] state;
reg [2:0] bit_count;
reg [7:0] data_reg;
reg [12:0] sample_count;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state        <= IDLE;
        bit_count    <= 3'd0;
        data_reg     <= 8'd0;
        data_out     <= 8'd0;
        rx_busy      <= 1'b0;
        rx_done      <= 1'b0;
        sample_count <= 13'd0;
    end
    else
    begin
        rx_done <= 1'b0;

        case (state)

            IDLE:
            begin
                rx_busy      <= 1'b0;
                sample_count <= 13'd0;

                if (rx == 1'b0)
                begin
                    state        <= START;
                    rx_busy      <= 1'b1;
                    sample_count <= 13'd0;
                end
            end

            START:
            begin
                if (sample_count == (BAUD_DIV/2 - 1))
                begin
                    sample_count <= 13'd0;

                    if (rx == 1'b0)
                    begin
                        state     <= DATA;
                        bit_count <= 3'd0;
                    end
                    else
                    begin
                        state   <= IDLE;
                        rx_busy <= 1'b0;
                    end
                end
                else
                begin
                    sample_count <= sample_count + 1'b1;
                end
            end

            DATA:
            begin
                if (sample_count == BAUD_DIV - 1)
                begin
                    sample_count <= 13'd0;

                    data_reg[bit_count] <= rx;

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
                    sample_count <= sample_count + 1'b1;
                end
            end

            STOP:
            begin
                if (sample_count == BAUD_DIV - 1)
                begin
                    sample_count <= 13'd0;

                    if (rx == 1'b1)
                    begin
                        data_out <= data_reg;
                        rx_done  <= 1'b1;
                    end

                    state   <= IDLE;
                    rx_busy <= 1'b0;
                end
                else
                begin
                    sample_count <= sample_count + 1'b1;
                end
            end

            default:
            begin
                state        <= IDLE;
                bit_count    <= 3'd0;
                rx_busy      <= 1'b0;
                sample_count <= 13'd0;
            end

        endcase
    end
end

endmodule