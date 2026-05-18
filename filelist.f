// 3. Low-Level / Infrastructure Blocks
./verilog/fifo_mux_2_1.v
./verilog/fifo_mux_8_1.v
./verilog/fifo_mux_16_1.v
./verilog/fifo_depth16.v
./verilog/ofifo.v
./verilog/sram_w16.v

// 4. Sub-Modules (Leaf cells)
./verilog/sync.v
./verilog/mac_8in.v
./verilog/mac_col.v
./verilog/mac_array.v
./verilog/sfp_row.v

// 5. Top-Level RTL
./verilog/core.v
./verilog/fullchip.v

// 6. Testbench (Always at the end)
./verilog/fullchip_tb.v