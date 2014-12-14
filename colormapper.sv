//This file was used to map the color black and white to the correct
//spots on the VGA moniter if the display is on vs off


module  color_mapper ( input [9:0] DrawX, DrawY,
							  input display [63:0][31:0],
                       output logic [7:0]  Red, Green, Blue );
    
    
	
	 
	 
    int Xc, Yc, locdisplay , displaysize;
	 
	
	 assign Xc = DrawX;
    assign Yc = DrawY;
	 assign displaysize = 32'd640;
	 
    assign locdisplay =(Yc*displaysize)+Xc;
	  

       
    always_comb
    begin:RGB_Display
	 /*
	 if(X==32'd64)
	        begin 
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
        end 
        else 
        begin 
            Red = 8'hff; 
            Green = 8'h00;
            Blue = 8'h00;
        end 
	 */
	 
	 if(locdisplay<32'd204800 && Xc<32'd640)
	 begin
			
    if ((display[DrawX/10][DrawY/10] == 1'b1)) 
        begin 
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end 
        else 
        begin 
            Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
        end   
	
	 end
	 else
	 begin
		      Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
	 end
	 
end    
endmodule
