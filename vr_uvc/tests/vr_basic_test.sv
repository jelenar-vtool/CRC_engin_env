class vr_basic_test extends uvm_test;
   
      `uvm_component_utils(vr_basic_test) 
    vr_env_cfg cfg_env;
    vr_env env;
  	vr_cfg cfg;
    virtual vr_if#(32)   vr_vif;
   virtual_sequence  ms_seq;
    extern function new(string name = "vr_basic_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void cfg_randomize(); 
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase (uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual function void set_default_configuration ();
    extern virtual function void set_configuration (); //Override this function to create different configuration
endclass 

//-------------------------------------------------------------------------------------------------------------
function  vr_basic_test::new(string name = "vr_basic_test", uvm_component parent=null);
	super.new(name,parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void vr_basic_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  if(!uvm_config_db#(virtual vr_if#(32))::get(this, "", "vr_vif", vr_vif)) 
        `uvm_fatal("build_phase",{"virtual interface must be set for: ", get_full_name(),".vr_vif"});

    cfg_env = vr_env_cfg::type_id::create("cfg_env", this);
    env = vr_env::type_id::create("env", this);
    `uvm_info("build_phase", "Enviroment created.", UVM_HIGH)
    cfg = vr_cfg::type_id::create("cfg", this);
     cfg_randomize();
    set_configuration();
    
    uvm_config_db#(vr_env_cfg)::set(this,"env","cfg_env", cfg_env);
    uvm_config_db#(vr_cfg)::set(this, "*", "cfg", cfg);
    ms_seq = virtual_sequence :: type_id :: create ("ms_seq");
endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
function void vr_basic_test::cfg_randomize(); 
 	if (!cfg.randomize() with {
        //add constraints

        })
    `uvm_fatal("build_phase","Configuration randomization failed");
endfunction : cfg_randomize

//-------------------------------------------------------------------------------------------------------------
function void vr_basic_test::set_configuration();
    set_default_configuration();
endfunction

//-------------------------------------------------------------------------------------------------------------
function void vr_basic_test::set_default_configuration ();
    cfg_env.has_master_agent = 1;
    cfg_env.has_slave_agent = 1;
    cfg_env.master_config.agent_type = MASTER;
    cfg_env.slave_config.agent_type = SLAVE;
    `uvm_info("config", "Default configuration set.", UVM_HIGH)
endfunction : set_default_configuration

//-------------------------------------------------------------------------------------------------------------
function void  vr_basic_test::start_of_simulation_phase(uvm_phase phase);
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
task vr_basic_test::run_phase(uvm_phase phase);
       phase.raise_objection(this);

       ms_seq.start(env.sequencer);
      phase.phase_done.set_drain_time(this, 100ns);
       phase.drop_objection(this);
endtask
//-------------------------------------------------------------------------------------------------------------
function void  vr_basic_test::report_phase(uvm_phase phase);
    uvm_report_server svr;
  	super.report_phase(phase);
  	svr = uvm_report_server::get_server();
endfunction
