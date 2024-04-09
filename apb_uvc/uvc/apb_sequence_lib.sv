
class apb_master5_sequence extends uvm_sequence #(apb_item);

      apb_item req;
      apb_cfg cfg;
   `uvm_declare_p_sequencer(apb_master_sequencer)	
   `uvm_object_utils(apb_master5_sequence)
  

    
  
    extern function new(string name = "apb_master5_sequence"); 
    extern virtual task body();   
endclass : apb_master5_sequence

//-------------------------------------------------------------------
function apb_master5_sequence::new(string name = "apb_master5_sequence");
    super.new(name);

endfunction : new

//-------------------------------------------------------------------
task apb_master5_sequence::body();
  uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");

   for(int i=0; i<5; i=i+1) begin

	`uvm_do_with(req, {pwrite==1;});


   end 
  for(int j=0; j<5; j=j+1) begin

	`uvm_do_with(req, {pwrite==0;});


   end 

   
endtask : body
//------------------------------------------------------------------------------------------------
class apb_slave_empty_sequence#(int ADDR = 32, int DATA = 32) extends uvm_sequence #(apb_item);
        apb_item req;  
      apb_item rsp;
      apb_cfg cfg;
   bit[DATA-1: 0] mem[bit [DATA-1:0]];
	logic rw;
	rand int delay;
	 bit[2:0] error_flag = 0;
   `uvm_declare_p_sequencer(apb_slave_sequencer)	
   `uvm_object_utils(apb_slave_empty_sequence#( ADDR, DATA ))
 constraint delay_bounds { 
delay inside {[0:10]};
}     

    
  
    extern function new(string name = "apb_slave_empty_sequence"); 
    extern virtual task body();   
endclass : apb_slave_empty_sequence

//-------------------------------------------------------------------
function apb_slave_empty_sequence::new(string name = "apb_slave_empty_sequence");
    super.new(name);
endfunction : new

//-------------------------------------------------------------------
task apb_slave_empty_sequence::body();
   uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");
forever begin 
	req = apb_item::type_id::create("req"); 
	rsp = apb_item::type_id::create("rsp");

	// Slave request: 
	start_item(req); 
	finish_item(req);
	 
	start_item(rsp);



		rsp.pwrite = req.pwrite;
	  
	if(req.pwrite)begin 

		     mem[req.addr] =  req.wdata;  
	end 
	else if(req.pwrite==0) begin 

			error_flag=error_flag+1;
		`uvm_info("error_flag", $sformatf("error_flag = %h", error_flag), UVM_LOW)  
			rsp.rdata = mem[req.addr];
			`uvm_info("slave", $sformatf("paddrSQR = %h", req.addr), UVM_LOW) 
			`uvm_info("slave", $sformatf("paddrSQRprdata = %h",  mem[req.addr]), UVM_LOW) 
			`uvm_info("slave", $sformatf("prdataSQR = %h", rsp.rdata), UVM_LOW) 
        		if(error_flag==7)	begin 
			rsp.pslverr=1;
			end else begin 	
			rsp.pslverr=0;			

			end	
	end 

		req.pslverr = rsp.pslverr;
   	 
finish_item(rsp);
end
endtask : body
//----------------------------------------------------------------------------------------
class apb_master_emptread_sequence extends apb_master5_sequence;

      apb_item req;
      apb_cfg cfg;
   `uvm_declare_p_sequencer(apb_master_sequencer)	
   `uvm_object_utils(apb_master_emptread_sequence)
  

    
  
    extern function new(string name = "apb_master_emptread_sequence"); 
    extern virtual task body();   
endclass : apb_master_emptread_sequence

//-------------------------------------------------------------------
function apb_master_emptread_sequence::new(string name = "apb_master_emptread_sequence");
    super.new(name);

endfunction : new

//-------------------------------------------------------------------
task apb_master_emptread_sequence::body();
	`uvm_do_with(req, {pwrite==0;});
       for(int i=0; i<5; i=i+1) begin

	`uvm_do_with(req, {pwrite==1;});


   end 
  for(int j=0; j<5; j=j+1) begin

	`uvm_do_with(req, {pwrite==0;});


   end 
 endtask : body
//----------------------------------------------------------------------------------------
class apb_master_error_sequence extends apb_master5_sequence;

      apb_item req;
      apb_cfg cfg;
   `uvm_declare_p_sequencer(apb_master_sequencer)	
   `uvm_object_utils(apb_master_error_sequence)

  
    extern function new(string name = "apb_master_error_sequence"); 
    extern virtual task body();   
endclass : apb_master_error_sequence

//-------------------------------------------------------------------
function apb_master_error_sequence::new(string name = "apb_master_error_sequence");
    super.new(name);

endfunction : new

//-------------------------------------------------------------------
task apb_master_error_sequence::body();
int max_attempts = 3;
      int attempts = 0;
  uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");

 
  
  uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");
 for (int i = 0; i < 10; i++) begin
 	`uvm_do_with(req, {pwrite==1;}); 
end
	//`uvm_do_with(req, {pwrite==0;}); //read fro empty
      for (int i = 0; i < 10; i++) begin

 while (attempts < max_attempts) begin
         // Attempt the operation
	`uvm_do_with(req, {pwrite==0;}); //read fro empty
		`uvm_info("pslverr", $sformatf("pslverrMASTER = %h", req.pslverr), UVM_LOW)  
         // Check if an error_flag is set in the transaction item
         if (req.pslverr ==1) begin
            `uvm_info("1","Error detected, retrying...", UVM_LOW);
            attempts++;
         end else begin
            // Successful operation, exit the loop
           `uvm_info("2","Operation successful!",UVM_LOW);
       attempts = 0;
            break;
         end
      end
	end 
endtask : body
//----------------------------------------------------------------------------------------
class apb_master_random_sequence extends apb_master5_sequence;

      apb_item req;
      apb_cfg cfg;
   `uvm_declare_p_sequencer(apb_master_sequencer)	
   `uvm_object_utils(apb_master_random_sequence)
    rand int number_of_transactions;
  
    extern function new(string name = "apb_master_random_sequence"); 
    extern virtual task body();   
endclass : apb_master_random_sequence

//-------------------------------------------------------------------
function apb_master_random_sequence::new(string name = "apb_master_random_sequence");
    super.new(name);

endfunction : new

//-------------------------------------------------------------------
task apb_master_random_sequence::body();
uvm_config_db#(apb_cfg)::set(null, "*", "cfg", p_sequencer.cfg);
    if (!uvm_config_db#(apb_cfg)::get(p_sequencer,"", "cfg",cfg))
        `uvm_fatal("body", "cfg wasn't set through config db");
 number_of_transactions = $urandom_range(150,100);
	`uvm_do_with(req, {pwrite==1; wdata==0; addr==0;});
	`uvm_do_with(req, {pwrite==1; wdata==32'hffffffff ; addr==32'hffffffff ;});
	`uvm_do_with(req, {pwrite==0; addr==0;});
	`uvm_do_with(req, {pwrite==0; addr==32'hffffffff ;});
    for (int i = 0; i < number_of_transactions; i++) begin
		`uvm_do(req); 
	end 
endtask : body
