class master_config extends uvm_object;
 `uvm_object_utils(master_config)
  virtual Bridge_intf vif;
  uvm_active_passive_enum is_active;
  function new(string name="master_config");
   super.new(name);
  endfunction
endclass

