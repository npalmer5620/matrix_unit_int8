// Nicholas Palmer 825059580
`timescale 1ns/1ps

module sa (
    input logic clk,
    input logic rst,
    input logic [7:0] a [0:7], // 8 bit array with 8 elements
    input logic [7:0] b [0:7], // 8 bit array with 8 elements
    input logic [7:0] weights [0:7] [0:7], // 8 bit array with 8x8 elements
    output logic [16:0] c [0:7][0:7] // 17 bit array with 8x8 elements
);
    logic [7:0] a_pass_net[0:7][0:7]; // 8 bit array with 8x8 elements
    logic [7:0] b_pass_net[0:7][0:7]; // 8 bit array with 8x8 elements

    generate
        genvar i;
        for (i = 0; i < 8; i++) begin
            genvar j;
            for (j = 0; j < 8; j++) begin
                if (i == 0) begin // row 0
                    if (j == 0) begin // col 0
                        me matrix_engine(.clk(clk), .rst(rst), .a_in(b[j]), .b_in(a[i]), .weight_in(weights[i][j]), .a_pass(b_pass_net[i][j]), .b_pass(a_pass_net[i][j]), .c_calc(c[i][j]));
                    end else begin // all other cols
                        me matrix_engine(.clk(clk), .rst(rst), .a_in(b[j]), .b_in(a_pass_net[i][j-1]), .weight_in(weights[i][j]), .a_pass(b_pass_net[i][j]), .b_pass(a_pass_net[i][j]), .c_calc(c[i][j]));
                    end



                end else begin // all other rows
                    if (j == 0) begin // col 0 THIS IS WRONG
                        me matrix_engine(.clk(clk), .rst(rst), .a_in(b_pass_net[i-1][j]), .b_in(a[i]), .weight_in(weights[i][j]), .a_pass(b_pass_net[i][j]), .b_pass(a_pass_net[i][j]), .c_calc(c[i][j]));
                    end else begin // all other cols
                        me matrix_engine(.clk(clk), .rst(rst), .a_in(b_pass_net[i-1][j]), .b_in(a_pass_net[i][j-1]), .weight_in(weights[i][j]), .a_pass(b_pass_net[i][j]), .b_pass(a_pass_net[i][j]), .c_calc(c[i][j]));
                    end
                end
            end
        end
    endgenerate
endmodule
