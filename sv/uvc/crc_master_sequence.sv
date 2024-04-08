class crc_master_sequence extends uvm_sequence #(crc_item);
 
    `uvm_object_utils(crc_master_sequence)
    `uvm_declare_p_sequencer(crc_master_sequencer)
    
    extern function new(string name = "crc_master_sequence");
    
    extern virtual task pre_body();   
    extern virtual task body();   
    extern virtual task post_body();   

endclass // crc_master_sequence

//-------------------------------------------------------------------
function crc_master_sequence::new(string name = "b2gfifo_master_sequence");
    super.new(name);
endfunction //crc_master_sequence::new

//-------------------------------------------------------------------
task crc_master_sequence::body();

    repeat(5) begin
        `uvm_do(req)
	#40;
    end
endtask 

//-------------------------------------------------------------------
task crc_master_sequence::pre_body();
	
    uvm_test_done.raise_objection(this);
endtask

//-------------------------------------------------------------------
task crc_master_sequence::post_body();
    uvm_test_done.drop_objection(this);
endtask
