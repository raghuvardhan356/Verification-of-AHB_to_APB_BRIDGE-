class master_monitor extends uvm_monitor;
 `uvm_component_utils(master_monitor)
 virtual Bridge_intf.mst_mon_mp vif;
 master_config mst_cfg;
 uvm_analysis_port #(master_xtn) apm;
  function new(string name="master_monitor",uvm_component parent);
    super.new(name,parent);
    apm = new("apm",this);
  endfunction
 function void build_phase(uvm_phase phase);
 if(!uvm_config_db #(master_config)::get(this,"","master_config",mst_cfg))
   `uvm_fatal(get_type_name(),"Configuration getting failed")
 endfunction
 function void connect_phase(uvm_phase phase); 
 vif = mst_cfg.vif;
 endfunction
 task run_phase(uvm_phase phase);
 forever
  begin
   collect_data();
  end
 endtask
 task collect_data();
 master_xtn data2sb;
 data2sb = master_xtn::type_id::create("data2sb");
 /*while(vif.mst_mon_cb.Htrans!==2 || vif.mst_mon_cb.Htrans!==3)
 begin
  @(vif.mst_mon_cb);
 end*/
 while(vif.mst_mon_cb.Hreadyin!==1)
 begin
   @(vif.mst_mon_cb);
 end
  data2sb.Hwrite=vif.mst_mon_cb.Hwrite;
  data2sb.Hsize=vif.mst_mon_cb.Hsize;
  data2sb.Haddr=vif.mst_mon_cb.Haddr;
  data2sb.Htrans = vif.mst_mon_cb.Htrans;
  data2sb.Hreadyin = vif.mst_mon_cb.Hreadyin;
  @(vif.mst_mon_cb);
  while(vif.mst_mon_cb.Hreadyout!==1)
  begin
   @(vif.mst_mon_cb);
  end
  if(data2sb.Hwrite) data2sb.Hwdata=vif.mst_mon_cb.Hwdata;
  else data2sb.Hrdata = vif.mst_mon_cb.Hrdata;
  $display("Printing master from monitor");
  data2sb.print();
  apm.write(data2sb);
  endtask
endclass
