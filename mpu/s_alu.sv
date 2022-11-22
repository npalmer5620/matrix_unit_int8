// Perform A * B = C
module sa_manager (
    input logic clk,
    input logic run_op,
    input logic [7:0] A [0:7] [0:7],
    output logic ready_state
);
    // use 8 value timer and (cnt>=n) to time the read for the correct column for every row(n) in the array
    counter8_nowrap in_cnt(.clk(clk), .rst(), .en(), );
endmodule