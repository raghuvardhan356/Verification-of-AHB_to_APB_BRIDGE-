class slave_monitor extends uvm_monitor;
   `uvm_component_utils(slave_monitor)
    virtual Bridge_intf.slv_mon_mp vif;
   slave_config s_cfg;
   uvm_analysis_port #(slave_xtn) aps;
    function new(string name="slave_monitor",uvm_component parent);
      super.new(name,parent);
      aps = new("aps",this);
    endfunction
    function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg))
     `uvm_fatal(get_type_name(),"Configuration gettinf failed")
    endfunction
   function void connect_phase(uvm_phase phase);
   vif = s_cfg.vif;
   endfunction
   task run_phase(uvm_phase phase);
   forever 
   begin
   collect_data();
   end
   endtask
   
   task collect_data();
   slave_xtn data2sb;
   data2sb = slave_xtn::type_id::create("data2sb");
     while(vif.slv_mon_cb.Penable!==1)
     begin
        @(vif.slv_mon_cb);
      end
     data2sb.Paddr=vif.slv_mon_cb.Paddr;
     data2sb.Pselx = vif.slv_mon_cb.Pselx;
     data2sb.Penable = vif.slv_mon_cb.Penable;
      data2sb.Pwrite = vif.slv_mon_cb.Pwrite;
    if(vif.slv_mon_cb.Pwrite)
       data2sb.Pwdata = vif.slv_mon_cb.Pwdata;
    else
       data2sb.Prdata = vif.slv_mon_cb.Prdata;
    $display("Printing from slave monitor");
    data2sb.print();
    aps.write(data2sb);
    @(vif.slv_mon_cb);
    endtask

endclass
