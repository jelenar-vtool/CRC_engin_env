class crc_virtual_sequencer extends uvm_sequencer  #(uvm_sequence_item);
  

    `uvm_component_utils(crc_virtual_sequencer)

    
    crc_master_sequencer seqr1;
    //b2gfifo_env       	    p_env; // if pointer to env is needed



    function new(string name, uvm_component parent);
   	 super.new(name,parent);
    endfunction

endclass : crc_virtual_sequencer
