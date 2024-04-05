
`include "uvm_macros.svh"
`include "crc_env_pkg.sv"

module top;
    
    import uvm_pkg::*;
    import crc_pkg::*;
    import crc_env_pkg::*;

      
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
    
    crc_if#(36,149,24)	crc_vif (clk,reset_n);

    crc_sequencer m_dut0 (crc_vif.i_clk, crc_vif.i_nreset, crc_vif.i_reg_apb_psel, crc_vif.i_reg_apb_penable, crc_vif.i_reg_apb_pwrite, crc_vif.i_reg_apb_paddr, crc_vif.i_reg_apb_pwdata, crc_vif.o_reg_apb_pready, crc_vif.o_reg_apb_prdata,crc_vif.i_crc_req_valid, crc_vif.i_crc_req_data, crc_vif.o_crc_req_ready, crc_vif.i_crc_done_ready, crc_vif.o_crc_done_data, crc_vif.o_crc_done_valid, crc_vif.i_crc_param_done_valid, crc_vif.i_crc_param_done_data, crc_vif.o_crc_param_done_ready, crc_vif.o_crc_param_valid, crc_vif.o_crc_param_data, crc_vif. i_crc_param_ready, crc_vif.o_int);

    //interface
    initial begin
        uvm_config_db#(virtual crc_if#(36,149,24))::set(null,"*", "crc_vif", crc_vif);
    end
    
    // invoking simulation phases of all components
    initial begin
        run_test(""); 
    end
    // Waves
    initial begin
        $value$plusargs("DUMPNAME=%s", logfile);
        $dumpfile(logfile); 
        $dumpvars;
    end
endmodule 
