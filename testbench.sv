/*
THis is the test bench for the final project
Fairly straightforward for a CPU.
*/


module testbench();

timeunit 10ns; // Half clock cycle at 50Mhz
					//This is the amount of time represented by # 1
timeprecision 1ns;


//theese signals are internal because the processor will be
//instantiated as a submodule in testbench


logic Clk =0;
logic Reset, start;

logic [7:0]  Red, Green, Blue;
logic        VGA_clk,sync,blank,vs,hs;	
logic [15:0] switches;

	 logic [6:0]   Ahex0,Ahex1,Ahex2,Ahex3;

processor processor0(.*);

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk=0;
end

//intitial block is not synthesizable
//Everything in initial block is sequential

//Testing Begin


//We just have to tell CPU to start and it will automatically run whatever is in its memory
initial begin: TEST_VECTORS

Reset=0;
start=0;


#2 Reset = 1;

#2 Reset =0;

#2 start = 1;

#2 start =0;




end

endmodule

	
		
	


	

			