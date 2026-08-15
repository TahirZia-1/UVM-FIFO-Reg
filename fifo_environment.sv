class fifo_environment extends uvm_env;
  `uvm_component_utils(fifo_environment)

  fifo_agent agt;
  fifo_scoreboard sb;

  function new(string name = "fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = fifo_agent::type_id::create("agt", this);
    sb = fifo_scoreboard::type_id::create("sb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(sb.sb_ap);
  endfunction
endclass