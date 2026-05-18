`timescale 1ns/1ps
module tb_fifo;
    localparam int DEPTH = 4;
    localparam int WIDTH = 4;
    localparam int BW = 4;


    logic                        clk;
    logic                        reset;
    logic [WIDTH-1:0][BW-1:0]    data_in;
    logic                        wr_en;
    logic                        rd_en;
    logic [WIDTH-1:0][BW-1:0]    data_out;
    logic                        full;
    logic                        empty;

    // Clock generation (100MHz)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // DUT inst
    fifo #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH),
        .BW(BW)
    ) dut_fifo (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Reusable Driver Tasks
    task reset_dut();
        // <= in testbench task means assign at the same time 
        reset   <= 1'b1;
        wr_en   <= 1'b0;
        rd_en   <= 1'b0;
        data_in <= '0;
        // @(posedge clk) makes the testbench wait until the next posedge clk
        // if one wants the signal to wait for to be level sensitive use wait()
        @(posedge clk);
        // Adds a delay to simulate hold time
        #1; 
        // De-assert reset
        reset   <= 1'b0;
        $display("[TB] @%0t: Reset Complete.", $time);
        @(posedge clk);
    endtask

    task write_fifo(input logic [WIDTH-1:0][BW-1:0] vector);
        if (full) begin
            $display("[WARN] @%0t: Attempted write while FIFO is FULL!", $time);
        end
        wr_en   <= 1'b1;
        data_in <= vector;
        @(posedge clk);
        #1;
        wr_en   <= 1'b0;
    endtask

    task read_fifo();
        if (empty) begin
            $display("[WARN] @%0t: Attempted read while FIFO is EMPTY!", $time);
        end
        rd_en <= 1;
        @(posedge clk);
        #1;
        rd_en <= 1'b0;
    endtask

    // Main Generator Loop
    initial begin
        reset_dut();
        if (empty) $display("[SUCCESS] FIFO is correctly reporting EMPTY on reset."); 
        $display("[TB] Streaming data in...");
        write_fifo({8'h01, 8'h02, 8'h03, 8'h04}); // Lane 3 down to Lane 0
        write_fifo({8'h05, 8'h06, 8'h07, 8'h08});
        write_fifo({8'h09, 8'h0A, 8'h0B, 8'h0C});
        write_fifo({8'h0D, 8'h0E, 8'h0F, 8'h10}); // 4th item (Should make a Depth=4 FIFO Full)

        repeat(2) @(posedge clk);

        if (full) $display("[SUCCESS] FIFO correctly reached FULL status.");

        $display("[TB] Reading data out...");
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();

        #1;
        if (empty) $display("[SUCCESS] FIFO cleanly emptied back out.");

        // Finish simulation
        #20;
        $display("[TB] Unit test complete.");
        $finish;
    end

    always @(posedge clk) begin
        if (rd_en && !empty) begin
            $display("[MONITOR] @%0t: Read Data Out = [ Lane3: %h | Lane2: %h | Lane1: %h | Lane0: %h ]", 
                     $time, data_out[3], data_out[2], data_out[1], data_out[0]);
        end
    end
endmodule
