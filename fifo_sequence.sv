//`include "uvm_macros.svh"
// import uvm_pkg::*;


class fifo_sequence extends uvm_sequence #(fifo_item);
  `uvm_object_utils(fifo_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  virtual task body();
    fifo_item req;
    
    // Phase 1: Fill FIFO with 8 writes
    `uvm_info(get_type_name(), "Starting Write Sequence...", UVM_MEDIUM)
    repeat (8) begin
      req = fifo_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { wr_en == 1'b1; rd_en == 1'b0; });
      finish_item(req);
    end

    // Phase 2: Read back all 8 items
    `uvm_info(get_type_name(), "Starting Read Sequence...", UVM_MEDIUM)
    repeat (8) begin
      req = fifo_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { wr_en == 1'b0; rd_en == 1'b1; });
      finish_item(req);
    end

    // Phase 3: Randomized mixed traffic
    `uvm_info(get_type_name(), "Starting Mixed Random Sequence...", UVM_MEDIUM)
    repeat (20) begin
      req = fifo_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
endclass