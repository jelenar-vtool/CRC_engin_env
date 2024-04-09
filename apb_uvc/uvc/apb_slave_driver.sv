
class apb_slave_driver#(int ADDR = 32, int DATA = 32) extends uvm_driver #(apb_item);
    
    `uvm_component_utils(apb_slave_driver#(ADDR,DATA))
    virtual apb_if#(ADDR, DATA)   apb_vif;
    apb_item req;
    apb_cfg    cfg; 
    bit[DATA-1: 0] mem[bit [DATA-1:0]];

    bit reset_flag = 0;
    bit error_flag = 0;
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase (uvm_phase phase);
    extern virtual task  do_init ();
    extern virtual task  reset_on_the_fly();
    extern virtual task  do_drive(apb_item req);
          extern virtual task  write_trans();
    extern virtual task  read_trans();
endclass // apb_slave_driver

//-------------------------------------------------------------------------------------------------------------
function apb_slave_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction // apb_slave_driver::new

//-------------------------------------------------------------------------------------------------------------
function void apb_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info("build_phase","BUILD apb_slave_DRIVER",UVM_HIGH);
    if(!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "", "apb_vif", apb_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ", get_full_name(),".apb_vif"});
    if (!uvm_config_db#(apb_cfg)::get(this, "", "cfg", cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end
endfunction // apb_slave_driver::build_phase

//-------------------------------------------------------------------------------------------------------------
task apb_slave_driver::run_phase(uvm_phase phase);
    do_init();
	@(posedge apb_vif.reset_n);
	repeat(3) @(posedge apb_vif.system_clock);

	
    forever begin 
        seq_item_port.get_next_item(req);

        // delete if bellow if UVC dosen't have reset on fly feature 
        if (reset_flag) begin 
    do_init();
            @(posedge apb_vif.reset_n); // wait for reset to end
	        repeat(3) @(posedge apb_vif.system_clock); // wait 3 more clock cycles, just to be sure we're stable
            reset_flag = 0;
        end

        fork 
           reset_on_the_fly(); // delete this and fork if UVC dosen't have reset on fly feature
            do_drive(req);
        join_any
        disable fork;
			
        seq_item_port.item_done();  

    end   // of forever
endtask// apb_slave_driver::run_phase

//-------------------------------------------------------------------------------------------------------------
task apb_slave_driver::do_init();
// * * * Write initial values for your signals here * * *
 	apb_vif.psel=0;
	apb_vif.penable=0;
	apb_vif.pready=0;
	apb_vif.pwrite=0;
	apb_vif.pprot=0;
	apb_vif.pslverr=0;
	apb_vif.pstrobe=0;
	 apb_vif.pwdata=0;
	apb_vif.prdata=0;
	 apb_vif.paddr=0;
    @(posedge apb_vif.system_clock);  `uvm_info("Driver", "SLAVE-do_init task executed", UVM_LOW)
endtask

task apb_slave_driver::do_drive(apb_item req);
// * * * Write driving logic here * * *r

	@(posedge apb_vif.system_clock iff (apb_vif.psel));
	

 	if (cfg.has_delay == 1) 
		repeat (req.delay+1)
	   		apb_vif.pready<=1;
		#1;//ovo ne trebao ovako, ali za sad samo ovako lepo hvata
	if(!(apb_vif.driver_sync.psel && apb_vif.driver_sync.penable &&  apb_vif.driver_sync.pready))begin  
		apb_vif.pslverr<=1;
		error_flag = 1;
		`uvm_info("error flag", "error flag set", UVM_LOW)
		
	 end  
 		`uvm_info("slave", $sformatf("psel = %h", apb_vif.psel), UVM_LOW) 
		`uvm_info("slave", $sformatf("penable = %h", apb_vif.penable), UVM_LOW) 
		`uvm_info("slave", $sformatf("pready = %h", apb_vif.pready), UVM_LOW) 
	case (apb_vif.pwrite)//uslov za selektoanje
	1:write_trans(); 
	0: read_trans();
	endcase 
     `uvm_info("Driver", "SLAVE-do_drive task executed", UVM_LOW)
endtask


task apb_slave_driver::reset_on_the_fly();
    // * * * Leave this untoched if planning to implement Reset on the fly feature. If not delete it. * * *
    @(negedge apb_vif.reset_n);
    reset_flag = 1;
endtask
task apb_slave_driver::write_trans();
    `uvm_info("Driver-SLAVE", "write trans", UVM_LOW)
			 
	 if (error_flag==0) begin 
	 	//@(posedge apb_vif.system_clock)

          	mem[apb_vif.paddr] =  apb_vif.pwdata;  
	end else if (error_flag==1) begin 
    `uvm_info("Driver-SLAVE", "corruped data is being written to protocol", UVM_LOW)
	        mem[apb_vif.paddr] =  apb_vif.pwdata; 
	end 

	 @(posedge apb_vif.system_clock); 
		apb_vif.pready<=0;										
	apb_vif.pslverr<=0;
	error_flag=0;
endtask
task apb_slave_driver::read_trans();
    `uvm_info("Driver-SLAVE", "read trans", UVM_LOW)


	 if (error_flag==0) begin 
		
		apb_vif.prdata <= mem[apb_vif.paddr];
		`uvm_info("slave", $sformatf("paddr = %h", apb_vif.paddr), UVM_LOW) 
		`uvm_info("slave", $sformatf("prdata = %h", apb_vif.pwdata), UVM_LOW) 
	end else if (error_flag==1) begin 
    `uvm_info("Driver-SLAVE", "corruped data is being read from protocol", UVM_LOW)
		apb_vif.prdata <= mem[apb_vif.paddr];
	
	end
	 @(posedge apb_vif.system_clock); 
		apb_vif.pready<=0;	
	apb_vif.pslverr<=0;	
	error_flag=0;									
endtask												

