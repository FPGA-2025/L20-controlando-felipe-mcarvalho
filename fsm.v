module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);


    parameter WRITE = 1'b0, 
              STOP = 1'b1;
    reg state;


    assign fifo_data = 8'hAA;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= WRITE;
            wr_en <= 1'b1;
        end 
        else begin
            case (state)
                WRITE: begin
                    if (fifo_words >= 4'd5) begin
                        wr_en <= 1'b0;
                        state <= STOP;
                    end else begin
                        wr_en <= 1'b1;
                    end
                end
                STOP: begin
                    if (fifo_words <= 4'd2) begin
                        wr_en <= 1'b1;
                        state <= WRITE;
                    end 
                    else begin
                        wr_en <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
