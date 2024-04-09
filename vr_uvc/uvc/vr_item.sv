class vr_item#(int DATA = 32) extends uvm_sequence_item; 
    
  rand bit 				valid;
  rand bit[DATA-1:0] 	data; 
	   bit 				ready;
   rand bit [31:0] delay;
constraint del_c {delay<100;}

// * * * Register variables in factory * * * 
    `uvm_object_utils_begin(vr_item#(DATA)) 
	`uvm_field_int(valid, UVM_ALL_ON)
  	`uvm_field_int(data, UVM_ALL_ON)
  	`uvm_field_int(ready, UVM_ALL_ON)
	`uvm_field_int(delay, UVM_ALL_ON)

    `uvm_object_utils_end
    extern function new(string name = "vr_item");
endclass // vr_item

function vr_item::new(string name = "vr_item");
    super.new(name);
endfunction 
