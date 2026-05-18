module fifo #(parameter DEPTH = 8, parameter WIDTH = 4, parameter BW = 4, parameter PSUM_BW = 2*BW + 1) (
    input clk, reset,
    input [WIDTH*BW-1:0][BW-1:0] data_in,
    input wr_en,
    input rd_en,
    output [WIDTH*BW-1:0][BW-1:0] data_out,
    output full, empty
);

    localparam int ADDR_WIDTH = $clog2(DEPTH);
    localparam int PTR_WIDTH  = ADDR_WIDTH + 1;

    logic [PTR_WIDTH-1:0] wr_ptr;
    logic [PTR_WIDTH-1:0] rd_ptr;

    logic [WIDTH-1:0][BW-1:0] mem [0:DEPTH-1];

    assign full = (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) && 
                   (wr_ptr[ADDR_WIDTH]     != rd_ptr[ADDR_WIDTH]);
    assign empty = (wr_ptr == rd_ptr);

    // ADDR_WIDTH-1:0 means exclude the MSB -- ignores the extra bit we use for fifo full flag
    assign data_out = mem[rd_ptr[ADDR_WIDTH-1:0]];

    always_ff @(posedge clk) begin
        if (reset) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end
        else begin
            if (wr_en && !full) begin
                wr_ptr <= wr_ptr + 1'b1;
                // Write needs to be on clock edge since as required by storage elements
                // Comb logic will cause inferred latch since there will be no else, as else it needs to hold current value
                mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
            end

            // Advance read pointer if requested and not empty
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end
endmodule