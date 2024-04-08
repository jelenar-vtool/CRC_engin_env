class crc_master_driver extends uvm_driver #(crc_item);
    
    //Register the driver class to the factory 
     `uvm_component_utils(crc_master_driver)

    //Declare the virtual interface handle 
    virtual crc_if crc_vif;

    crc_item req;
    crc_cfg cfg;
    bit reset_flag = 0;
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
    extern virtual task do_init();
    extern virtual task do_drive();
    
endclass : crc_master_driver

//-------------------------------------------------------------------------------------------------------------
function crc_master_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void crc_master_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info("build_phase","BUILD crc_MASTER_DRIVER",UVM_HIGH);
   
    //Retrieve the interface from the config_db 
	if(!uvm_config_db#(virtual crc_if)::get(this, "", "crc_vif", crc_vif)) begin
          `uvm_fatal("", "uvm_config_db::get failed")
       end

   
endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
task crc_master_driver::run_phase(uvm_phase phase);

fork
	forever begin
		@(negedge crc_vif.i_nreset);
		do_init();
		reset_flag =1;
		wait( crc_vif.i_nreset == 1);
		@(posedge crc_vif.i_clk);
	        reset_flag =0;
	end
      //change this, add begin end 
       	forever begin
		if(crc_vif.i_nreset == 0) begin 
			do_init();

		end 
		else begin
			seq_item_port.get_next_item( req );
			repeat(req.delay) @(posedge crc_vif.i_clk);
			wait(reset_flag == 0)
			do_drive();
			seq_item_port.item_done();
		end
	end 
	

join_none
endtask : run_phase

//-------------------------------------------------------------------------------------------------------------
task crc_master_driver::do_init();
 
    `uvm_info("Driver", "do_init task executed", UVM_LOW)
endtask : do_init

//-------------------------------------------------------------------------------------------------------------
task crc_master_driver::do_drive(); //najcesce aserseni ovde, da vide da li je drajver ispotovao protokol
    `uvm_info("Driver", "do_drive task is being executed", UVM_LOW)
  
   

endtask : do_drive
