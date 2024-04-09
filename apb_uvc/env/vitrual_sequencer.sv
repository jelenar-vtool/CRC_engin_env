class virtual_sequencer extends uvm_sequencer  #(uvm_sequence_item);
   
    `uvm_component_utils(virtual_sequencer)

    
	apb_master_sequencer seqr1;
	apb_slave_sequencer seqr2;
  

    function new(string name, uvm_component parent);
   	 super.new(name,parent);
    endfunction

endclass : virtual_sequencer
