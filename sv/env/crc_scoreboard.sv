`uvm_analysis_imp_decl(_master)
//------------------------------------------------------------------------------------------------------------
class crc_scoreboard extends uvm_scoreboard;

    //Add scoreboard to factory
      `uvm_component_utils (crc_scoreboard)
     crc_item req;

   
     virtual crc_if crc_vif;
     uvm_analysis_imp_master #(crc_item, crc_scoreboard) m_ap;    
    extern function new(string name = "", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void write_master (crc_item req);
    extern task run_phase (uvm_phase phase);
    //extern function void phase_ready_to_end(uvm_phase phase);
  
endclass

//------------------------------------------------------------------------------------------------------------
function crc_scoreboard::new(string name = "", uvm_component parent);
    super.new(name,parent);


endfunction

//------------------------------------------------------------------------------------------------------------
function void crc_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual crc_if )::get(this, "", "crc_vif", crc_vif)) begin 
       `uvm_fatal("", "Failed to get virtual_interface !");
    end
      m_ap= new("m_ap", this);
  
endfunction    

//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_master (crc_item req);

`uvm_info("SCOREBOARD", "uso u write", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
/*function void crc_scoreboard::phase_ready_to_end(uvm_phase phase);
 if (phase.get_name() != "run") return;
 if (refr_fifo.size() != 0) begin

  `uvm_fatal ("phase_ready_to_end","queue not empty")
 end
endfunction*/


       
task crc_scoreboard:: run_phase (uvm_phase phase);
`uvm_info("SCOREBOARD", "uso u run", UVM_LOW)
endtask
