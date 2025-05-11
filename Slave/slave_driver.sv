class slave_driver extends uvm_driver#(slave_xtn);
  `uvm_component_utils(slave_driver)
   virtual Bridge_intf.slv_drv_mp vif;
   slave_config s_cfg;
   function new(string name="slave_driver",uvm_component parent);
     super.new(name,parent);
   endfunction
  function void build_phase(uvm_phase phase);
  if(!uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg))
    `uvm_fatal(get_type_name(),"Configuration getting failed")
  endfunction
  function void connect_phase(uvm_phase phase);
  vif = s_cfg.vif;
  endfunction
   task run_phase(uvm_phase phase);
   forever 
   begin
    //seq_item_port.get_next_item(req);
    send_to_dut(req); 
   // seq_item_port.item_done();
   end
  endtask
  
  task send_to_dut(slave_xtn req);
  while(vif.slv_drv_cb.Pselx!=(1||2||4||8))
  begin
    @(vif.slv_drv_cb);
  end
  if(vif.slv_drv_cb.Pwrite==0)
  vif.slv_drv_cb.Prdata<=32'd256;
  @(vif.slv_drv_cb);
  endtask
endclass
