`uvm_analysis_imp_decl(_m_mon) //master monitor
`uvm_analysis_imp_decl(_s_mon) //slave monitor

class apb_sb#(int ADDR = 32, int DATA = 32)  extends uvm_scoreboard;

    `uvm_component_utils(apb_sb)

    uvm_analysis_imp_m_mon #(apb_item, apb_sb) m_mon_imp; // master monitor
    uvm_analysis_imp_s_mon #(apb_item, apb_sb) s_mon_imp; // slave monitor
    
    // * * * Add fields here * * * 
    apb_item req;
     virtual apb_if apb_vif;
        bit[DATA-1: 0] ref_mem[bit[DATA-1:0]];
    function new(string name = "", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
  if(!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "", "apb_vif", apb_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ",get_full_name(),".apb_vif"});

        m_mon_imp = new("m_mon_imp", this);
        s_mon_imp = new("s_mon_imp", this);

    endfunction    

    virtual function void write_m_mon(apb_item req);
        `uvm_info("Scoreboard", "Just recieved item from master monitor", UVM_LOW)
	if(req.pwrite && req.psel) begin 

			if (req.pslverr==1)  begin `uvm_info("error","Error response", UVM_LOW) end //When a write receives an error register within the peripheral can updated.

		`uvm_info("scoreboard", $sformatf("addr = %h", req.addr), UVM_LOW) 
		`uvm_info("scoreboard", $sformatf("wdata = %h", req.wdata), UVM_LOW) 
		
	end
    endfunction

    virtual function void write_s_mon(apb_item req); //what slave monitor sampled
        `uvm_info("Scoreboard", "Just recieved item from slave monitor", UVM_LOW)
	if(req.pwrite==0 && req.psel) begin 

			if (req.pslverr==1)  begin `uvm_info("error","Error response", UVM_LOW) end  //When a read receives an error it can return invalid data.

			`uvm_info("scoreboard", $sformatf("addr = %h", req.addr), UVM_LOW) 
			`uvm_info("scoreboard", $sformatf("rdata = %h", req.rdata), UVM_LOW) 
		
	end 
    endfunction
task run_phase (uvm_phase phase);

fork
	forever begin 
	  `uvm_info("SCOREBOARD", "run task, for reset", UVM_LOW)
		@(negedge apb_vif.reset_n == 0) begin	 	
		ref_mem.delete();
	end 
	end
	forever begin
	  `uvm_info("SCOREBOARD", "run task", UVM_LOW)
		  wait (ref_mem.size()>0 );
	if(req.pwrite && req.psel) begin 
			ref_mem[req.addr] = req.wdata;
	end else if(req.pwrite==0 && req.psel) begin
			if (ref_mem.exists(req.addr)==0)  begin `uvm_error("addr","nonexisting item on input addr") end 
		if (!(req.rdata === ref_mem[req.addr]))  begin `uvm_error("data","output data does not match input data") end
	
	end 
	end
join_none
endtask
  
endclass
