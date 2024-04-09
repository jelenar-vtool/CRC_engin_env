
class vr_slave_driver#( int DATA = 32) extends uvm_driver #(vr_item);
    
    `uvm_component_utils(vr_slave_driver#(DATA))
    virtual vr_if#(DATA)   vr_vif;

    vr_cfg    cfg; 
    bit reset_flag = 0;


    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task  run_phase (uvm_phase phase);
    extern virtual task  do_init ();
    extern virtual task  reset_on_the_fly();
    extern virtual task  do_drive(vr_item req);

   
endclass // vr_slave_driver

//-------------------------------------------------------------------------------------------------------------
function vr_slave_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction // vr_slave_driver::new

//-------------------------------------------------------------------------------------------------------------
function void vr_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info("build_phase","BUILD vr_slave_DRIVER",UVM_HIGH);
    if(!uvm_config_db#(virtual vr_if#( DATA))::get(this, "", "vr_vif", vr_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ", get_full_name(),".vr_vif"});
    if (!uvm_config_db#(vr_cfg)::get(this, "", "cfg", cfg)) begin
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
    end
endfunction // vr_slave_driver::build_phase

//-------------------------------------------------------------------------------------------------------------
task vr_slave_driver::run_phase(uvm_phase phase);
    do_init();
	@(posedge vr_vif.reset_n);
	repeat(3) @(posedge vr_vif.clk);

	
    forever begin 
        seq_item_port.get_next_item(req);

       
        if (reset_flag) begin 
    		do_init();
            @(posedge vr_vif.reset_n); // wait for reset to end
	        repeat(3) @(posedge vr_vif.clk); // wait 3 more clock cycles, just to be sure we're stable
            reset_flag = 0;
        end
		fork
			begin 
        		fork 
           			reset_on_the_fly(); 
            		do_drive(req);
        		join_any
        	disable fork;
			end
		join	
        seq_item_port.item_done();  
	
	end

endtask// vr_slave_driver::run_phase
task vr_slave_driver::do_init();
	vr_vif.ready=0;
    @(posedge vr_vif.clk);
    `uvm_info("Driver", "MASTER-do_init task executed", UVM_LOW)
endtask
task vr_slave_driver::reset_on_the_fly();
    @(negedge vr_vif.reset_n);
	do_init();
endtask
task vr_slave_driver::do_drive(vr_item req);
	/*while(1) begin 
		@(posedge vr_vif.clk );
		if(vr_vif.s_ckb.valid == 1)	 begin 
	   		vr_vif.s_ckb.ready<=1;
		end
		break;
	end 
		@(posedge vr_vif.clk );
	   	vr_vif.s_ckb.ready<=0;
			vr_vif.s_ckb.ready<=1;
	@(posedge vr_vif.clk)
			vr_vif.s_ckb.ready<=0;*/
		@(posedge vr_vif.clk);
		repeat (req.delay+1)
	   		vr_vif.s_ckb.ready<=1;
				@(posedge vr_vif.clk iff (vr_vif.s_ckb.valid == 1));
	   		vr_vif.s_ckb.ready<=0;
endtask 
