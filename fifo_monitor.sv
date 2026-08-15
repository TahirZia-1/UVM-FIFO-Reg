class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if vif;
  uvm_analysis_port #(fifo_item) ap;

  function new(string name = "fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in uvm_config_db!")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_item tr;
    bit rd_pending = 0;

    @(posedge vif.rst_n);

    forever begin
      @(posedge vif.clk);
      if (!vif.rst_n) begin
        rd_pending = 0;
        continue;
      end

      if (rd_pending) begin
        tr = fifo_item::type_id::create("tr_rd");
        tr.rd_en = 1'b1;
        tr.wr_en = 1'b0;
        tr.data_out = vif.data_out;
        `uvm_info(get_type_name(), $sformatf("Monitored READ item: data_out = 0x%08h", tr.data_out), UVM_HIGH)
        ap.write(tr);
        rd_pending = 0;
      end

      if (vif.wr_en && !vif.full) begin
        tr = fifo_item::type_id::create("tr_wr");
        tr.wr_en = 1'b1;
        tr.rd_en = 1'b0;
        tr.data_in = vif.data_in;
        `uvm_info(get_type_name(), $sformatf("Monitored WRITE item: data_in = 0x%08h", tr.data_in), UVM_HIGH)
        ap.write(tr);
      end

      if (vif.rd_en && !vif.empty) begin
        rd_pending = 1;
      end
    end
  endtask
endclass