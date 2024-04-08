class crc_env_cfg extends uvm_object;       


      crc_cfg   cfg;
       bit                     ms_has_checks;
       bit                     ms_has_coverage;



    `uvm_object_utils_begin(crc_env_cfg)
      `uvm_field_object (cfg, UVM_ALL_ON)
      `uvm_field_int  (ms_has_checks, UVM_ALL_ON)
      `uvm_field_int  (ms_has_coverage, UVM_ALL_ON)
   `uvm_object_utils_end


    function new(string name = "crc_env_cfg");
    	super.new(name);

        cfg = crc_cfg::type_id::create ("cfg");

    endfunction
    

  /* function void set_default_config(); 
	cfg.set_default_config();
     ms_has_checks=0;
     ms_has_checks=1;
   endfunction */
endclass

//-------------------------------------------------------------------------------------------------------------

