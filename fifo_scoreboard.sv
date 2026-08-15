class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp #(fifo_item, fifo_scoreboard) sb_ap;

  bit [31:0] exp_queue [$];
  int max_depth = 8;
  int pass_count = 0;
  int fail_count = 0;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_ap = new("sb_ap", this);
  endfunction

  virtual function void write(fifo_item tr);
    if (tr.wr_en) begin
      if (exp_queue.size() < max_depth) begin
        exp_queue.push_back(tr.data_in);
        `uvm_info("SCOREBOARD", $sformatf("Stored in queue: 0x%08h | Queue size: %0d", tr.data_in, exp_queue.size()), UVM_LOW)
      end
    end 
    else if (tr.rd_en) begin
      if (exp_queue.size() > 0) begin
        bit [31:0] expected_data = exp_queue.pop_front();
        if (tr.data_out === expected_data) begin
          `uvm_info("SCOREBOARD", $sformatf("[MATCH] Expected: 0x%08h | Actual: 0x%08h", expected_data, tr.data_out), UVM_LOW)
          pass_count++;
        end else begin
          `uvm_error("SCOREBOARD", $sformatf("[MISMATCH] Expected: 0x%08h | Actual: 0x%08h", expected_data, tr.data_out))
          fail_count++;
        end
      end else begin
        `uvm_warning("SCOREBOARD", "Read received but queue is empty!")
      end
    end
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", "--------------------------------------------------", UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("  TOTAL MATCHES:    %0d", pass_count), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("  TOTAL MISMATCHES: %0d", fail_count), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("  REMAINING ITEMS:  %0d", exp_queue.size()), UVM_NONE)
    `uvm_info("SCOREBOARD", "--------------------------------------------------", UVM_NONE)
  endfunction
endclass