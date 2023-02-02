// Nicholas Palmer 825059580
// Up Counter for array timing
`timescale 1ns / 1ps

module counter4 (
    input clk,
    input rst,
    input en, // timer enable
    input logic unsigned [3:0] end_state, // The state before we wrap back to the initial state
    output logic unsigned [3:0] cnt // current state
);
    always_ff @(posedge clk) begin
        // On Reset low, set the next state to 0
        if (~rst) begin
            cnt <= 0;
        end else begin
            if (en) begin
                // If we are not at the last state, go to next state
                if (cnt != end_state) begin
                    // Go to next state if we are not at last state
                    cnt <= cnt + 1;
                end else begin
                    // If the counter reaches the last state, wrap
                    cnt <= 0;
                end
            end else begin
                // If the counter is not enabled, persist current state
                cnt <= cnt;
            end
        end
    end
endmodule