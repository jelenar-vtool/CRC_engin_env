/* 
    RESET test generates a random number (between 100 and 150) of transactions. And executes them. In random moment, it forces a asynchronous reset.
*/

class apb_rst_test extends apb_base_test;

    `uvm_component_utils(apb_rst_test)

    apb_master_sequence m_seq;
    apb_slave_sequence s_seq;
        
    extern function new(string name = "apb_rst_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task run_phase (uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
endclass 

//-------------------------------------------------------------------------------------------------------------
function apb_rst_test::new(string name = "apb_rst_test", uvm_component parent=null);    
    super.new(name,parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void apb_rst_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
	m_seq = apb_master_sequence :: type_id :: create ("m_seq");
	s_seq = apb_slave_sequence :: type_id :: create ("s_seq");
endfunction : build_phase

//-------------------------------------------------------------------------------------------------------------
function void apb_rst_test::start_of_simulation_phase(uvm_phase phase);    
    super.start_of_simulation_phase(phase);    
endfunction

//-------------------------------------------------------------------------------------------------------------
task apb_rst_test:: run_phase (uvm_phase phase);        
    super.run_phase(phase);
    phase.raise_objection(this);
    fork begin

        for (int i = 0; i < 50; i++) begin
            fork
                begin
                    if (!m_seq.randomize() with {                     
                        //constraints               
                    })
                    `uvm_fatal("run_phase","apb_master_sequence randomization failed"); 
                    m_seq.start(env.master_agent.m_seqr);
                end

                begin
                    if (!s_seq.randomize() with { 
				    //constraints
                    })
                    `uvm_fatal("run_phase","apb_slave_sequence randomization failed");        
                    s_seq.start(env.slave_agent.s_seqr);
                end                
            join
        end
    end 

    begin
        apb_vif.wait_n_clocks(110);
        if (!uvm_hdl_force("top.reset_n", 0)) `uvm_error("TEST", "Forcing value 0 failed")
        else
             `uvm_info("TEST", "Forcing to 0 worked.", UVM_LOW)
        apb_vif.wait_n_clocks(100);
        if (!uvm_hdl_force("top.reset_n", 1)) `uvm_error("TEST", "Forcing value 1 failed")
        else
             `uvm_info("TEST", "Forcing to 1 worked.", UVM_LOW)
        assert(uvm_hdl_release("top.reset_n"));
        `uvm_info("TEST", "Releasing reset.", UVM_LOW)
    end join

    #100;
    phase.drop_objection (this);
endtask
    
//---------------------------------------------------------------------------------------------------------------------
function void apb_rst_test::report_phase(uvm_phase phase);
    super.report_phase(phase);
endfunction


