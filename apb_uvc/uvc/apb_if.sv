interface apb_if #(parameter ADDR = 32, parameter DATA = 32)(input bit system_clock, input bit reset_n);
    
    // * * * Add you specific interface logics below * * *
	logic  psel;
	logic  penable;
	logic  pready;
	logic  pwrite;
	logic[2:0] pprot;
	logic pslverr;
	logic [(DATA/4)-1:0] pstrobe;
	logic  [DATA-1:0] pwdata;
	logic  [DATA-1:0] prdata;
	logic [ADDR-1:0] paddr;

    task wait_n_clocks(int N);
        // * * * This task is just a blocking function that waits N clock cycles. * * *
        repeat(N) @(posedge system_clock);
    endtask
	 clocking driver_sync @(posedge system_clock);
	default  input #0 output #0;
	input psel;
	output pready,penable;  
	endclocking
    // * * * You can add assertion checkers bellow * * * 
property enbl();
	 @(posedge system_clock) disable iff(!reset_n)
    $rose(psel) |-> ##1 $rose(penable) ;

	endproperty 

     assert property  (enbl);

property end_of_trans1();
	 @(negedge  pready) disable iff(!reset_n)
	!pready |->!penable;
endproperty
property end_of_trans2();
	 @(negedge  pready) disable iff(!reset_n)
	!pready |-> !psel;
endproperty
    assert property (end_of_trans1);
    assert property (end_of_trans2);
property addr_a();
	 @(posedge system_clock) disable iff(!reset_n)
	 $rose(psel) |-> $stable(paddr);
endproperty

    assert property (addr_a);
endinterface   


