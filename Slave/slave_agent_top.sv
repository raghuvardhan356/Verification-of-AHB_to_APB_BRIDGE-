class slave_agent_top extends uvm_env;
  `uvm_component_utils(slave_agent_top)
   slave_agent agth;
   env_config env_cfg;
   function new(string name="slave_agent_top",uvm_component parent);
    super.new(name,parent);
   endfunction
  function void build_phase(uvm_phase phase);
  if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
    `uvm_fatal(get_type_name,"Configuration getting failed")
  agth = slave_agent::type_id::create("agth",this);
  uvm_config_db#(slave_config)::set(this,"agth*","slave_config",env_cfg.s_cfg);
  endfunction
endclass
