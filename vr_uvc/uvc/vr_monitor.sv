
class vr_monitor#(int DATA = 32) extends uvm_monitor; 
   
   `uvm_component_utils(vr_monitor#(DATA))

    virtual vr_if#(DATA) vr_vif;
    vr_item#(DATA)   req;
    vr_cfg         cfg;
    int counter;
    uvm_analysis_port #(vr_item#(DATA))   vr_mon_analysis_port;
    uvm_analysis_port #(vr_item#(DATA))   vr_s_analysis_port;
    bit reset_flag = 0;
    
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase(uvm_phase phase);  
    extern virtual task  do_monitor();
    extern virtual task  reset_on_the_fly();
    
endclass // vr_monitor_class

//-------------------------------------- 
//-----------------------------------------------------------------------
function vr_monitor::new (string name, uvm_component parent);
    super.new(name, parent);
    req = vr_item#(DATA)::type_id::create("req", this);
endfunction   

//-------------------------------------------------------------------------------------------------------------
function void vr_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase","BUILD vr_MONITOR",UVM_MEDIUM);
    if(!uvm_config_db#(virtual vr_if#(DATA))::get(this, "", "vr_vif", vr_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ",get_full_name(),".vr_vif"});

    if (!uvm_config_db#(vr_cfg)::get(this, "", "cfg",cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end

    vr_mon_analysis_port = new("vr_mon_analysis_port",this);  
    vr_s_analysis_port = new("vr_s_analysis_port",this);  

    if (!cfg.has_checks)   
        `uvm_info("build_phase","CHECKERS DISABLED",UVM_LOW);
endfunction

//-------------------------------------------------------------------------------------------------------------
task  vr_monitor::run_phase(uvm_phase phase);
    
	//wait for reset
	@(posedge vr_vif.reset_n);
	repeat(3) @(posedge vr_vif.clk);
    forever begin
	
      // delete if bellow if UVC dosen't have reset on fly feature
    	if (reset_flag) begin
            @(posedge vr_vif.reset_n); // wait for reset to end
	        repeat(3) @(posedge vr_vif.clk); // wait 3 more clock cycles, just to be sure we're stable
            reset_flag = 0;
      	end
		fork 
		begin 
        	fork 
            	reset_on_the_fly(); // delete this and fork if UVC dosen't have reset on fly feature
            	do_monitor();
        	join_any
        	disable fork;
		end
		join
    end // of forever       
endtask


//-------------------------------------------------------------------------------------------------------------
task vr_monitor::reset_on_the_fly();  
    @(negedge vr_vif.reset_n);
    reset_flag = 1;
    `uvm_info("MONITOR","ASYNCHRONOUS RESET HAPPENED", UVM_LOW)
    
endtask //reset_on_the_fly*/

task vr_monitor::do_monitor();

    @(posedge vr_vif.clk iff  (vr_vif.ready));  
	req.valid<=vr_vif.mon_ckb.valid;
	req.ready<=vr_vif.mon_ckb.ready;
	req.data<=vr_vif.mon_ckb.data;


    `uvm_info("Monitor", "do_monitor task executed", UVM_LOW)
	//TO BE ADDED SENDING TO SCOREBOARD
    vr_mon_analysis_port.write(req); // sending sampled data to scoreboard
    vr_s_analysis_port.write(req);

endtask
