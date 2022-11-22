// Nicholas Palmer 825059580
`timescale 1ns/1ps

module tb_buffer;
    bit clk = 0;
    bit rst = 0;

    logic [7:0] a [0:7];
    logic [7:0] b [0:7];
    logic [16:0] c [0:7][0:7];

    buffer UUT(
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c)
    );

    always #5 clk = ~clk;
    
    initial begin
        a[0] = 0; a[1] = 0; a[2] = 0;
        b[0] = 0; b[1] = 0; b[2] = 0;
        #10;
        
        rst = 1;
        a[0] = 1; a[1] = 0; a[2] = 0;
        b[0] = 10; b[1] = 0; b[2] = 0;
        #10;

        a[0] = 4; a[1] = 2; a[2] = 0;
        b[0] = 11; b[1] = 13; b[2] = 0;
        #10;

        a[0] = 7; a[1] = 5; a[2] = 3;
        b[0] = 12; b[1] = 14; b[2] = 16;
        #10;

        a[0] = 0; a[1] = 8; a[2] = 6;
        b[0] = 0; b[1] = 15; b[2] = 17;
        #10;

        a[0] = 0; a[1] = 0; a[2] = 9;
        b[0] = 0; b[1] = 0; b[2] = 18;
        #10;
        
        a[0] = 0; a[1] = 0; a[2] = 0;
        b[0] = 0; b[1] = 0; b[2] = 0;
        #10;
        
        
        #30

        $finish(0);
    end
endmodule