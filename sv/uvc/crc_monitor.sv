class crc_monitor extends uvm_monitor; 
   
  

   `uvm_component_utils(crc_monitor)
    //Declare the virtual interface handle
     virtual crc_if crc_vif;

    crc_item req;
    uvm_analysis_port#(crc_item)   crc_mon_analysis_port;
    crc_cfg cfg;
	

    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase(uvm_phase phase);  
    
endclass // crc_monitor

//-------------------------------------------------------------------------------------------------------------//-------------------------------------------------------------------------------------------------------------
function crc_monitor::new (string name, uvm_component parent);
    super.new(name, parent);
    req = crc_item::type_id::create("req");

    crc_mon_analysis_port = new("crc_mon_analysis_port", this);
  
endfunction   

//-------------------------------------------------------------------------------------------------------------
function void crc_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual crc_if)::get(this, "", "crc_vif", crc_vif)) begin
      `uvm_fatal(get_type_name(),"NOVIF: call to uvm_config_db get method failed\n");
    end

  if(!uvm_config_db #(crc_cfg)::get(this, "", "cfg", cfg)) begin 
       `uvm_fatal("", "Failed to get configuration object !");
    end

endfunction

//-------------------------------------------------------------------------------------------------------------
task crc_monitor::run_phase(uvm_phase phase);

	
  super.run_phase(phase);
forever begin
     @ (negedge crc_vif.i_clk);


    `uvm_info("Monitor", "monitor in run phase", UVM_LOW)

    
	
  end 
	 
endtask
