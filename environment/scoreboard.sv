class scoreboard extends uvm_scoreboard;
 `uvm_component_utils(scoreboard)
  master_xtn ahb;
  master_xtn ahb_cg;
  slave_xtn apb;
  slave_xtn apb_cg;
  uvm_tlm_analysis_fifo #(master_xtn) fifo_m;
  uvm_tlm_analysis_fifo #(slave_xtn) fifo_s;
  function new(string name="scoreboard",uvm_component parent);  
   super.new(name,parent);
   fifo_m = new("fifo_m",this);
   fifo_s = new("fifo_s",this);
   master_cg = new();
   slave_cg = new();
  endfunction
  covergroup master_cg;
  HADDR:coverpoint ahb_cg.Haddr
      {
      bins slave1={[32'h8000_0000:32'h8000_03ff]};
      bins slave2={[32'h8400_0000:32'h8400_03ff]};
      bins slave3={[32'h8800_0000:32'h8800_03ff]};
      bins slave4={[32'h8C00_0000:32'h8C00_03ff]};
      }
  HSIZE:coverpoint ahb_cg.Hsize
       {
       bins zero={0};
       bins one = {1};
       bins two = {2}; 
       }
  HTRANS:coverpoint ahb_cg.Htrans
        {
        bins ok = {0};
        bins busy = {1};
        bins nseq = {2};
        bins seq = {3};
        }
  HWRITE:coverpoint ahb_cg.Hwrite
         {
          bins write = {1};
          bins read = {0};
         }
  endgroup
  
  covergroup slave_cg;
  PSELX:coverpoint apb_cg.Pselx
        {
        bins one = {1};
        bins two = {2}; 
        bins four = {4};
        bins eight = {8};
        }
  PADDR:coverpoint apb_cg.Paddr
       {
      bins slave1={[32'h8000_0000:32'h8000_03ff]};
      bins slave2={[32'h8400_0000:32'h8400_03ff]};
      bins slave3={[32'h8800_0000:32'h8800_03ff]};
      bins slave4={[32'h8C00_0000:32'h8C00_03ff]};
      }
 PWRITE:coverpoint apb_cg.Pwrite
        {
        bins write = {1};
        bins read = {0};
        }
  endgroup
  
  task run_phase(uvm_phase phase);
  forever
  begin
    fork
     begin
     fifo_m.get(ahb);
     ahb_cg = new ahb;
     master_cg.sample();
     end
     begin
     fifo_s.get(apb);
     apb_cg = new apb;
     slave_cg.sample();
     end
    join
    check_data(ahb,apb);
  end
 endtask
 task check_data(master_xtn ahb,slave_xtn apb);
 //write operation checking logic
 if(ahb.Hwrite==1)
 begin
  if(ahb.Hsize==2'b00)
  begin
    if(ahb.Haddr[1:0]==2'b00)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);
    else if(ahb.Haddr[1:0] == 2'b01)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);
    else if(ahb.Haddr[1:0]==2'b10)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);
    else
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata[7:0]);
  end
  else if(ahb.Hsize==2'b01)
  begin
    if(ahb.Haddr[1:0]==2'b00)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);
    else if(ahb.Haddr[1:0]==2'b10)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
  end
  else if(ahb.Hsize==2'b10)
      compare(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
 end
 //read operating checking logic
 else
 begin
    if(ahb.Hsize==2'b00)
    begin
    if(ahb.Haddr[1:0]==2'b00)
      compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[7:0]);
    else if(ahb.Haddr[1:0] == 2'b01)
      compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[15:8]);
    else if(ahb.Haddr[1:0]==2'b10)
      compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[23:16]);
    else
      compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[31:24]);
    end
    else if(ahb.Hsize==2'b01)
    begin
     if(ahb.Haddr[1:0]==2'b00)
       compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[15:0]);
     else if(ahb.Haddr[1:0]==2'b10)
        compare(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[31:16]);
    end
    else if(ahb.Hsize==2'b10)
       compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata);
 end
 endtask
 task compare(int Haddr,Paddr,Hdata,Pdata);
 if(Haddr==Paddr)
 begin
   $display("Address matched");
   $display("Haddr = %0d",Haddr);
   $display("Paddr = %0d",Paddr);
 end
 else
 begin
   $display("Address mismatched");
   $display("Haddr = %0d",Haddr);
   $display("Paddr = %0d",Paddr);
 end
 if(Hdata==Pdata)
 begin
   $display("Data matched");
   $display("Hdata = %0d",Hdata);
   $display("Pdata = %0d",Pdata);
 end
 else 
 begin
  $display("Data mismatched");
  $display("Hdata = %0d",Hdata);
  $display("Pdata = %0d",Pdata);
 end
 endtask
endclass
