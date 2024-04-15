interface vr_if #(parameter DATA=32)(input bit clk, input bit reset_n);

	logic 				valid; 
	logic 				ready;
	logic [DATA-1:0] 	data;
    task wait_n_clocks(int N);
        // * * * This task is just a blocking function that waits N clock cycles. * * *
        repeat(N) @(posedge clk);
    endtask
	property end_of_trans();
	 	@(posedge clk) disable iff(!reset_n)
    	$rose(ready) |-> ##2 $fell(valid) ;

	endproperty 

     	assert property  (end_of_trans);
clocking m_ckb @(posedge clk);
	//default input #1ns output #2ns;
	input ready;
	output valid, data;
endclocking 
clocking s_ckb @(posedge clk);
	//default input #1ns output #2ns;
	output ready;
	input valid, data;
endclocking 
clocking mon_ckb @(posedge clk);
	//default input #1ns output #2ns; 

	input valid, data, ready;
endclocking 
endinterface
