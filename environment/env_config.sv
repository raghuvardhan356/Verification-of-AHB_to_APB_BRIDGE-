class env_config extends uvm_object;
 `uvm_object_utils(env_config)
  master_config m_cfg;
  slave_config s_cfg;
  function new(string name="env_config");
    super.new(name);
  endfunction
endclass
