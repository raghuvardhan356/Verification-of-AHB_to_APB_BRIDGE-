class env extends uvm_env;
  `uvm_component_utils(env)
   master_agent_top m_agt_top;
   slave_agent_top s_agt_top;
   scoreboard sbh;
  // env_config env_cfg;
   function new(string name="env",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
  sbh = scoreboard::type_id::create("sbh",this);
  m_agt_top  = master_agent_top::type_id::create("m_agt_top",this);
  s_agt_top = slave_agent_top::type_id::create("s_agt_tpp",this);
  endfunction
  function void connect_phase(uvm_phase phase);
  m_agt_top.agth.monh.apm.connect(sbh.fifo_m.analysis_export);
  s_agt_top.agth.monh.aps.connect(sbh.fifo_s.analysis_export);
  endfunction
endclass
 
