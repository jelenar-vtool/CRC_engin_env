class virtual_sequence extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(virtual_sequence)
   `uvm_declare_p_sequencer(virtual_sequencer)
	

    apb_master5_sequence seq1;
    apb_slave_empty_sequence seq2;
    extern function new(string name = "virtual_sequence");
    extern virtual task pre_body();
    extern virtual task body();   
    extern virtual task post_body();
endclass : virtual_sequence

//-------------------------------------------------------------------
function virtual_sequence::new(string name = "virtual_sequence");
    super.new(name);
endfunction : new

//-------------------------------------------------------------------
  task virtual_sequence::pre_body();
    // raise objection if started as a root sequence
    if(starting_phase != null)
      starting_phase.raise_objection(this);
  endtask

task virtual_sequence::body();
fork 
	  
	
	`uvm_do_on(seq1, p_sequencer.seqr1) 
	 
	`uvm_do_on(seq2, p_sequencer.seqr2) 
	  
join_any
endtask : body
 task virtual_sequence::post_body();
    // drop objection if started as a root sequence
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
