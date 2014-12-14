/*
Top level module that contains everything
*/
module processor(input	Clk, Reset,start,
						input [15:0] switches,	
							
							// VGA Interface 
								output [7:0]  Red,
							                Green,
												 Blue,
							  output        VGA_clk,
							                sync,
												 blank,
												 vs,
												 hs,
							//HexDriver
							output logic [6:0]   Ahex0,
														Ahex1,
														Ahex2,
														Ahex3
);

logic [15:0] keys, opcode;



logic Reset_h,start_h,Reset_d,start_d,CPU_Clk;

//debounce
debouncer d1(start,Clk,start_d);
debouncer d2(Reset,Clk,Reset_d);  


always_comb
begin
start_h = ~start;
Reset_h = ~Reset;
end

//divide clock
frquency_divider cd(Clk,CPU_Clk);


logic[7:0] randnum; 
//calc random number
random r1(CPU_Clk,Reset,randnum[7:0]);

//set keys to switches
always_ff @ (posedge CPU_Clk) begin

keys<=switches;

end


logic [9:0] drawxsig, drawysig;
logic display [63:0][31:0];

logic [3:0] spriteh;
logic draw,drawdone,collision;

logic [7:0] destx,desty;

//create CPU
cpu chip8(CPU_Clk,Reset_h,start_h,keys,display,opcode,randnum);


	//Creat VGA controllor
	
   vga_controller vgasync_instance(.*,
	                                 .Clk(Clk),
	 										   .Reset(Reset_h),
	 										   .pixel_clk(VGA_clk),
	 										   .DrawX(drawxsig),
	 							 			   .DrawY(drawysig) );
    
	 //create a color Mapper
   color_mapper color_instance(.*,
		 								  .DrawX(drawxsig),
		 								  .DrawY(drawysig),
										  .display(display)
										  );
	
	//Write to Hex display the opcode
	HexDriver A0(.In0(opcode[3:0]),.Out0(Ahex0));
	HexDriver A1(.In0(opcode[7:4]),.Out0(Ahex1));
	HexDriver A2(.In0(opcode[11:8]),.Out0(Ahex2));
	HexDriver A3(.In0(opcode[15:12]),.Out0(Ahex3));

endmodule