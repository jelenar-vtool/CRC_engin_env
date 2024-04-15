
class apb_agent#(parameter int ADDR = 32,parameter int DATA = 32) extends uvm_agent;
    
    `uvm_component_utils(apb_agent#(ADDR,DATA))

    virtual apb_if#(ADDR, DATA) apb_vif;
      
    apb_cfg                 apb1_cfg;
    apb_monitor#(ADDR, DATA)            m_mon;
    apb_master_driver#(ADDR, DATA)       m_drv;
    apb_master_sequencer    m_seqr;
       bit reset_flag = 0;

    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
   extern virtual task  pre_reset_phase (uvm_phase phase);  
    extern virtual task  reset_on_the_fly();    
endclass //apb_agent

//-------------------------------------------------------------------------------------------------------------
function apb_agent::new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("apb_agent", "apb UVC", UVM_LOW);
endfunction

//-------------------------------------------------------------------------------------------------------------
function void apb_agent::build_phase(uvm_phase phase);
    
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_if#(ADDR, DATA))::get(this, "*", "apb_vif", apb_vif)) begin
        `uvm_fatal("build_phase_apb_agent", "interface was not set");
    end else 
        `uvm_info("build_phase_apb_agent", "apb_if was set through config db", UVM_LOW); 

    `uvm_info("AGENT", $sformatf("cfg.agent_type = %0b", apb1_cfg.agent_type), UVM_LOW)

     if (get_is_active() == UVM_ACTIVE && apb1_cfg.agent_type == MASTER1) begin // Agent is configured as Master
        this.m_drv = apb_master_driver#(ADDR, DATA)::type_id::create("m_drv",this);
        this.m_seqr = apb_master_sequencer::type_id::create("m_seqr",this);
        `uvm_info("build_phase_master_agent", "Master driver and sequencer created.", UVM_LOW);
    end 
    
    m_mon = apb_monitor#(ADDR, DATA)::type_id::create("m_mon", this);
    //print_config();
endfunction // apb_master_agent::buid_phase

//-------------------------------------------------------------------------------------------------------------
function void apb_agent::connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE && apb1_cfg.agent_type == MASTER1) begin  //
        m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        `uvm_info("connect_phase_apb_agent", "master driver connected.", UVM_LOW);
    end
   
   //  apb_vif.apb_baud_rate_value <= cfg.apb_baud_rate_divisor;
endfunction // apb_agent::connect_phase
//-------------------------------------------------------------------------------------------------------------
task apb_agent::pre_reset_phase(uvm_phase phase);
   if(m_seqr && m_drv) begin
        `uvm_info("poruka", "lebac", UVM_LOW);
	if (reset_flag)
     m_seqr.stop_sequences();
     
   end
  
 endtask : pre_reset_phase
//------------------------------------------------------------------
task apb_agent::reset_on_the_fly();
    @(negedge apb_vif.reset_n);

    reset_flag = 1;
endtask
