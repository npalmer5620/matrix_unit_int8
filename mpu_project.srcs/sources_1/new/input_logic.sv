`timescale 1ns / 1ps

module input_logic(
    input bit clk,
    input bit en,
    input bit rst,
    input logic unsigned [3:0] in_cnt,
    input logic signed [7:0] a [0:7][0:7],
    output logic signed [7:0] a_input_net [0:7]);
    
    // Input buffer ===> sytolic array logic
    always_ff @(posedge clk) begin
        // Reset by clearing input buffers
        if (~rst) begin
            // For every row in the array
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                a_input_net[i] <= 0;
            end
        end else if (en) begin
            // If the array is enabled, for every row in the array
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                // Only select valid rows: ie. do not select row 0 when counter is past value 7
                // This part is tricky: we are actually passing A transponse into the array 
                if ((in_cnt >= i) && (in_cnt <= (i+7))) begin
                    a_input_net[i] <= a[in_cnt-i][i];
                end else begin
                    // This could cause Problems!!! check this later: might need to be a_input_net[i] <= a_input_net[i];
                    a_input_net[i] <= 0;
                end
            end
        end else begin
            // if array is not enabled, persist states
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                a_input_net[i] <= 0;
            end
        end
    end
    
    
endmodule
