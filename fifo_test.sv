class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_environment env;

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_sequence seq = fifo_sequence::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agt.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass