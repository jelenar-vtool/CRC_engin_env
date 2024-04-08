class crc_base_test extends uvm_test;
   // Add to factory 
      `uvm_component_utils (crc_base_test) 

    crc_env m_env;
    crc_env_cfg m_env_cfg;
	crc_master_sequence  ms_seq;
    extern function new(string name = "crc_base_test", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
endclass 

//-------------------------------------------------------------------------------------------------------------
function  crc_base_test::new(string name = "crc_base_test", uvm_component parent);
	super.new(name,parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void crc_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_env = crc_env::type_id::create("m_env", this);
    m_env_cfg = crc_env_cfg::type_id::create("m_env_cfg", this);

    m_env_cfg.set_default_config();
    
    uvm_config_db#(crc_env_cfg)::set(this, "m_env", "m_env_cfg", m_env_cfg);
    
endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
task crc_base_test::run_phase(uvm_phase phase);
       phase.raise_objection(this);
       ms_seq=crc_master_sequence::type_id::create("ms_seq");
       ms_seq.start(m_env.m_agent.sequencer);
      phase.phase_done.set_drain_time(this, 100ns);
       phase.drop_objection(this);
endtask
