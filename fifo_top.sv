module fifo_tb_top;
  import uvm_pkg::*;
  import fifo_pkg::*;

  bit clk;

  always #5 clk = ~clk;

  fifo_if vif(clk);

  fifo #(.W(32), .D(8)) DUT (
      .clk (vif.clk),
      .rst_n (vif.rst_n),
      .data_in (vif.data_in),
      .data_out (vif.data_out),
      .wr_en (vif.wr_en),
      .rd_en (vif.rd_en),
      .full (vif.full),
      .empty (vif.empty),
      .overflow (vif.overflow),
      .underflow (vif.underflow),
      .counter (vif.counter)
  );

  initial begin
    vif.rst_n = 1'b0;
    #25ns;
    vif.rst_n = 1'b1;
  end

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("fifo_test");
  end
endmodule