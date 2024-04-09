class vr_master_sequence extends uvm_sequence #(vr_item);

      vr_item req;
      vr_cfg cfg;
   `uvm_declare_p_sequencer(vr_master_sequencer)	
   `uvm_object_utils(vr_master_sequence)
  

    
  
    extern function new(string name = "vr_master_sequence"); 
    extern virtual task body();   
endclass : vr_master_sequence

//-------------------------------------------------------------------
function vr_master_sequence::new(string name = "vr_master_sequence");
    super.new(name);

endfunction : new

//-------------------------------------------------------------------
task vr_master_sequence::body();
  uvm_config_db#(vr_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(vr_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");

  for (int i=0; i<4; i++) begin

	`uvm_do(req);

  end 

   
endtask : body
//------------------------------------------------------------------------------------------------
class vr_slave_sequence#(int DATA = 32) extends uvm_sequence #(vr_item);
     vr_item req;  
      vr_item rsp;
      vr_cfg cfg;
   bit[DATA-1: 0] mem[$];

	rand int delay;
	 bit[2:0] error_flag = 0;
   `uvm_declare_p_sequencer(vr_slave_sequencer)	
   `uvm_object_utils(vr_slave_sequence#(  DATA ))
 constraint delay_bounds { 
delay inside {[0:10]};
}     
    extern function new(string name = "vr_slave_sequence"); 
    extern virtual task body();   
endclass : vr_slave_sequence

//-------------------------------------------------------------------
function vr_slave_sequence::new(string name = "vr_slave_sequence");
    super.new(name);
endfunction : new

//-------------------------------------------------------------------
task vr_slave_sequence::body();
   uvm_config_db#(vr_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(vr_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");
  for (int i=0; i<4; i++) begin
			`uvm_do(req)
  end
endtask : body
