// Nicholas Palmer 825059580
// The primary top level testbench for project
`timescale 1ns/1ps

module tb_sa;
    // set control signals low
    bit clk = 0;
    bit rst = 0;
    bit en = 0;
    
    // delcare module inputs/outputs
    logic signed [7:0] a [0:7][0:7]; // 8 bit array with 8x8 elements (input A)
    logic unsigned [2:0] last_input_row; // specifies the # of input rows 
    logic signed [7:0] b [0:7][0:7]; // 8 bit array with 8x8 elements (input B)
    logic signed [23:0] c [0:7][0:7]; // 24 bit array with 8x8 elements (output C)
    
    logic signed [23:0] temp [0:7][0:7]; // 24 bit array with 8x8 elements (temporary testbench register)

    // Array module
    sa UUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .last_input_row(last_input_row),
        .b(b),
        .c(c)
    );

    // Clock signal
    always #5 clk = ~clk;
    
    initial begin
        // Populate the first matrix multiplication (A x B)
        integer signed n = 1;
        for (integer i = 0; i < 8; i++) begin
            for (integer j = 0; j < 8; j++) begin
                if (j > 2) begin a[i][j] = 5; b[i][j] = 5; 
                end else begin a[i][j] = n; b[i][j] = n; n = n + 1; end;
                
                c[i][j] = 0;
            end
        end
        
        last_input_row = 2; // Say we only want the product until the 3rd row, we dont need to waste clock cycles and we can stop the cal there
        #10;
        
        rst = 1;
        #10;
        
        en = 1;
        #190
        
        
        
        
        
        
        
        
        
        
        
        
        // Done here, so assign the result to the temp regs, and clear output registers
        n = 1;
        for (integer i = 0; i < 8; i++) begin
            for (integer j = 0; j < 8; j++) begin
                // set B to identity matrix
                if (i == j) begin
                    b[i][j] = 1;
                end else begin
                    b[i][j] = 0;
                end
                 // Set A to 1,2,3,4,....,etc
                 a[i][j] = n;
                 n = n + 1;
                // clear C, and assign output to testbench regs
                temp[i][j] = c[i][j];
                c[i][j] = 0;
            end
        end
        
        last_input_row = 7; // We want the entire product this time (8 rows)
        en = 0;
        rst = 0;
        #10;
        
        en = 1;
        rst = 1;
        #240
        
        
        
        
        
        
        
        
        // Now lets test signed negative numbers, multiply A by the negative identity matrix
        n = 1;
        for (integer i = 0; i < 8; i++) begin
            for (integer j = 0; j < 8; j++) begin
                // set B to -1 x identity matrix
                if (i == j) begin
                    b[i][j] = 1 * -1;
                end else begin
                    b[i][j] = 0;
                end
                 // Set A to 1,2,3,4,....,etc
                 a[i][j] = n;
                 n = n + 1;
                // clear C, and assign output to testbench regs
                temp[i][j] = c[i][j];
                c[i][j] = 0;
            end
        end
        
        last_input_row = 5; // Say we only want the product until the 5th row, we dont need to waste clock cycles
        en = 0;
        rst = 0;
        #10;
        
        en = 1;
        rst = 1;
        #220
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Put the result into the tesbench registers 
        for (integer i = 0; i < 8; i++) begin
            for (integer j = 0; j < 8; j++) begin
                // assign output to testbench regs
                temp[i][j] = c[i][j];
            end
        end
        #230
        
        $finish(0);
    end
endmodule