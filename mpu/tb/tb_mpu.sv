`timescale 1ns / 1ps

module tb_mpu;
    bit clk = 0;
    bit rst = 0;
    always #5 clk = ~clk;
    
    
    // 8 bit ram (64k bytes)
    dram8_16 DRAM(
        .clk(clk),
        .rst(rst),
        .wen(0),
        .addr(dram_addr_bus),
        .din(Z),
        .dout(dram_data_bus)
    );
    
    mpu UUT(
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c)
    );
    
    
    
    
    
    
    initial begin
    
    
        
        for (integer i = 0; i < 8; i++) begin
            for (integer j = 0; j < 8; j++) begin
                
            end
        end
    end
endmodule
