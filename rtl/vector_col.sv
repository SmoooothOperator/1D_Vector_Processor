module vector_col #(parameter NUM_LANE, parameter BW = 4, parameter PSUM_BW = 2*bw + 1)(
    input clk, reset,
    input op,
    input [NUM_LANE-1:0][BW-1:0] data_in1,
    input [NUM_LANE-1:0][BW-1:0] data_in1,
    output [NUM_LANE-1:0][PSUM_BW-1:0] vector_out,
    output [PSUM_BW+2:0] reduction_out
);
    logic [NUM_LANE-1:0][PSUM_BW-1:0] pe_result;


    generate
        for (genvar i = 0; i < NUM_LANE; i++) begin : lane_gen
            pe #(.bw(BW)) pe_inst (
                .clk(clk),
                .reset(reset),
                .data_1(data_in1[i]),
                .data_2(data_in2[i]),
                    .result(pe_result[i])
            )
        end
    endgenerate

    always_comb begin
        // Can consider doing a pipeline for this
        if (op) begin
            reduction_out = (pe_results[0] + pe_results[1]) + 
                            (pe_results[2] + pe_results[3]) + 
                            (pe_results[4] + pe_results[5]) + 
                            (pe_results[6] + pe_results[7]);
        end
        else begin
            reduction_out = '0;
        end
    end

    assign vector_out = pe_result;

endmodule