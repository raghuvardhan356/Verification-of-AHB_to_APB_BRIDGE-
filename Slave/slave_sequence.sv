class slave_sequence extends uvm_sequence#(slave_xtn);
   `uvm_object_utils(slave_sequence)
    function new(string name="slave_sequence");
     super.new(name);
    endfunction
endclass

class slave_data extends slave_sequence;
  `uvm_object_utils(slave_data)
   function new(string name="slave_data");
    super.new(name);
   endfunction
  task body();
  `uvm_create(req)
   start_item(req);
   assert(req.randomize() with {req.Prdata==32'd256;});
   finish_item(req);
  endtask
endclass
   
