//An 8 bit pseudo random number generator
module random
   (
    input             clk,
    input             reset,
    output [7:0] num
    );

   logic [7:0] next;
	
   always_comb begin
      next = num;
		//shift 8 times
      repeat(8) begin
         next = {(next[7]^next[1]), next[7:1]};
      end
   end

   always_ff @(posedge clk or negedge reset) 
	begin
      if(reset == 1'b0)
			//Set the seed, can be anything
         num <= 8'h55;
      else
         num <= next;
      
   end

endmodule