class slave_agent extends uvm_agent;
  `uvm_component_utils(slave_agent)
   slave_driver drvh;
   slave_monitor monh;
   slave_sequencer seqrh;
   slave_config s_cfg;
   function new(string name="slave_agent",uvm_component parent);
    super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
   if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
     `uvm_fatal(get_type_name(),"Slave agent configuration getting failed")
   monh = slave_monitor::type_id::create("monh",this);
   if(s_cfg.is_active==UVM_ACTIVE)
   begin
   drvh = slave_driver::type_id::create("drvh",this);
   seqrh = slave_sequencer::type_id::create("seqrh",this);
   end
   endfunction
   
   function void connect_phase(uvm_phase phase);
   if(s_cfg.is_active==UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);
   endfunction
endclass
