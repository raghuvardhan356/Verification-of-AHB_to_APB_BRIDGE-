interface Bridge_intf (input bit clk);
 logic Hresetn;
 logic [1:0]Htrans;
 logic [2:0]Hsize;
 logic Hwrite;
 logic Hreadyin;
 logic Hreadyout;
 logic [1:0]Hresp;
 logic [31:0]Hwdata;
 logic [31:0]Hrdata;
 logic [31:0]Haddr;
 logic Penable;
 logic Pwrite;
 logic [31:0]Paddr;
 logic [31:0]Prdata;
 logic [31:0]Pwdata;
 logic [3:0]Pselx;
 
 //master driver clocking block
 clocking mst_drv_cb @(posedge clk);
 default input #1 output #1;
 output Hresetn;
 output Htrans;
 output Hsize;
 output Hwrite;
 output Hreadyin;
 output Hwdata;
 output Haddr;
 input  Hreadyout;
 input Hresp;
 endclocking
 
 //master monitor clocking block
 clocking mst_mon_cb @(posedge clk);
 default input #1 output #1;
 input Hresetn;
 input Htrans;
 input Hsize;
 input Hwrite;
 //input Hreadyin;
 input Hwdata;
 input Haddr;
 input Hreadyout;
 input Hreadyin;
 input Hrdata;
 endclocking
 
 //slvae driver clocking block
 clocking slv_drv_cb@(posedge clk);
 default input #1 output #1;
 output Prdata;
 input Pselx;
 input Penable;
 input Pwrite;
 endclocking
 
 //slave monitor clocking block
 clocking slv_mon_cb@(posedge clk);
 default input #1 output #1;
// input Penable;
 input Penable;
 input Paddr;
 input Pwrite;
 input Pwdata;
 input Prdata;
 input Pselx;
 endclocking

 modport mst_drv_mp(import mst_drv_cb);
 modport mst_mon_mp(import mst_mon_cb);
 modport slv_drv_mp(import slv_drv_cb);
 modport slv_mon_mp(import slv_mon_cb);
endinterface
 
