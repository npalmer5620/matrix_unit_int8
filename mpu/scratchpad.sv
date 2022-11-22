`timescale 1ns / 1ps

module dram8_16 (
    input logic clk,
    input logic rst,
    input logic wen,
    input logic [15:0] addr,
    input logic [7:0] din,
    output logic [7:0] dout
    );
    
    logic [7:0] block [0:65535]; // 8 bit ram, 65,536 addresses
    
    initial begin
        for (integer i = 0; i < 65536; i = i + 1) block[i] = 0;
        $readmemb("block_mem.mem", block, 0, 17);
    end
    
    always_ff@(posedge clk) begin
        if (~rst) begin
            
            dout <= 0;
        end else begin
            dout <= block[addr];
        end
        
        if (wen) begin
            block[addr] <= din;
        end
    end
    
endmodule
