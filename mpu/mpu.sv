// Nicholas Palmer 825059580
`timescale 1ns/1ps

module sa (
    input logic clk,
    input logic rst,
    input logic array_control,
    input logic signed [7:0] a [0:7][0:7], // 8 bit array with 8x8 elements
    input logic signed [7:0] b [0:7][0:7], // 8 bit array with 8x8 elements
    output logic signed [23:0] c [0:7][0:7], // 24 bit array with 8x8 elements
    output logic signed [23:0] c_test [0:7], // 24 bit TEST array
    output logic array_busy
);
    logic signed [7:0] a_pass_net[0:7][0:7]; // 8 bit array with 8x8 elements
    logic signed [7:0] a_input_net [0:7];    // 8 bit vector with 8 elements
    logic signed [23:0] psum_pass_net[0:7][0:7]; // 24 bit array with 8x8 elements
    
    // 4 bit counters
    logic unsigned [3:0] in_cnt;
    logic unsigned [3:0] out_cnt;
    logic out_cnt_rst;
    logic out_cnt_en;
    
    // Input counter to synchronize input timing
    counter4_nowrap IN_COUNTER(.clk(clk),
                               .rst(rst),
                               .en(array_control),
                               .cnt(in_cnt));
    
    // Input counter to synchronize output timing
    counter4_nowrap OUT_COUNTER(.clk(clk),
                               .rst(out_cnt_rst),
                               .en(out_cnt_en),
                               .cnt(out_cnt));
                               
    // Before the input timer needs to start, clear it
    always_comb begin
        if (in_cnt == 4'b1000) begin
            out_cnt_en = 0;
            out_cnt_rst = 0; // Set RST low to clear 1 cycle before
        end else if (in_cnt >= 4'b1001) begin
            out_cnt_en = 1; // Start counting timer
            out_cnt_rst = 1; // Clear RST
        end else begin
            out_cnt_en = 0; // Otherwise turn off counter and dont reset
            out_cnt_rst = 1;
        end
    end

    generate
        genvar i;
        for (i = 0; i < 8; i++) begin
            genvar j;
            for (j = 0; j < 8; j++) begin
                if (i == 0) begin // row 0
                    if (j == 0) begin // row 0 : col 0
                        me ME(.clk(clk), .rst(rst), .en(array_control), .a_in(a_input_net[i]), .b_reg(b[i][j]), .acc_in(0), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end else begin // row 0 : cols 1 - 7
                        me ME(.clk(clk), .rst(rst), .en(array_control), .a_in(a_pass_net[i][j-1]), .b_reg(b[i][j]), .acc_in(0), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end

                end else begin // rows 1 - 7
                    if (j == 0) begin // rows 1 - 7 : col 0
                        me ME(.clk(clk), .rst(rst), .en(array_control), .a_in(a_input_net[i]), .b_reg(b[i][j]), .acc_in(psum_pass_net[i-1][j]), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end else begin // rows 1 - 7 : cols 1 - 7
                        me ME(.clk(clk), .rst(rst), .en(array_control), .a_in(a_pass_net[i][j-1]), .b_reg(b[i][j]), .acc_in(psum_pass_net[i-1][j]), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end
                end
            end
        end
    endgenerate
    
    // Input status comb logic
    always_comb begin
        // If we reach last states for our timers, then we are done, otherwise busy
        if ((in_cnt == 4'b1111) && (out_cnt == 4'b1111)) begin
            array_busy = 0;
        end else begin
            array_busy = 1;
        end
    end
    
    // Input buffer ===> sytolic array logic
    always_ff @(posedge clk) begin
        if (~rst) begin
            // For every row in the array
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                a_input_net[i] <= 0;
            end
        end
        else if (array_control) begin
            // For every row in the array
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                // Only select valid rows: ie. do not select row 0 when counter is past value 7
                if ((in_cnt >= i) && (in_cnt <= (i+7))) begin
                    a_input_net[i] <= a[in_cnt-i][i];
                end else begin
                    a_input_net[i] <= 0;
                end
            end
        end else begin
            // For every row in the array
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                a_input_net[i] <= 0;
            end
        end
    end
    
    // SA to Output buffer Logic
    always_ff @(posedge clk) begin
        if (out_cnt_en) begin
            for (integer unsigned i = 0; i < 8; i = i + 1) begin
                for (integer unsigned j = 0; j < 8; j = j + 1) begin
                    if ((out_cnt >= i) && (out_cnt <= (i+7))) begin
                        c[out_cnt-i][j] <= psum_pass_net[7][j];
                    end else begin
                        c <= c;
                    end
                end
            end
        end else begin
            c <= c;
        end
    end
    
    // TEST 
    always_comb begin
        c_test = psum_pass_net[7];
    end
endmodule
