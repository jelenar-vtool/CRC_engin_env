class apb_master_driver#(int ADDR = 32, int DATA = 32) extends uvm_driver #(apb_item);
    
    `uvm_component_utils(apb_master_driver#(ADDR,DATA))
    virtual apb_if#(ADDR, DATA)   apb_vif;
    apb_item req;
    apb_cfg    cfg;
    bit reset_flag = 0;
    bit[DATA-1: 0] addr_q[$];	
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase (uvm_phase phase);
    extern virtual task  do_init ();
    extern virtual task  reset_on_the_fly();
    extern virtual task  do_drive(apb_item req);
        extern virtual task  write_trans();
    extern virtual task  read_trans();
endclass // apb_master_driver

//-------------------------------------------------------------------------------------------------------------
function apb_master_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction // apb_master_driver::new

//-------------------------------------------------------------------------------------------------------------
function void apb_master_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info("build_phase","BUILD apb_MASTER_DRIVER",UVM_HIGH);
    if(!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "", "apb_vif", apb_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ", get_full_name(),".apb_vif"});
    if (!uvm_config_db#(apb_cfg)::get(this, "", "cfg", cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end
endfunction // apb_master_driver::build_phase

//-------------------------------------------------------------------------------------------------------------
task apb_master_driver::run_phase(uvm_phase phase);
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
			////func/task if(req.slverr == 1) 
					//ponovo posalji trans
					//provera dal je sve dobro nameston 
					//do drive
        seq_item_port.item_done();  

    end   // of forever
endtask// apb_master_driver::run_phase

//-------------------------------------------------------------------------------------------------------------
task apb_master_driver::do_init();
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
    @(posedge apb_vif.system_clock);
    `uvm_info("Driver", "MASTER-do_init task executed", UVM_LOW)
endtask

task apb_master_driver::do_drive(apb_item req);
// * * * Write driving logic here * * *
	@(posedge apb_vif.system_clock); 
	    	 apb_vif.psel<=1;
	case (req.pwrite)
	1:write_trans(); 
	0: read_trans();
	endcase 
     `uvm_info("Driver", "MASTER-do_drive task executed", UVM_LOW)
endtask


task apb_master_driver::reset_on_the_fly();
    // * * * Leave this untoched if planning to implement Reset on the fly feature. If not delete it. * * *
    @(negedge apb_vif.reset_n);
    reset_flag = 1;
endtask

task apb_master_driver::write_trans();
    `uvm_info("Driver-MASTER", "write trans", UVM_LOW)

        addr_q.push_back(req.addr);
        apb_vif.pwdata<=req.wdata;
        apb_vif.pwrite<=req.pwrite;
	apb_vif.paddr<=req.addr;
	apb_vif.pprot<=req.pprot;
	apb_vif.pstrobe<=req.pstrobe;
		`uvm_info("master", $sformatf("paddr = %h", apb_vif.paddr), UVM_LOW) 
		`uvm_info("smaster", $sformatf("pwdata = %h", apb_vif.pwdata), UVM_LOW) 
	    @(posedge apb_vif.system_clock );  
		apb_vif.penable<=1;

    `uvm_info("Driver-MASTER", "enale trans", UVM_LOW)
	@(posedge apb_vif.system_clock iff (apb_vif.pready == 1 && apb_vif.penable == 1));  
			apb_vif.penable <=0; 
			apb_vif.psel<= 0;
		req.pslverr = apb_vif.pslverr;
		 
	 
endtask
task apb_master_driver::read_trans();
    `uvm_info("Driver", "MASTER-read trans", UVM_LOW)

	addr_q.shuffle();
    //`uvm_info("master-adresa za que", $sformatf("paddr = %h",addr_q.pop_front()), UVM_LOW)
	apb_vif.paddr<=addr_q.pop_front();
		`uvm_info("master", $sformatf("paddr = %h", apb_vif.paddr), UVM_LOW) 
        apb_vif.pwrite<=req.pwrite;
	apb_vif.pprot<=req.pprot;
	apb_vif.pstrobe<=req.pstrobe;  //read transaction
	    @(posedge apb_vif.system_clock ); 
	    	apb_vif.penable<=1;

		//wait  (apb_vif.pready ==1 && apb_vif.penable==1) 
		//apb_vif.prdata <=req.rdata; //nes ovde nije dobro 
	@(posedge apb_vif.system_clock iff (apb_vif.pready == 1 && apb_vif.penable == 1));  
			apb_vif.penable <=0; 
			apb_vif.psel<= 0;
		req.pslverr = apb_vif.pslverr;
endtask
