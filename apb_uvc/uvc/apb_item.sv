
class apb_item#(int ADDR = 32, int DATA = 32) extends uvm_sequence_item; 
    
  rand bit   [ADDR-1:0] addr;      //Address
  rand bit [DATA-1:0] wdata;     //Data - For write or read response
   bit [DATA-1:0] rdata;     //Data - For write or read response
  rand bit  pwrite;       //command type
  rand bit psel;
  rand 	bit  penable;
   	bit  pready;
  rand bit[2:0] pprot;
   rand bit [31:0] delay;
   bit pslverr;
  rand bit  [(DATA/4)-1:0] pstrobe;
constraint strb_c { if (pwrite==0) pstrobe ==0;} 
constraint del_c {delay<10;}

// * * * Register variables in factory * * * 
    `uvm_object_utils_begin(apb_item#(ADDR,DATA)) 
	`uvm_field_int(addr, UVM_ALL_ON)
  	`uvm_field_int(wdata, UVM_ALL_ON)
  	`uvm_field_int(rdata, UVM_ALL_ON)
	`uvm_field_int(pwrite, UVM_ALL_ON)
  	`uvm_field_int(psel, UVM_ALL_ON)
	`uvm_field_int(penable, UVM_ALL_ON)
        `uvm_field_int(pready, UVM_ALL_ON)
	`uvm_field_int(pprot, UVM_ALL_ON)
	`uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end
    extern function new(string name = "apb_item");
endclass // apb_item

function apb_item::new(string name = "apb_item");
    super.new(name);
endfunction 

