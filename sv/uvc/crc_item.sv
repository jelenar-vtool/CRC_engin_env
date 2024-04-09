class crc_item extends uvm_sequence_item; 
    
   rand bit i_reg_apb_pse;
   rand bit [31:0] delay;

   `uvm_object_utils_begin (crc_item)
	`uvm_field_int(i_reg_apb_pse, UVM_ALL_ON)
	`uvm_field_int(delay, UVM_ALL_ON)  	
  	
   `uvm_object_utils_end
 	extern function new(string name = "crc_item"); 
	


endclass : crc_item

function crc_item::new(string name = "crc_item");
    super.new(name);
endfunction : new
