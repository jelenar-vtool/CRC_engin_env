class crc_virtual_sequencer extends uvm_sequencer  #(uvm_sequence_item);
  

    `uvm_component_utils(crc_virtual_sequencer)

    
    vr_master_sequencer seqr1;
    vr_slave_sequencer seqr2;
    apb_master_sequencer seqr3;


    function new(string name, uvm_component parent);
   	 super.new(name,parent);
    endfunction

endclass : crc_virtual_sequencer
