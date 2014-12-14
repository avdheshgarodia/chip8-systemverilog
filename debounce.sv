module debouncer (input noisy, clk,
						output debounced);

logic [32:0] register;

//register: wait for stable speed
always @ (posedge clk) 
	begin
		register[32:0] <= {register[31:0],noisy}; //shift register
	if(register[32:0] == 32'b0)	//if the bounce happened during shift, ignore it.
		debounced <= 1'b0;
	else if(register[32:0] == 32'b1)	//if bounce happens after the shift,
		debounced <= 1'b1;	//pass the noisy value in.
	else debounced <= debounced;
end

endmodule