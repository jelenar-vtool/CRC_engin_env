
`include "uvm_macros.svh"
`include "vr_env_pkg.sv"

module top;
    
    import uvm_pkg::*;
    import vr_pkg::*;
    import vr_env_pkg::*;

      
    bit clk, reset_n;
    
    // 25MHz clock freq for timescale 1ns
    parameter CLK_CYCLE = 20; 
    localparam delay_reset = 105;
    string logfile = "dump.vcd";
      
    initial begin
        clk =0;
        forever #(CLK_CYCLE) clk = ~clk;
    end 

    //reset initialization
    initial begin
        reset_n = 0;
        #delay_reset; //async reset
        reset_n = 1;	
				
				    	
    end
    
    vr_if#(32)vr_vif (clk,reset_n);

    //interface
    initial begin
        uvm_config_db#(virtual vr_if#(32))::set(null,"*", "vr_vif", vr_vif);
    end
    
    // invoking simulation phases of all components
    initial begin
        run_test(""); 
    end
    // Waves
    /*initial begin
        $value$plusargs("DUMPNAME=%s", logfile);
        $dumpfile(logfile); 
        $dumpvars;
    end*/
	initial begin
		$shm_open("wave.db");
            	$shm_probe("ACTF");
	end
endmodule 
