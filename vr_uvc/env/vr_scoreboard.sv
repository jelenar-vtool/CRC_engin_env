`uvm_analysis_imp_decl(_m_mon) //master monitor
`uvm_analysis_imp_decl(_s_mon) //slave monitor

class vr_sb#(int DATA = 32)  extends uvm_scoreboard;

    `uvm_component_utils(vr_sb)

    uvm_analysis_imp_m_mon #(vr_item, vr_sb) m_mon_imp; // master monitor
    uvm_analysis_imp_s_mon #(vr_item, vr_sb) s_mon_imp; // slave monitor
    
    // * * * Add fields here * * * 
    vr_item req;
     virtual vr_if vr_vif;
        bit[DATA-1: 0] ref_mem[$];
    function new(string name = "", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
  if(!uvm_config_db#(virtual vr_if#(DATA))::get(this, "", "vr_vif", vr_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ",get_full_name(),".vr_vif"});

        m_mon_imp = new("m_mon_imp", this);
        s_mon_imp = new("s_mon_imp", this);

    endfunction    

    virtual function void write_m_mon(vr_item req);
         `uvm_info("Scoreboard", "Just recieved item from master monitor", UVM_LOW)
    endfunction
    virtual function void write_s_mon(vr_item req); //what slave monitor sampled
        `uvm_info("Scoreboard", "Just recieved item from slave monitor", UVM_LOW)

		
	 
    endfunction
task run_phase (uvm_phase phase);

fork
	forever begin 
	  `uvm_info("SCOREBOARD", "run task, for reset", UVM_LOW)
		@(negedge vr_vif.reset_n == 0) begin	 	
		ref_mem.delete();
	end 
	end
	forever begin
	  `uvm_info("SCOREBOARD", "run task", UVM_LOW)
		  wait (ref_mem.size()>0 );
	if(req.valid && req.ready) begin 
			ref_mem.push_back(req.data);
	end
	end
join_none
endtask
  
endclass
