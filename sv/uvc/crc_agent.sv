`ifndef AGENT
`define AGENT

class crc_agent extends uvm_agent;
    //Register the agent class to the factory * * *

    // Declare the agent subcomponents * * *
      crc_master_driver    driver;
      crc_master_sequencer sequencer;
      crc_monitor   m_monitor;
    //Declare the agent's configuration object (cfg) * * *
     virtual crc_if crc_vif;
     crc_cfg cfg;

      `uvm_component_utils(crc_agent)

    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    
endclass : crc_agent

//-------------------------------------------------------------------------------------------------------------
function crc_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void crc_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

  
    if(!uvm_config_db #(virtual crc_if )::get(this, "", "crc_vif", crc_vif)) begin 
       `uvm_fatal("", "Failed to get virtual_interface !");
    end  

// get configuration 
   /* if(!uvm_config_db #(crc_cfg)::get(this, "", "cfg", cfg)) begin 
       `uvm_fatal("", "Failed to get configuration object !");
    end */

 // create components
    if(cfg.c_is_active == UVM_ACTIVE) begin
      driver = crc_master_driver::type_id::create("driver", this);
      sequencer = crc_master_sequencer::type_id::create("sequencer", this);
    end

    m_monitor = crc_monitor::type_id::create("m_monitor", this);

endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
function void crc_agent::connect_phase(uvm_phase phase);

 super.connect_phase(phase); 


  if (cfg.c_is_active == UVM_ACTIVE) begin 
     driver.seq_item_port.connect(sequencer.seq_item_export); 
  end 


  if (cfg.c_is_active == UVM_ACTIVE) begin 
     driver.crc_vif=crc_vif; 
  end 

  m_monitor.crc_vif = crc_vif; 

a
  if (cfg.c_is_active == UVM_ACTIVE) begin 
    driver.cfg = cfg; 
    sequencer.cfg = cfg; 
  end 
  m_monitor.cfg = cfg; 

endfunction : connect_phase

`endif
