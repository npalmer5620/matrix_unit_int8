`timescale 1ns / 1ps

module output_logic(
    input clk,
    input out_cnt_en,
    input logic unsigned [3:0] out_cnt,
    input logic signed [23:0] psum_pass_net[0:7][0:7],
    output logic signed [23:0] c [0:7][0:7]
    );
    
    // Array to Output buffer Logic
    always_ff @(posedge clk) begin
        if (out_cnt_en) begin
            for (integer unsigned j = 0; j < 8; j = j + 1) begin
                // If cell is included in array pass, assign the p sum to correpsonding C register 
                if ((out_cnt >= j) && (out_cnt <= (j+7))) begin
                    c[out_cnt-j][j] <= psum_pass_net[7][j];
                end else begin
                    // if cell not included, do not change value
                    for (integer unsigned i = 0; i < 8; i = i + 1) begin
                        c[i][j] <= c[i][j];
                    end
                end
            end
        end else begin
            // If array not enabled do not change values in C register
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                for (integer unsigned j = 0; j < 8; j = j + 1) begin
                    c[i][j] <= c[i][j];
                end
            end
        end
    end
    
endmodule
