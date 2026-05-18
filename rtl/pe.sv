module pe #(parameter bw = 4, parameter psum_bw = 2*bw + 1)(
    input clk, reset,
    input [bw-1:0] data_1,
    input [bw-1:0] data_2,
    output [psum_bw-1:0] result
);

    logic [bw-1:0] data_1q;
    logic [bw-1:0] data_2q;

    // Register the input before multiplication
    // this allows for easier timing constraints for the SRAM/FIFO
    always_ff @(posedge clk) begin
        if (reset)begin
            data_1q <= 0;
            data_2q <= 0;
        end
        else begin
            data_1q <= data_1;
            data_2q <= data_2;
        end
    end

    assign result = data_1q * data_2q;

endmodule