class master_driver extends uvm_driver #(master_xtn);
  `uvm_component_utils(master_driver)
   virtual Bridge_intf.mst_drv_mp vif;
   master_config mst_cfg;
  function new(string name="master_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  int count;
  function void build_phase(uvm_phase phase);
  if(!uvm_config_db #(master_config)::get(this,"","master_config",mst_cfg))
     `uvm_fatal(get_type_name(),"Configuration getting failed")
  endfunction
  function void connect_phase(uvm_phase phase);
  vif = mst_cfg.vif;
  endfunction
  task run_phase(uvm_phase phase);
  @(vif.mst_drv_cb);
  vif.mst_drv_cb.Hresetn<=1'b0;
  @(vif.mst_drv_cb); 
  vif.mst_drv_cb.Hresetn<=1'b1;
  forever
  begin
   
   seq_item_port.get_next_item(req);
   //req.print();
   send_to_dut(req);
   //count++;
   //$display("count = %0d",count);
   seq_item_port.item_done();
  end
  endtask
  task send_to_dut(master_xtn req);
  while(vif.mst_drv_cb.Hreadyout!==1)
  begin
    @(vif.mst_drv_cb);
  end
  vif.mst_drv_cb.Hwrite<=req.Hwrite;
  vif.mst_drv_cb.Hreadyin<=1'b1;
  vif.mst_drv_cb.Haddr<=req.Haddr;
  vif.mst_drv_cb.Htrans<=req.Htrans;
  vif.mst_drv_cb.Hsize<=req.Hsize;
   @(vif.mst_drv_cb);
  while(vif.mst_drv_cb.Hreadyout!==1)
  begin
    @(vif.mst_drv_cb);
  end
  vif.mst_drv_cb.Hwdata<=req.Hwdata;
  $display("Printing from Master driver");
  req.print();
  endtask
endclass
