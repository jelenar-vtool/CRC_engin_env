class apb_emptread_test extends  apb_base_sqr_test;


   `uvm_component_utils(apb_emptread_test)
    apb_env env;


    extern function new (string name, uvm_component parent);
    extern  function void build_phase (uvm_phase phase);
    extern  task run_phase (uvm_phase phase);
   
endclass : apb_emptread_test
     function  apb_emptread_test::new(string name = "apb_emptread_test", uvm_component parent);
	super.new(name,parent);
    endfunction : new

     function void apb_emptread_test::build_phase(uvm_phase phase);
	uvm_factory factory= uvm_factory::get();
        super.build_phase(phase);
        //set_specific_configuration();
     set_type_override_by_type(apb_master5_sequence::get_type(), apb_master_emptread_sequence::get_type());

    endfunction : build_phase


  task apb_emptread_test::run_phase(uvm_phase phase);

        super.run_phase(phase);
endtask : run_phase
