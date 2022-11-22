// Nicholas Palmer 825059580
`timescale 1ns/1ps

module mpu (
    input logic clk,
    input logic [7:0] weights [0:7] [0:7], // 8 bit array with 8x8 elements
    input logic [7:0] dram_data_bus,
    input logic [15:0] dram_addr_bus,
    
);
    
    logic [7:0] a [0:7]; // 8 8-bit input lines (A)
    // logic [7:0] b [0:7];
    logic [16:0] c [0:7][0:7]; 

    sa SA(
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(0),
        .weights(weights),
        .c(c)
    );
    
    logic [31:0] acc [0:15]; // 16 32-bit accumulator registers
    
    always_ff @(posedge clk) begin
        if (~rst) begin
            // clear all the accumulators
            for (integer i = 0; i < 16; i++) begin
                acc[i] <= 0;
            end
        end else begin
            
        end
    end
    
    
endmodule