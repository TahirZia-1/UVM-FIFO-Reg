class fifo_driver extends uvm_driver #(fifo_item);
  `uvm_component_utils(fifo_driver)

  virtual fifo_if vif;

  function new(string name = "fifo_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in uvm_config_db!")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b0;
    vif.data_in <= '0;

    @(posedge vif.rst_n);
    @(posedge vif.clk);

    forever begin
      seq_item_port.get_next_item(req);

      @(posedge vif.clk);
      vif.wr_en <= req.wr_en;
      vif.rd_en <= req.rd_en;
      vif.data_in <= req.data_in;

      @(posedge vif.clk);
      vif.wr_en <= 1'b0;
      vif.rd_en <= 1'b0;
      vif.data_in <= '0;

      seq_item_port.item_done();
    end
  endtask
endclass