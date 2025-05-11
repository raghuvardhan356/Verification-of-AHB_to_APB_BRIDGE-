class master_agent_top extends uvm_env;
  `uvm_component_utils(master_agent_top)
   master_agent agth;
   env_config env_cfg;
   function new(string name="master_agent_top",uvm_component parent);
     super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
   if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
     `uvm_fatal(get_type_name(),"Configuration getting failed")
   agth = master_agent::type_id::create("agth",this);
   uvm_config_db#(master_config)::set(this,"agth*","master_config",env_cfg.m_cfg);
   endfunction
endclass
