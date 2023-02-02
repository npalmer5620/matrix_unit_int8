// Nicholas Palmer 825059580
// Systolic array element building block, stores intermmediate values and performs MAC ops 
`timescale 1ns/1ps

// "Matrix Engine"
module me (
    input logic clk,
    input logic rst, // reset (clear accumulator and a out register
    input logic en, // matrix engine enable
    
    input logic signed [7:0] a_in, // A input, 8-bit input from the previous matrix engine
    input logic signed [7:0] b_reg, // The B register, 8-bit register that stores the corresponding B matrix value
    input logic signed [23:0] acc_in, // Accumulator input, 24 bit input from the matrix engine before this one
    
    output logic signed [7:0] a_out, // A output, 8-bit output that goes to the next matrix engine
    output logic signed [23:0] acc_out // Accumulator output, 24 bit output that goes downward to the next matrix engine (or output)
);
    
    always_ff @(posedge clk) begin
        if (~rst) begin
            // Clear the registers
            a_out <= 0;
            acc_out <= 0;
        end else begin
            // If enabled, perform Mac and pass a through processing element
            if (en) begin
                // Pass the input thru the element
                a_out <= a_in;
                
                // Perform the MAC operation then save to the 24 bit partial sum register (accumulator out).
                acc_out <= 24'(16'(a_in) * 16'(b_reg)) + acc_in;
            end else begin
                // If not enabled, do keep state
                a_out <= a_out;
                acc_out <= acc_out;
            end
        end
    end
endmodule