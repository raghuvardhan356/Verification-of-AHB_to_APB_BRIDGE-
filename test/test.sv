class base_test extends uvm_test;
  `uvm_component_utils(base_test)
   env envh;
   /*incr_trans incr_seq;
   single_trans single_seq;
   wrap_trans wrap_seq;*/
  function new(string name="base_test",uvm_component parent);
   super.new(name,parent);
  endfunction
  env_config env_cfg;
  master_config m_cfg;
  slave_config s_cfg;
  function void build_phase(uvm_phase phase);
  env_cfg = env_config::type_id::create("env_cfg");
  m_cfg = master_config::type_id::create("m_cfg");
  s_cfg = slave_config::type_id::create("s_cfg");
  if(!uvm_config_db#(virtual Bridge_intf)::get(this,"","inm",m_cfg.vif))
    `uvm_fatal(get_type_name(),"Confiuration getting failed") 
  if(!uvm_config_db#(virtual Bridge_intf)::get(this,"","ins",s_cfg.vif))
   `uvm_fatal(get_type_name(),"Configuration getting failed")
  m_cfg.is_active  = UVM_ACTIVE;
  s_cfg.is_active = UVM_ACTIVE;
  env_cfg.m_cfg = m_cfg;
  env_cfg.s_cfg = s_cfg;
  envh = env::type_id::create("envh",this);
  uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  endfunction
  /*task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  incr_seq = incr_trans::type_id::create("incr_seq");
  incr_seq.start(envh.m_agt_top.agth.seqrh);
  phase.drop_objection(this);
  phase.raise_objection(this);
  single_seq=single_trans::type_id::create("single_seq");
  single_seq.start(envh.m_agt_top.agth.seqrh);
  phase.drop_objection(this);
  phase.raise_objection(this);
  $display("Wrap sequence");
  wrap_seq= wrap_trans::type_id::create("wrap_seq");
  wrap_seq.start(envh.m_agt_top.agth.seqrh);
  phase.drop_objection(this);
  endtask*/
endclass
 class single_test extends base_test;
  `uvm_component_utils(single_test)
   single_trans single_seq;
   slave_data slave_seq;
   function new(string name="single_test",uvm_component parent);
    super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  single_seq = single_trans::type_id::create("single_seq");
  slave_seq = slave_data::type_id::create("slave_seq");
  fork
  single_seq.start(envh.m_agt_top.agth.seqrh);
 //  slave_seq.start(envh.s_agt_top.agth.seqrh);
  join
  #40;
  phase.drop_objection(this);
  endtask
endclass
 class increment_test extends base_test;
   `uvm_component_utils(increment_test)
    incr_trans incr_seq;
    slave_data slave_seq;
    function new(string name="increment_test",uvm_component parent);
     super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
   endfunction
  task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  incr_seq = incr_trans::type_id::create("incr_seq");
 // slave_seq = slave_data::type_id::create("slave_seq");
  fork
  incr_seq.start(envh.m_agt_top.agth.seqrh);
//  slave_seq.start(envh.s_agt_top.agth.seqrh);
 // #30;
  join
  #40;
  phase.drop_objection(this);
  endtask
endclass

class wrap_test extends base_test;
  `uvm_component_utils(wrap_test)
   wrap_trans wrap_seq;
   slave_data slave_seq;
   function new(string name="wrap_test",uvm_component parent);
     super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
   endfunction
   task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  wrap_seq = wrap_trans::type_id::create("wrap_trans");
  slave_seq = slave_data::type_id::create("slave_seq");
  fork
  wrap_seq.start(envh.m_agt_top.agth.seqrh);
 // slave_seq.start(envh.s_agt_top.agth.seqrh);
 // #30;
  join
  #40;
  phase.drop_objection(this);
 endtask
endclass
