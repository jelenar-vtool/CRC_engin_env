
class apb_monitor#(int ADDR = 32, int DATA = 32) extends uvm_monitor; 
   
   `uvm_component_utils(apb_monitor#(ADDR,DATA))

    virtual apb_if#(ADDR, DATA) apb_vif;
   
    //apb_coverage#(ADDR, DATA)    cov;
    apb_item#(ADDR, DATA)   req;

    apb_cfg         apb1_cfg;
   
    int counter;
    uvm_analysis_port#(apb_item#(ADDR,DATA))   apb_mon_analysis_port;
    uvm_analysis_port#(apb_item#(ADDR,DATA))   apb_s_analysis_port;
	
   
    bit reset_flag = 0;
    
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase(uvm_phase phase);  
    extern virtual task  do_monitor();
    extern virtual task  reset_on_the_fly();
    
endclass // apb_monitor_class

//-------------------------------------- 
//-----------------------------------------------------------------------
function apb_monitor::new (string name, uvm_component parent);
    super.new(name, parent);
    req = apb_item#(ADDR,DATA)::type_id::create("req", this);
endfunction   

//-------------------------------------------------------------------------------------------------------------
function void apb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase","BUILD apb_MONITOR",UVM_MEDIUM);
    if(!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "", "apb_vif", apb_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ",get_full_name(),".apb_vif"});

    if (!uvm_config_db#(apb_cfg)::get(this, "", "apb1_cfg",apb1_cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end
	
    apb_mon_analysis_port = new("apb_mon_analysis_port",this);
 
   /* if (cfg.has_coverage) begin
        cov = apb_coverage#(ADDR ,DATA)::type_id::create("cov",this);
        //cov.cfg = this.cfg;
    end */ 


    if (!apb1_cfg.has_checks)   
        `uvm_info("build_phase","CHECKERS DISABLED",UVM_LOW);
endfunction

//-------------------------------------------------------------------------------------------------------------
task  apb_monitor::run_phase(uvm_phase phase);
    
	//wait for reset
	@(posedge apb_vif.reset_n);
	repeat(3) @(posedge apb_vif.system_clock);
    forever begin
	
      // delete if bellow if UVC dosen't have reset on fly feature
      if (reset_flag) begin
            @(posedge apb_vif.reset_n); // wait for reset to end
	        repeat(3) @(posedge apb_vif.system_clock); // wait 3 more clock cycles, just to be sure we're stable
            reset_flag = 0;
        end

        fork 
            reset_on_the_fly(); // delete this and fork if UVC dosen't have reset on fly feature
            do_monitor();
        join_any
        disable fork;
    end // of forever       
endtask


//-------------------------------------------------------------------------------------------------------------
task apb_monitor::reset_on_the_fly();  
    // * * * Leave this untoched if planning to implement Reset on the fly feature. If not delete it. * * *   
    @(negedge apb_vif.reset_n);
    reset_flag = 1;
    `uvm_info("MONITOR","ASYNCHRONOUS RESET HAPPENED", UVM_LOW)
    
endtask //reset_on_the_fly*/

task apb_monitor::do_monitor();

    @(posedge apb_vif.system_clock iff  (apb_vif.penable && apb_vif.pready));  
	req.psel=apb_vif.psel;
	req.pready=apb_vif.pready;
	req.pwrite=apb_vif.pwrite;
	req.pprot=apb_vif.pprot;
	req.pslverr=apb_vif.pslverr;
	req.pstrobe=apb_vif.pstrobe;
	 req.wdata=apb_vif.pwdata;
	 req.rdata=apb_vif.prdata;
	 req.addr=apb_vif.paddr;
		//COVERAGE TO BE ADDED
	/*if(apb1_cfg.has_coverage && apb_vif.pwrite) begin 
		`uvm_info("M", "Wd", UVM_LOW)
        	cov.w_cg.sample(apb_vif.pwdata,apb_vif.paddr, apb_vif.psel, apb_vif.penable,apb_vif.pready, apb_vif.pslverr);
	end 
	else if (apb1_cfg.has_coverage && !apb_vif.pwrite)begin 
        	cov.r_cg.sample(apb_vif.prdata,apb_vif.paddr,apb_vif.psel, apb_vif.penable, apb_vif.pready, apb_vif.pslverr);
	end */

    `uvm_info("Monitor", "do_monitor task executed", UVM_LOW)

   apb_mon_analysis_port.write(req); // sending sampled data to scoreboard
    //cov.apb_cg.sample(req); // sampling for coverage

endtask
