module counter8_nowrap (
    input clk,
    input rst,
    input en,
    output logic [3:0] cnt
);
    always_ff @(posedge clk) begin
        if (~rst) begin
            cnt <= 0;
        end else begin
            if (en) begin
                if (cnt != 3'b111) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= cnt;
                end
            end
        end
    end
    
endmodule