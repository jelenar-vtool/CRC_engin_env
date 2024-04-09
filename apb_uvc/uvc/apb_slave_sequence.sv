
class apb_slave_sequence extends uvm_sequence #(apb_item);
 
    `uvm_object_utils(apb_slave_sequence)
    `uvm_declare_p_sequencer(apb_slave_sequencer)
    apb_cfg cfg;
    extern function new(string name = "apb_slave_sequence");
    extern virtual task body();  
endclass // apb_slave_sequence

//-------------------------------------------------------------------
function apb_slave_sequence::new(string name = "apb_slave_sequence");
    super.new(name);
endfunction //apb_sequence::new

//-------------------------------------------------------------------
task apb_slave_sequence::body();
    
    uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");

	// * * * uvm_do or uvm_do_with can be used * * * 

  
    `uvm_do(req)



endtask 

