class crc_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(b2gfifo_virtual_sequence)
   `uvm_declare_p_sequencer(crc_virtual_sequencer)

   crc_master_sequence seq1;
 
    extern function new(string name = "crc_virtual_sequence");
    extern virtual task pre_body();
    extern virtual task body();   
    extern virtual task post_body();
endclass : crc_virtual_sequence

//-------------------------------------------------------------------
function crc_virtual_sequence::new(string name = "crc_virtual_sequence");
    super.new(name);
endfunction : new

//-------------------------------------------------------------------
  task crc_virtual_sequence::pre_body();
    // raise objection if started as a root sequence
    if(starting_phase != null)
      starting_phase.raise_objection(this);
  endtask

task crc_virtual_sequence::body();

	fork 
	  
	
	`uvm_do_on(seq1, p_sequencer.seqr1) 
	 

	  
	join_any

endtask : body
 task crc_virtual_sequence::post_body();
    // drop objection if started as a root sequence
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
