
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

	vr_if#(37) crc_req_t_vif (clk,reset_n); //FIFO req input
	vr_if#(24) crc_param_req_t_vif (clk,reset_n); //req_procces out
	vr_if#(157) crc_param_rsp_t_vif (clk,reset_n); //input for demultiplexer
	vr_if#(149) crc_rsp_t_vif (clk,reset_n); //FIFO rsp output
    apb_if#(10,32) apb_vif (clk,reset_n);

    crc_sequencer m_dut0 			(.i_clk(apb_vif.system_clock),
						  .i_nreset(crc_req_t_vif.reset_n),
							//apb
    					  	.i_reg_apb_psel(apb_vif.psel),
						  .i_reg_apb_penable(apb_vif.penable),
						  .i_reg_apb_pwrite(apb_vif.pwrite),
						  .i_reg_apb_pwdata(apb_vif.pwdata),
						  .i_reg_apb_paddr(apb_vif.paddr),
						  .o_reg_apb_pready(apb_vif.pready),
						  .o_reg_apb_prdata(apb_vif.prdata),
							//FIFO req input
						  .i_crc_req_valid(crc_req_t_vif.valid),
						  .i_crc_req_data(crc_req_t_vif.data),
						  .o_crc_req_ready(crc_req_t_vif.ready),
							//req_procces out
 						  .i_crc_done_ready(crc_param_req_t_vif.ready),
					      .o_crc_done_data(crc_param_req_t_vif.data),
						  .o_crc_done_valid(crc_param_req_t_vif.valid),
							//input for demultiplexer
						  .i_crc_param_done_valid(crc_param_rsp_t_vif.valid),
						  .i_crc_param_done_data(crc_param_rsp_t_vif.data),
						  .o_crc_param_done_ready(crc_param_rsp_t_vif.ready),
							//FIFO rsp output
						  .o_crc_param_valid(crc_rsp_t_vif.valid),
						  .o_crc_param_data(crc_rsp_t_vif.data),
						  .i_crc_param_ready(crc_rsp_t_vif.ready));

    //interface
    initial begin
        uvm_config_db#(virtual vr_if#(37))::set(uvm_root::get(), "uvm_test_top.env.crc_req_agent*", "vr_vif", crc_req_t_vif); //crc_env.crc_req_agent
        uvm_config_db#(virtual vr_if#(24))::set(uvm_root::get(), "uvm_test_top.env.crc_param_req_agent*", "vr_vif", crc_param_req_t_vif);
        uvm_config_db#(virtual vr_if#(157))::set(uvm_root::get(), "uvm_test_top.env.crc_param_rsp_agent*", "vr_vif", crc_param_rsp_t_vif);
        uvm_config_db#(virtual vr_if#(149))::set(uvm_root::get(), "uvm_test_top.env.crc_rsp_agent*", "vr_vif", crc_rsp_t_vif);
        uvm_config_db#(virtual apb_if#(10,32))::set(uvm_root::get(), "uvm_test_top.env.apb_master_agent*", "apb_vif", apb_vif);
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
