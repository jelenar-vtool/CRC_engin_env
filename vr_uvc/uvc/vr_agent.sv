
class vr_agent#(parameter int DATA = 32) extends uvm_agent;
    //ovo trba da se obrise ovo ne sluzi nicemu 
    `uvm_component_utils(vr_agent#(DATA))

    virtual vr_if#(DATA) vr_vif;
    bit reset_flag = 0;      
    vr_cfg                 cfg;
    vr_monitor#(DATA)            m_mon;
    vr_master_driver#(DATA)       m_drv;
    vr_master_sequencer    m_seqr;
    vr_slave_driver#(DATA)        s_drv;
    vr_slave_sequencer     s_seqr;
   
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
   extern virtual task  pre_reset_phase (uvm_phase phase);  
    extern virtual task  reset_on_the_fly();  
endclass //vr_agent

//-------------------------------------------------------------------------------------------------------------
function vr_agent::new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("vr_agent", "vr UVC", UVM_LOW);
endfunction

//-------------------------------------------------------------------------------------------------------------
function void vr_agent::build_phase(uvm_phase phase);
    
    super.build_phase(phase);

    if (!uvm_config_db#(virtual vr_if#(DATA))::get(this, "*", "vr_vif", vr_vif)) begin
        `uvm_fatal("build_phase_vr_agent", "interface was not set");
    end else 
        `uvm_info("build_phase_vr_agent", "vr_if was set through config db", UVM_LOW); 

    `uvm_info("AGENT", $sformatf("cfg.agent_type = %0b", cfg.agent_type), UVM_LOW)

     if (get_is_active() == UVM_ACTIVE && cfg.agent_type == MASTER) begin // Agent is configured as Master
        this.m_drv = vr_master_driver#( DATA)::type_id::create("m_drv",this);
        this.m_seqr = vr_master_sequencer::type_id::create("m_seqr",this);
        `uvm_info("build_phase_master_agent", "Master driver and sequencer created.", UVM_LOW);
    end 
    if (get_is_active() == UVM_ACTIVE && cfg.agent_type == SLAVE) begin // Agent is configured as Slave
        this.s_drv = vr_slave_driver#(DATA)::type_id::create("s_drv",this);
        this.s_seqr = vr_slave_sequencer::type_id::create("s_seqr",this);
        `uvm_info("build_phase_master_agent", "Slave driver and sequencer created.", UVM_LOW);
    end 
    m_mon = vr_monitor#(DATA)::type_id::create("m_mon", this);
    //print_config();
endfunction // vr_master_agent::buid_phase

//-------------------------------------------------------------------------------------------------------------
function void vr_agent::connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE && cfg.agent_type == MASTER) begin  //
        m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        `uvm_info("connect_phase_vr_agent", "master driver connected.", UVM_LOW);
    end
    if (get_is_active() == UVM_ACTIVE && cfg.agent_type == SLAVE) begin  //
        s_drv.seq_item_port.connect(s_seqr.seq_item_export);
        `uvm_info("connect_phase_vr_agent", "slave driver connected.", UVM_LOW);
    end

endfunction // vr_agent::connect_phase
//-------------------------------------------------------------------------------------------------------------
task vr_agent::pre_reset_phase(uvm_phase phase);
   if(m_seqr && m_drv) begin
        `uvm_info("poruka", "lebac", UVM_LOW);
	if (reset_flag)
     m_seqr.stop_sequences();
     
   end
   if(s_seqr && s_drv) begin
	if (reset_flag)
     s_seqr.stop_sequences();
     
   end
 endtask : pre_reset_phase
//------------------------------------------------------------------
task vr_agent::reset_on_the_fly();
    @(negedge vr_vif.reset_n);

    reset_flag = 1;
endtask
