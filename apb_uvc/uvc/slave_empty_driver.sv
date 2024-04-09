
class slave_empty_driver#(int ADDR = 32, int DATA = 32) extends uvm_driver #(apb_item);
    
    `uvm_component_utils(slave_empty_driver#(ADDR,DATA))
    virtual apb_if#(ADDR, DATA)   apb_vif;
    bit[DATA-1: 0] mem[bit [DATA-1:0]];
    apb_cfg    cfg; 

	bit error_flag=0;
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase (uvm_phase phase);
    extern virtual task  do_init ();
   extern virtual task  reset_on_the_fly();
    extern virtual task  req_do (apb_item req);
    extern virtual task  rsp_do (apb_item rsp);
   
endclass // apb_slave_driver

//-------------------------------------------------------------------------------------------------------------
function slave_empty_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction // apb_slave_driver::new

//-------------------------------------------------------------------------------------------------------------
function void slave_empty_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info("build_phase","BUILD apb_slave_DRIVER",UVM_HIGH);
    if(!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "", "apb_vif", apb_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ", get_full_name(),".apb_vif"});
    if (!uvm_config_db#(apb_cfg)::get(this, "", "cfg", cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end
endfunction // apb_slave_driver::build_phase

//-------------------------------------------------------------------------------------------------------------
task slave_empty_driver::run_phase(uvm_phase phase);
	apb_item req;
	apb_item rsp; 





	forever begin 	
@(posedge apb_vif.system_clock iff (apb_vif.psel && apb_vif.reset_n));
	  
    seq_item_port.get_next_item(req);
	req_do(req);
	seq_item_port.item_done();  
	
        seq_item_port.get_next_item(rsp);//u responsu radim logikyu slevjaa
 

        fork 
			begin 
            reset_on_the_fly();
			end 
			begin 
			rsp_do(rsp);
			end 
		join_any
       	 disable fork;
			
                seq_item_port.item_done();  

	
	
end

endtask// apb_slave_driver::run_phase
task slave_empty_driver::do_init();
// * * * Write initial values for your signals here * * *
	apb_vif.pready=0;
	apb_vif.pslverr=0;
	apb_vif.prdata=0;
    @(posedge apb_vif.system_clock);
    `uvm_info("Driver", "MASTER-do_init task executed", UVM_LOW)
endtask
task slave_empty_driver::reset_on_the_fly();
    // * * * Leave this untoched if planning to implement Reset on the fly feature. If not delete it. * * *
    @(negedge apb_vif.reset_n);

do_init();
endtask

task slave_empty_driver::req_do(apb_item req);

    req.wdata=apb_vif.pwdata;
    req.pwrite=apb_vif.pwrite;
	req.addr=apb_vif.paddr;

	`uvm_info("slave", $sformatf("slavedriveraddr = %h", req.addr), UVM_LOW) 
	req.pprot=apb_vif.pprot;
	req.penable=apb_vif.penable;
	req.pstrobe=apb_vif.pstrobe;
endtask
task slave_empty_driver::rsp_do(apb_item rsp);
`uvm_info("rsp","aa",UVM_LOW) 

 	if (cfg.has_delay == 1) 
		repeat (rsp.delay+1)
	   		rsp.pready=1;
          	apb_vif.pready =  rsp.pready; 
		`uvm_info("pready", $sformatf("pready = %h", rsp.pready), UVM_LOW) 
`uvm_info("redia","aa",UVM_LOW)
		if(rsp.pwrite)begin 
`uvm_info("RWRITEEEE","aa",UVM_LOW) 
        apb_vif.pslverr <=  rsp.pslverr; 
		@(posedge apb_vif.system_clock); 
		apb_vif.pready<=0;										

	 
	end 
	else begin 

`uvm_info("READDD","aa",UVM_LOW) 
         apb_vif.prdata <=  rsp.rdata;  
		`uvm_info("rdata", $sformatf("rdata = %h", rsp.rdata), UVM_LOW) 	

		        apb_vif.pslverr <=  rsp.pslverr; 
		`uvm_info("pslverr", $sformatf("pslverr = %h", rsp.pslverr), UVM_LOW)  
 		@(posedge apb_vif.system_clock); 
		apb_vif.pready=0;	

	 end
endtask

