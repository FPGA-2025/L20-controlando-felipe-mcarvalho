module fifo(
    input   clk,
    input   rst_n,

    // Write interface
    input   wr_en,
    input   [7:0] data_in,
    output  full,

    // Read interface
    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);


    reg [7:0] mem [0:7];
    reg [2:0] rd_ptr, wr_ptr;

    wire do_wr = wr_en & ~full;
    wire do_rd = rd_en & ~empty;

    assign full  = (fifo_words == 4'd8);
    assign empty = (fifo_words == 4'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            rd_ptr     <= 3'd0;
            wr_ptr     <= 3'd0;
            fifo_words <= 4'd0;
            data_out   <= 8'd0;
        end 
        else begin
            if (do_wr) begin
                mem[wr_ptr] <= data_in;
                wr_ptr      <= wr_ptr + 3'd1;
            end
            if (do_rd) begin
                data_out <= mem[rd_ptr];
                rd_ptr   <= rd_ptr + 3'd1;
            end
            fifo_words <= fifo_words + do_wr - do_rd;
        end
    end
endmodule