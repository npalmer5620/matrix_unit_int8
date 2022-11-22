// Nicholas Palmer 825059580
`timescale 1ns / 1ps

module buffer #(parameter ASIZE = 3, DSIZE = 8)
    (
    input logic clk,
    input logic rst,
    input logic wen,
    input logic ren,
    input logic [DSIZE-1:0] din,
    output logic full,
    output logic empty,
    output logic [DSIZE-1:0] dout
    );
    
    logic [(2**ASIZE):0] wptr;
    logic [(2**ASIZE):0] rptr;
    logic ptrs_eql;
    logic last_cmp;
    logic [DSIZE-1:0] mem8 [(2**ASIZE)-1:0];
    
    always_comb begin
        ptrs_eql = !(wptr[(2**ASIZE)-1:0] - rptr[(2**ASIZE)-1:0]);
        last_cmp = wptr[(2**ASIZE)] ^ rptr[(2**ASIZE)];
        
        full = ptrs_eql & last_cmp;
        empty = ptrs_eql & ~last_cmp;
        
        dout = mem8[(2**ASIZE)-1:0];
    end
    
    always_ff@(posedge clk) begin
        if (~rst) begin
            wptr <= 0;
            rptr <= 0;
        end else if (wen) begin
            wptr <= wptr + 1;
            
            mem8[(2**ASIZE)-1:0] <= din;
            
            if (ren) begin
                rptr <= rptr + 1;
            end else begin
                rptr <= rptr;
            end
        end else begin
            wptr <= wptr;
            
            if (ren) begin
                rptr <= rptr + 1;
            end else begin
                rptr <= rptr;
            end
        end 
    end
endmodule
