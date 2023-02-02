// Nicholas Palmer 825059580
// Systolic Array Module
`timescale 1ns/1ps

module sa(
    input logic clk,
    input logic rst,
    input logic en, // controls if data will flow through the array
    input logic signed [7:0] a [0:7][0:7], // 8 bit array with 8x8 elements
    input logic unsigned [2:0] last_input_row, // the index of the last row in A
    input logic signed [7:0] b [0:7][0:7], // 8 bit array with 8x8 elements
    output logic signed [23:0] c [0:7][0:7] // 24 bit array with 8x8 elements
);
    logic signed [7:0] a_input_net [0:7];    // 8 bit vector with 8 nets, passes values from A register, into the array 
    logic signed [7:0] a_pass_net[0:7][0:7]; // 8 bit array with 8x8 nets, passes the inputs from left to right in the array
    logic signed [23:0] psum_pass_net[0:7][0:7]; // 24 bit array with 8x8 nets, passes partial sums from top of array to bottom
    
    // 4 bit counters, used for time synchronization of input and output data
    logic unsigned [3:0] in_cnt; // register select based on timer states
    logic unsigned [3:0] out_cnt; // tracks which diagonal we are outputting on
    
    // ouput sync timer control signals
    logic out_cnt_rst, out_cnt_en;
    
    input_logic input_logic(
    .clk(clk),
    .en(en),
    .rst(rst),
    .in_cnt(in_cnt),
    .a(a),
    .a_input_net(a_input_net));
    
    output_logic output_logic(
        .clk(clk),
        .out_cnt_en(out_cnt_en),
        .out_cnt(out_cnt),
        .psum_pass_net(psum_pass_net),
        .c(c)
);
    
    // Signals output timer control signals
    // Controls when to enable and reset output sync counter
    always_latch begin
        if (in_cnt == 4'b1001) begin
            out_cnt_en = 1; // Start counting output sync timer
            out_cnt_rst = 1; // Clear RST
        end else if ((out_cnt_en) && (in_cnt == 4'b1000)) begin
            out_cnt_rst = 0; // Set RST low to clear 1 cycle before
        end
    end
    
    // Input counter to synchronize input timing
    counter4 in_counter(.clk(clk),
                               .rst(rst),
                               .en(en),
                               .end_state((4'b1110) - (7 - last_input_row)),
                               .cnt(in_cnt));
    
    // Input counter to synchronize output timing
    counter4 out_counter(.clk(clk),
                               .rst(rst & out_cnt_rst),
                               .en(en & out_cnt_en),
                               .end_state((4'b1110) - (7 - last_input_row)),
                               .cnt(out_cnt));
                               
    // This generate generates our 8 by 8 array and sets the inputs and outputs accordingly based on a matrix engine's lcoation in the array
    // ie. row 0 partial sums should be 0, ie. col0 a_in's should be a_input_net reading from A register
    generate
        genvar i;
        for (i = 0; i < 8; i++) begin
            genvar j;
            for (j = 0; j < 8; j++) begin
                if (i == 0) begin // row 0
                    if (j == 0) begin // row 0 : col 0
                        me ME(.clk(clk), .rst(rst), .en(en), .a_in(a_input_net[i]), .b_reg(b[i][j]), .acc_in(24'b0), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end else begin // row 0 : cols 1 - 7
                        me ME(.clk(clk), .rst(rst), .en(en), .a_in(a_pass_net[i][j-1]), .b_reg(b[i][j]), .acc_in(24'b0), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end

                end else begin // rows 1 - 7
                    if (j == 0) begin // rows 1 - 7 : col 0
                        me ME(.clk(clk), .rst(rst), .en(en), .a_in(a_input_net[i]), .b_reg(b[i][j]), .acc_in(psum_pass_net[i-1][j]), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end else begin // rows 1 - 7 : cols 1 - 7
                        me ME(.clk(clk), .rst(rst), .en(en), .a_in(a_pass_net[i][j-1]), .b_reg(b[i][j]), .acc_in(psum_pass_net[i-1][j]), .a_out(a_pass_net[i][j]), .acc_out(psum_pass_net[i][j]));
                    end
                end
            end
        end
    endgenerate
endmodule
