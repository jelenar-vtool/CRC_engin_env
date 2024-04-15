`uvm_analysis_imp_decl(_master)
`uvm_analysis_imp_decl(_masterreq)//FIFO req input-master
`uvm_analysis_imp_decl(_slaveparamreq)//req_procces out-slave
`uvm_analysis_imp_decl(_masterparamrsp)//input for demultiplexer-master
`uvm_analysis_imp_decl(_slaversp)//FIFO rsp output-salve
//------------------------------------------------------------------------------------------------------------
class crc_scoreboard extends uvm_scoreboard;

    //Add scoreboard to factory
      `uvm_component_utils (crc_scoreboard)


        apb_item#(10,32)	req;
      	vr_item#(37) vr_req;
      	vr_item#(24) vr_param_req;
      	vr_item#(157) vr_param_rsp;
      	vr_item#(149) vr_rsp;
     uvm_analysis_imp_master #(apb_item#(10,32), crc_scoreboard) m_ap; //monitor master apb    
     uvm_analysis_imp_masterreq #(vr_item#(37), crc_scoreboard) m_mon_impreq; //monitor master vr-FIFO req input
     uvm_analysis_imp_slaveparamreq #(vr_item#(24), crc_scoreboard) s_mon_impparamreq; //monitor salve vr-req_procces out    
     uvm_analysis_imp_masterparamrsp #(vr_item#(157), crc_scoreboard) m_mon_impparamrsp; //monitor master vr-input for demultiplexer
     uvm_analysis_imp_slaversp #(vr_item#(149), crc_scoreboard) s_mon_imprsp; //monitor salve vr-FIFO rsp output 

     //virtual apb_if#(10,32) apb_vif;
    extern function new(string name = "", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void write_master (apb_item#(10,32) req);
    extern function void write_masterreq (vr_item#(37) vr_req);
    extern function void write_slaveparamreq (vr_item#(24) vr_param_req);
    extern function void write_masterparamrsp (vr_item#(157) vr_param_rsp);
    extern function void write_slaversp (vr_item#(149) vr_rsp);
    //extern task run_phase (uvm_phase phase);
    //extern function void phase_ready_to_end(uvm_phase phase);
  
endclass

//------------------------------------------------------------------------------------------------------------
function crc_scoreboard::new(string name = "", uvm_component parent);
    super.new(name,parent);


endfunction

//------------------------------------------------------------------------------------------------------------
function void crc_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    /*if(!uvm_config_db #(virtual apb_if#(.ADDR(10),.DATA(32))::get(this, "", "apb_vif", apb_vif)) begin 
       `uvm_fatal("", "Failed to get virtual_interface !");
    end*/
      m_ap= new("m_ap", this);
        m_mon_impreq= new("m_mon_impreq", this);
      s_mon_impparamreq= new("s_mon_impparamreq", this);
      m_mon_impparamrsp= new("m_mon_impparamrsp", this);
      s_mon_imprsp= new("s_mon_imprsp", this);
endfunction    

//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_master (apb_item#(10,32) req);

`uvm_info("SCOREBOARD", "uso u write-apb", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_masterreq (vr_item#(37) vr_req);

`uvm_info("SCOREBOARD", "uso u write-FIFO REQ", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_slaveparamreq (vr_item#(24) vr_param_req);

`uvm_info("SCOREBOARD", "uso u write- RWQ PARAM", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_masterparamrsp (vr_item#(157) vr_param_rsp);

`uvm_info("SCOREBOARD", "uso u write- RSP PARAM", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
 function void crc_scoreboard::write_slaversp (vr_item#(149) vr_rsp);

`uvm_info("SCOREBOARD", "uso u write- FIFO RSP", UVM_LOW)


endfunction
//------------------------------------------------------------------------------------------------------------
/*function void crc_scoreboard::phase_ready_to_end(uvm_phase phase);
 if (phase.get_name() != "run") return;
 if (refr_fifo.size() != 0) begin

  `uvm_fatal ("phase_ready_to_end","queue not empty")
 end
endfunction*/


       
/*task crc_scoreboard:: run_phase (uvm_phase phase);
`uvm_info("SCOREBOARD", "uso u run", UVM_LOW)
endtask*/
