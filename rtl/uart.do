# ==========================================
# UART IP CORE - CLEAN WAVEFORM
# ==========================================

# Create / map work library
vlib work
vmap work work

# Compile RTL files
vlog baud_generator.v
vlog uart_tx.v
vlog uart_rx.v
vlog uart_top.v
vlog uart_tb.v
vlog uart_top_tb.v

# Start simulation
vsim work.uart_top_tb

# Open Wave window
view wave

# Clear previous waves
delete wave *

# ==========================================
# UART CONTROL
# ==========================================

add wave -divider "UART CONTROL"
add wave sim:/uart_top_tb/clk
add wave sim:/uart_top_tb/rst
add wave sim:/uart_top_tb/tx_start

# ==========================================
# DATA
# ==========================================

add wave -divider "DATA"
add wave -radix hexadecimal sim:/uart_top_tb/data_in
add wave sim:/uart_top_tb/tx
add wave -radix hexadecimal sim:/uart_top_tb/data_out

# ==========================================
# TRANSMITTER
# ==========================================

add wave -divider "TRANSMITTER"
add wave sim:/uart_top_tb/tx_busy
add wave sim:/uart_top_tb/tx_done

# ==========================================
# RECEIVER
# ==========================================

add wave -divider "RECEIVER"
add wave sim:/uart_top_tb/rx_busy
add wave sim:/uart_top_tb/rx_done

# ==========================================
# RUN SIMULATION
# ==========================================

run -all

# Fit waveform to window
wave zoom full