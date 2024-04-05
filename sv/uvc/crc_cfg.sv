class crc_cfg extends uvm_object;  


  uvm_active_passive_enum c_is_active;
    bit                   has_coverage;

  virtual crc_if crc_vif;
  `uvm_object_utils_begin(crc_cfg)
    `uvm_field_enum (uvm_active_passive_enum, c_is_active, UVM_ALL_ON)
    `uvm_field_int  (has_coverage,                       UVM_ALL_ON)
  `uvm_object_utils_end
    


    
   extern function new(string name = "crc_cfg");
    

   function void set_default_config();
	c_is_active= UVM_ACTIVE;
	has_coverage =1;
   endfunction 

endclass : crc_cfg

//-------------------------------------------------------------------------------------------------------------
function crc_cfg::new(string name = "crc_cfg");
    super.new(name);
endfunction : new
