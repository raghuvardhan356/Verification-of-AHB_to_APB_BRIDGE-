class base_sequence extends uvm_sequence#(master_xtn);
	`uvm_object_utils(base_sequence)
	
	bit [31:0]haddr,starting_addr,boundary_addr;
	bit [2:0]hburst, hsize;
	bit hwrite;
	bit [9:0]hlength;
	

	function new(string name = "base_sequence");
		super.new(name);
	endfunction

endclass

class single_trans extends base_sequence;
	`uvm_object_utils(single_trans)

	function new(string name = "single_trans");
		super.new(name);
	endfunction

	task body();
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans == 2'b10; Hburst == 3'b0;});
		finish_item(req);
	endtask
endclass

class incr_trans extends base_sequence;
	`uvm_object_utils(incr_trans)
	
	function new(string name = "incr_trans");
		super.new(name);
	endfunction

	task body();
        repeat(10)
        begin
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans == 2'b10;Hburst inside {1,3,5,7};});// Hburst==1;}
               // req.print();
		finish_item(req);

		haddr = req.Haddr;
		hsize = req.Hsize;
		hburst = req.Hburst;
		hwrite = req.Hwrite;
		hlength = req.length;

		for(int i=1; i<hlength; i++)
		begin
			start_item(req);
			assert(req.randomize() with {Hwrite == hwrite; Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Haddr == haddr+(2**hsize);});
                       // req.print();
			finish_item(req);
			haddr = req.Haddr;
		end
         end
	endtask

endclass

class wrap_trans extends base_sequence;
	`uvm_object_utils(wrap_trans)

	function new(string name = "wrap_trans");
		super.new(name);
	endfunction

	task body();
        repeat(10)
        begin
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans == 2'b10; Hburst inside {2,4,6};});
		finish_item(req);

		haddr = req.Haddr;
		hsize = req.Hsize;
		hburst = req.Hburst;
		hwrite = req.Hwrite;
		hlength = req.length;
		starting_addr = int'(haddr/(hlength*(2**hsize)))*(hlength*(2**hsize));
               boundary_addr = starting_addr+((2**hsize)*hlength);
               $display("boundar addr = %0d",boundary_addr);
               haddr = req.Haddr+(2**hsize);
               for(int i=1;i<hlength;i++)
               begin
                  if(haddr==boundary_addr)
                      haddr=starting_addr;	
               start_item(req);
               assert(req.randomize() with{Haddr==haddr;Htrans==2'b11;Hwrite == hwrite; Hsize == hsize; Hburst == hburst;});
               finish_item(req);
               haddr=req.Haddr+(2**hsize);
               end
               end
       endtask
endclass
