`timescale 1ns/1ps

module fifo #(parameter W = 32, parameter D = 8) (
    input logic [W-1 : 0] data_in,
    input logic clk, rst_n, wr_en, rd_en,
    output logic [W-1 : 0] data_out,
    output logic full, empty, overflow, underflow,
    output logic [$clog2(D) : 0] counter
);

  logic [W-1:0] fifo_reg [0:D-1];
  logic [$clog2(D):0] wr_ptr, rd_ptr;

  assign full  = (rd_ptr[$clog2(D)] != wr_ptr[$clog2(D)]) && (rd_ptr[$clog2(D)-1:0] == wr_ptr[$clog2(D)-1:0]);
  assign empty = (rd_ptr == wr_ptr);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_out <= '0;
      counter <= '0;
      wr_ptr <= '0;
      rd_ptr <= '0;
      overflow <= 1'b0;
      underflow <= 1'b0;
      for (int i = 0; i < D; i++) begin
        fifo_reg[i] <= '0;
      end
    end else begin
      overflow <= 1'b0;
      underflow <= 1'b0;

      if (wr_en && !full && rd_en && !empty) begin
        fifo_reg[wr_ptr[$clog2(D)-1:0]] <= data_in;
        wr_ptr <= wr_ptr + 1;
        data_out <= fifo_reg[rd_ptr[$clog2(D)-1:0]];
        rd_ptr <= rd_ptr + 1;
      end
      else if (wr_en && !full && !rd_en) begin
        fifo_reg[wr_ptr[$clog2(D)-1:0]] <= data_in;
        wr_ptr <= wr_ptr + 1;
        counter <= counter + 1;
      end
      else if (wr_en && full && !rd_en) begin
        overflow <= 1'b1;
      end
      else if (rd_en && !empty && !wr_en) begin
        data_out <= fifo_reg[rd_ptr[$clog2(D)-1:0]];
        rd_ptr <= rd_ptr + 1;
        counter <= counter - 1;
      end
      else if (rd_en && empty && !wr_en) begin
        underflow <= 1'b1;
      end
    end
  end

endmodule