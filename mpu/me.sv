// Nicholas Palmer 825059580
`timescale 1ns/1ps

module me (
    input logic clk,
    input logic rst,
    input logic [7:0] a_in,
    input logic [7:0] b_in,
    input logic [7:0] weight_in,
    output logic [7:0] a_pass, 
    output logic [7:0] b_pass, 
    output logic [16:0] c_calc
);
    logic [7:0] weight;
    
    always_ff @(posedge clk) begin
        if (~rst) begin
            a_pass <= 0;
            b_pass <= 0;
            c_calc <= 0;
            weight <= weight_in;
        end else begin
            a_pass <= a_in;
            b_pass <= b_in;
            //c_calc <= 17'(16'(a_in) * 16'(b_in)) + 17'(c_calc);
            c_calc <= 17'(16'(a_in) * 16'(weight)) + 17'(c_calc);
        end
    end
endmodule