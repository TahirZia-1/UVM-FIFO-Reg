class fifo_item extends uvm_sequence_item;
  `uvm_object_utils(fifo_item)

  rand bit wr_en;
  rand bit rd_en;
  rand bit [31:0] data_in;
  bit [31:0] data_out;

  constraint valid_op_c {
    !(wr_en && rd_en);
    wr_en dist {1 := 50, 0 := 50};
    rd_en dist {1 := 50, 0 := 50};
  }

  function new(string name = "fifo_item");
    super.new(name);
  endfunction

  virtual function string convert2string();
    return $sformatf("wr_en=%0b, rd_en=%0b, data_in=0x%08h, data_out=0x%08h", 
                     wr_en, rd_en, data_in, data_out);
  endfunction
endclass

/*
module fifo #(parameter W = 8, parameter D = 32) (
    input logic [W-1 : 0] data_in,
    input logic clk, rst_n, wr_en, rd_en,
    output logic [W-1 : 0] data_out,
    output logic full, empty, overflow, underflow,
    output logic [$clog2(D) : 0] counter
);
*/