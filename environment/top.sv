module top;
 import uvm_pkg::*;
 bit clk;
 always #5 clk = ~clk;
 Bridge_intf inm(clk);
 Bridge_intf ins(clk);
 rtl_top DUV(.Hclk(clk),.Hresetn(inm.Hresetn),.Htrans(inm.Htrans),.Hsize(inm.Hsize),.Hreadyin(inm.Hreadyin),.Hwdata(inm.Hwdata),.Haddr(inm.Haddr),.Hwrite(inm.Hwrite),.Prdata(ins.Prdata),.Hrdata(inm.Hrdata),.Hresp(inm.Hresp),.Hreadyout(inm.Hreadyout),.Pselx(ins.Pselx),.Pwrite(ins.Pwrite),.Penable(ins.Penable),.Paddr(ins.Paddr),.Pwdata(ins.Pwdata));

 initial
 begin
  `ifdef VCS
    $fsdbDumpvars(0, top);
    `endif
 uvm_config_db#(virtual Bridge_intf)::set(null,"*","inm",inm);
 uvm_config_db#(virtual Bridge_intf)::set(null,"*","ins",ins);
 run_test();
 end
endmodule
