`timescale 1ns / 1ps

module uart_tx
(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire tx_start,
    input wire [7:0] data_in,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] tx_data;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 1'b0;
        tx_done <= 1'b0;
        bit_index <= 3'd0;
        tx_data <= 8'd0;
    end

    else
    begin

        tx_done <= 1'b0;

        case(state)

        //--------------------------------------------------
        IDLE:
        //--------------------------------------------------
        begin

            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                tx_data <= data_in;
                bit_index <= 3'd0;
                tx_busy <= 1'b1;
                state <= START;
            end

        end

		//---------------- START ----------------
		START:
        begin

            if(baud_tick)
            begin
                tx <= 1'b0;
                state <= DATA;
            end

        end

		//---------------- DATA ----------------
		DATA:
        begin

            if(baud_tick)
            begin

                tx <= tx_data[0];

                tx_data <= {1'b0,tx_data[7:1]};

                if(bit_index==3'd7)
                begin
                    state <= STOP;
                end
                else
                begin
                    bit_index <= bit_index + 1'b1;
                end

            end

        end

		//---------------- STOP ----------------
		STOP:
        begin

            if(baud_tick)
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b1;
                state <= IDLE;
            end

        end

        endcase

    end

end

endmodule