//module to divide the clock frequency
//Right now it divides the frequency by 45,000

module frquency_divider(input clk ,output dclk);
reg [32:0] c;
always @ (posedge (clk)) begin
 if (c<90000)
  c <= c + 1;
 else   
  c <= 0;
end

always @ (c) begin
//if c < 45000 output 1 else 0
// this slows down the clock
 if (c<45000)
  dclk <= 1;
 else
  dclk <= 0;
end

endmodule