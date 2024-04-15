class crc_base_test extends uvm_test;
   // Add to factory 
      `uvm_component_utils (crc_base_test) 


    crc_env_cfg m_env_cfg;
    crc_env env;
    vr_cfg cfg;
    apb_cfg apb1_cfg;

   crc_virtual_sequence  ms_seq;
    extern function new(string name = "crc_base_test", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void cfg_randomize(); 
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase (uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual function void set_default_configuration ();
    extern virtual function void set_configuration (); //Override this function to create different configuration
endclass 

//-------------------------------------------------------------------------------------------------------------
function  crc_base_test::new(string name = "crc_base_test", uvm_component parent);
	super.new(name,parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void crc_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = vr_cfg::type_id::create("cfg", this);
    apb1_cfg = apb_cfg::type_id::create("apb1_cfg", this);
    m_env_cfg = crc_env_cfg::type_id::create("m_env_cfg", this);
    env = crc_env::type_id::create("env", this);
    `uvm_info("build_phase", "Enviroment created.", UVM_HIGH)

     cfg_randomize();
    set_configuration();
    
    uvm_config_db#(crc_env_cfg)::set(this,"env","m_env_cfg", m_env_cfg);
    uvm_config_db#(vr_cfg)::set(this,"*","cfg", cfg);
    uvm_config_db#(apb_cfg)::set(this,"*","apb1_cfg", apb1_cfg);
    ms_seq = crc_virtual_sequence :: type_id :: create ("ms_seq");
endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
function void crc_base_test::cfg_randomize(); 
 	if (!cfg.randomize() with {
        //add constraints

        })
    `uvm_fatal("build_phase","Configuration randomization failed");
endfunction : cfg_randomize

//-------------------------------------------------------------------------------------------------------------
function void crc_base_test::set_configuration();
    set_default_configuration();
endfunction

//-------------------------------------------------------------------------------------------------------------
function void crc_base_test::set_default_configuration ();
    m_env_cfg.has_master_agent = 1;
    m_env_cfg.has_slave_agent = 1;
    m_env_cfg.master_config.agent_type = MASTER;
    m_env_cfg.slave_config.agent_type = SLAVE;
    `uvm_info("config", "Default configuration set.", UVM_HIGH)
endfunction : set_default_configuration

//-------------------------------------------------------------------------------------------------------------
function void  crc_base_test::start_of_simulation_phase(uvm_phase phase);
	uvm_report_server svr;
    uvm_verbosity verbosity = UVM_LOW;

	super.start_of_simulation_phase(phase);
	uvm_top.set_timeout(.timeout(this.cfg.test_time_out), .overridable(1));
	`uvm_info("start_of_simulation_phase", $sformatf("Printing topology"), UVM_LOW)
	uvm_top.print_topology();
	svr = uvm_report_server::get_server();
    //set verbosity level for env
    $value$plusargs("VERBOSITY=%s", verbosity);
    `uvm_info("start_of_simulation_phase", $sformatf("Verbosity is set to %s.", verbosity.name()), UVM_LOW)
	env.set_report_verbosity_level_hier(verbosity);
	svr.set_max_quit_count(1000); //maximum number of errors 
endfunction
//-------------------------------------------------------------------------------------------------------------
task crc_base_test::run_phase(uvm_phase phase);
       phase.raise_objection(this);

       ms_seq.start(env.m_virt_seqr);
      phase.phase_done.set_drain_time(this, 100ns);
       phase.drop_objection(this);
endtask
//-------------------------------------------------------------------------------------------------------------
function void  crc_base_test::report_phase(uvm_phase phase);
    uvm_report_server svr;
  	super.report_phase(phase);
  	svr = uvm_report_server::get_server();
endfunction
