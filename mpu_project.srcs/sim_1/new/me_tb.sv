// Nicholas Palmer 825059580
// Matrix engine testbench
`timescale 1ns / 1ps

module me_tb();
    // control signals
    bit clk = 0;
    bit rst = 0;
    bit en = 0;
    
    logic signed [7:0] a_in; // A input, 8-bit input from the previous matrix engine
    logic signed [7:0] b_reg; // The B register, 8-bit register that stores the corresponding B matrix value
    logic signed [23:0] acc_in; // Accumulator input, 24 bit input from the matrix engine before this one
    
    logic signed [7:0] a_out; // A output, 8-bit output that goes to the next matrix engine
    logic signed [23:0] acc_out; // Accumulator output, 24 bit output that goes downward to the next matrix engine (or output)
    
    me UUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .a_in(a_in),
        .b_reg(b_reg),
        .acc_in(acc_in),
        .a_out(a_out),
        .acc_out(acc_out)
    );
    
    // Clock signal
    always #5 clk = ~clk;
    
    initial begin
        a_in = 1;
        b_reg = 1;
        acc_in = 0;
        #10;
        
        en = 1;
        rst = 1;
        #30;
        
        a_in = -25;
        b_reg = -4;
        acc_in = 25;
        #10;
        
        rst = 0;
        #30;
        
        rst = 1;
        #30;
        
    end
    
endmodule
