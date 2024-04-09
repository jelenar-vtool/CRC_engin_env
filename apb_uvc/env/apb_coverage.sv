class apb_coverage#(int ADDR = 32, int DATA = 32) extends uvm_component;
    `uvm_component_utils(apb_coverage)
/*bit[DATA-1:0] max_data= {DATA{1'b1}};
bit[DATA-1:0] min_data={DATA{1'b0}};
bit[ADDR-1:0] max_addr= {ADDR{1'b1}};
bit[ADDR-1:0] min_addr= {ADDR{1'b0}};*/
	
covergroup r_cg with function sample(bit [DATA-1:0] prdata,bit[ADDR-1:0] paddr, bit psel, bit penable, bit pready, bit pslverr);

   option.per_instance = 1 ;

   prdata_value: coverpoint prdata {
      bins data_min = {0};
      bins data_low_range = {[0:32'h80000000]};
      bins data_high_range = {[32'h80000000:32'hffffffff]};
      bins data_max = {32'hffffffff};
    }

    paddr_value: coverpoint paddr {
      bins addr_min = {0};
      bins addr_low_range = {[0:32'h80000000]};
      bins addr_high_range =  {[32'h80000000:32'hffffffff]};
      bins addr_max ={32'hffffffff};
    }
     psel_value: coverpoint psel {

      bins on = {1};
    }
    penable_value: coverpoint penable {

      bins on = {1};
    }
    pready_value: coverpoint pready {

      bins on = {1};
    }

    pslverr_value: coverpoint pslverr {
      bins off = {0};
      bins on = {1};
    }
     pselXpenable: cross psel_value, penable_value{

	bins SETUP= binsof(psel_value.on)&& (binsof(penable_value.on ));
	}
     preadyXpsel_penable : cross pselXpenable, pready_value{

	bins TRANS= binsof(pselXpenable.SETUP)&& (binsof(pready_value.on ));
	}
     
  endgroup: r_cg

covergroup w_cg with function sample(bit [DATA-1:0] pwdata,bit[ADDR-1:0] paddr, bit psel, bit penable, bit pready, bit pslverr);

	option.per_instance = 1 ;

   pwdata_value: coverpoint pwdata {
      bins data_min ={0};
      bins data_low_range = {[0:32'h80000000]};
      bins data_high_range = {[32'h80000000:32'hffffffff]};
      bins data_max = {32'hffffffff};
    }

    paddr_value: coverpoint paddr {
      bins addr_min = {0};
      bins addr_low_range = {[0:32'h80000000]};
      bins addr_high_range =  {[32'h80000000:32'hffffffff]};
      bins addr_max ={32'hffffffff};
    }
    psel_value: coverpoint psel {

      bins on = {1};
    }
    penable_value: coverpoint penable {

      bins on = {1};
    }
    pready_value: coverpoint pready {

      bins on = {1};
    }

    pslverr_value: coverpoint pslverr {
      bins off = {0};
      bins on = {1};
    }
   pselXpenable: cross psel_value, penable_value{

	bins SETUP= binsof(psel_value.on)&& (binsof(penable_value.on ));
	}
     preadyXpsel_penable : cross pselXpenable, pready_value{

	bins TRANS= binsof(pselXpenable.SETUP)&& (binsof(pready_value.on ));
	}
  endgroup: w_cg
 extern function new(string name, uvm_component parent=null);
endclass: apb_coverage

 function apb_coverage:: new(string name, uvm_component parent=null);
    super.new(name,parent);
    r_cg=new();
    r_cg.set_inst_name("r_cg");
    w_cg=new();
    w_cg.set_inst_name("w_cg");
endfunction: new
