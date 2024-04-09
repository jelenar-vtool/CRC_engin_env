
`include "uvm_macros.svh"
`include "crc_env_pkg.sv"

module top;
    
    import uvm_pkg::*;
    import crc_pkg::*;
    import crc_env_pkg::*;

      
    bit clk, reset_n;
    

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
    
	vr_if#(37)crc_req_t_vif (clk,reset_n); //FIFO req input
	vr_if#(149)crc_param_req_t_vif (clk,reset_n); //req_procces out
	vr_if#(8)crc_param_rsp_t_vif (clk,reset_n); //input for demultiplexer
	vr_if#(24)crc_rsp_t_vif (clk,reset_n); //FIFO rsp output
		//treba apb da se instancira
    crc_sequencer m_dut0 (.i_clk(crc_req_t_vif.clk), .i_nreset(crc_req_t_vif.reset_n),
	.i_crc_req_valid(crc_req_t_vif.valid), .i_crc_req_data(crc_req_t_vif.data), .o_crc_req_ready(crc_req_t_vif.ready),
 	.i_crc_done_ready(crc_param_req_t_vif.ready), .o_crc_done_data(crc_param_req_t_vif.data), .o_crc_done_valid(crc_param_req_t_vif.valid),
	.i_crc_param_done_valid(crc_param_rsp_t_vif.valid), .i_crc_param_done_data(crc_param_rsp_t_vif.data), .o_crc_param_done_ready(crc_param_rsp_t_vif.ready),
	.o_crc_param_valid(crc_rsp_t_vif.valid), .o_crc_param_data(crc_rsp_t_vif.data), .i_crc_param_ready(crc_rsp_t_vif.ready) );

    //interface
    initial begin
        uvm_config_db#(virtual vr_if#(37))::set(null,"*", "crc_req_t_vif", crc_req_t_vif);
        uvm_config_db#(virtual vr_if#(149))::set(null,"*", "crc_param_req_t_vif", crc_param_req_t_vif);
        uvm_config_db#(virtual vr_if#(8))::set(null,"*", "crc_param_rsp_t_vif", crc_param_rsp_t_vif);
        uvm_config_db#(virtual vr_if#(24))::set(null,"*", "crc_rsp_t_vif", crc_rsp_t_vif);
    end
    

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
