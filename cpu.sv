/*
The main CPU, this contains the logic to do everything.
THe programs are stored hare and if this code needs to be run 
programs can be selected

*/
module cpu(

	input	clk, reset,start,
	//the 16 input keys used to control the programs
	input	 [15:0] keys,
	output disp [63:0][31:0],
	output[15:0] opcode,
	input[7:0] randnum
	
);

reg [7:0] memory[4095:0];

reg [7:0] sprite[15:0];

reg [7:0] displaybuffer;

//logic [2047:0] display;

reg display[63:0][31:0];


logic [11:0] counter;

//Create the internal register array, 16 registers each 8 bits wide
//This is the register array of the CPU
//VF is used as a flag dont use
reg [7:0] V[15:0];


//The stack, this is used for subroutines
reg [15:0] STACK[15:0];

//These are the dleay and sound timer registers
reg [7:0] sound_timer;
reg [7:0] delay_timer;

reg [15:0] I;

//This is the IR that contains the current instructed to be executed
reg [15:0] IR;

//This is the PC
reg [15:0] PC;

//This is the stack pointer
reg [7:0] SP;

logic [8:0] addition;
logic [16:0] additionI;



//int X;
//Y,displaysize,loc_in_display;

//assign X=V[IR[11:8]];
//assign Y=V[IR[7:4]];

//assign displaysize = 32'd64;
//assign loc_in_display =(Y*displaysize)+X;

//logic [15:0] loc_in_display;

//signed_mult mult(loc_in_display, clk,8'd64, V[IR[7:4]],V[IR[11:8]]);

int i,j;

enum logic [3:0] {WAIT,FETCH,DECODE,DRAW_SETUP,DRAW_1,DRAW_1_1,DRAW_1_2,DRAW_1_3,DRAW_1_4,DRAW_2,DRAW_DONE} state, next_state;

always_ff @ (posedge clk) begin
	if (reset == 1'b1) 
		state <= WAIT;
	else 
	begin
		state <= next_state;
		
		case (state)
		WAIT:begin
		PC<=12'h200;
		
		
		
		for(i=0;i<64;i=i+1)
		begin
				for(j=0;j<32;j=j+1)
				begin
					display[i][j] <= 1'b0;
				end
		end
				
		
memory[12'h050] = 8'hF0; memory[12'h051] = 8'h90; memory[12'h052] = 8'h90; memory[12'h053] = 8'h90; memory[12'h054] = 8'hF0; // 0   
memory[12'h055] = 8'h20; memory[12'h056] = 8'h60; memory[12'h057] = 8'h20; memory[12'h058] = 8'h20; memory[12'h059] = 8'h70; // 1
memory[12'h05A] = 8'hF0; memory[12'h05B] = 8'h10; memory[12'h05C] = 8'hF0; memory[12'h05D] = 8'h80; memory[12'h05E] = 8'hF0; // 2
memory[12'h05F] = 8'hF0; memory[12'h060] = 8'h10; memory[12'h061] = 8'hF0; memory[12'h062] = 8'h10; memory[12'h063] = 8'hF0; // 3
memory[12'h064] = 8'h90; memory[12'h065] = 8'h90; memory[12'h066] = 8'hF0; memory[12'h067] = 8'h10; memory[12'h068] = 8'h10; // 4
memory[12'h069] = 8'hF0; memory[12'h06A] = 8'h80; memory[12'h06B] = 8'hF0; memory[12'h06C] = 8'h10; memory[12'h06D] = 8'hF0; // 5
memory[12'h06E] = 8'hF0; memory[12'h06F] = 8'h80; memory[12'h070] = 8'hF0; memory[12'h071] = 8'h90; memory[12'h072] = 8'hF0; // 6
memory[12'h073] = 8'hF0; memory[12'h074] = 8'h10; memory[12'h075] = 8'h20; memory[12'h076] = 8'h40; memory[12'h077] = 8'h40; // 7
memory[12'h078] = 8'hF0; memory[12'h079] = 8'h90; memory[12'h07A] = 8'hF0; memory[12'h07B] = 8'h90; memory[12'h07C] = 8'hF0; // 8
memory[12'h07D] = 8'hF0; memory[12'h07E] = 8'h90; memory[12'h07F] = 8'hF0; memory[12'h080] = 8'h10; memory[12'h081] = 8'hF0; // 9
memory[12'h082] = 8'hF0; memory[12'h083] = 8'h90; memory[12'h084] = 8'hF0; memory[12'h085] = 8'h90; memory[12'h086] = 8'h90; // A
memory[12'h087] = 8'hE0; memory[12'h088] = 8'h90; memory[12'h089] = 8'hE0; memory[12'h08A] = 8'h90; memory[12'h08B] = 8'hE0; // B
memory[12'h08C] = 8'hF0; memory[12'h08D] = 8'h80; memory[12'h08E] = 8'h80; memory[12'h08F] = 8'h80; memory[12'h090] = 8'hF0; // C
memory[12'h091] = 8'hE0; memory[12'h092] = 8'h90; memory[12'h093] = 8'h90; memory[12'h094] = 8'h90; memory[12'h095] = 8'hE0; // D
memory[12'h096] = 8'hF0; memory[12'h097] = 8'h80; memory[12'h098] = 8'hF0; memory[12'h099] = 8'h80; memory[12'h09A] = 8'hF0; // E
memory[12'h09B] = 8'hF0; memory[12'h09C] = 8'h80; memory[12'h09D] = 8'hF0; memory[12'h09E] = 8'h80; memory[12'h09F] = 8'h80;  // F
		
		
		
//PONG
/*		
memory[12'h200]=8'h22;
memory[12'h201]=8'hfc;
memory[12'h202]=8'h6b;
memory[12'h203]=8'h0c;
memory[12'h204]=8'h6c;
memory[12'h205]=8'h3f;
memory[12'h206]=8'h6d;
memory[12'h207]=8'h0c;
memory[12'h208]=8'ha2;
memory[12'h209]=8'hea;
memory[12'h20a]=8'hda;
memory[12'h20b]=8'hb6;
memory[12'h20c]=8'hdc;
memory[12'h20d]=8'hd6;
memory[12'h20e]=8'h6e;
memory[12'h20f]=8'h00;
memory[12'h210]=8'h22;
memory[12'h211]=8'hd4;
memory[12'h212]=8'h66;
memory[12'h213]=8'h03;
memory[12'h214]=8'h68;
memory[12'h215]=8'h02;
memory[12'h216]=8'h60;
memory[12'h217]=8'h60;
memory[12'h218]=8'hf0;
memory[12'h219]=8'h15;
memory[12'h21a]=8'hf0;
memory[12'h21b]=8'h07;
memory[12'h21c]=8'h30;
memory[12'h21d]=8'h00;
memory[12'h21e]=8'h12;
memory[12'h21f]=8'h1a;
memory[12'h220]=8'hc7;
memory[12'h221]=8'h17;
memory[12'h222]=8'h77;
memory[12'h223]=8'h08;
memory[12'h224]=8'h69;
memory[12'h225]=8'hff;
memory[12'h226]=8'ha2;
memory[12'h227]=8'hf0;
memory[12'h228]=8'hd6;
memory[12'h229]=8'h71;
memory[12'h22a]=8'ha2;
memory[12'h22b]=8'hea;
memory[12'h22c]=8'hda;
memory[12'h22d]=8'hb6;
memory[12'h22e]=8'hdc;
memory[12'h22f]=8'hd6;
memory[12'h230]=8'h60;
memory[12'h231]=8'h01;
memory[12'h232]=8'he0;
memory[12'h233]=8'ha1;
memory[12'h234]=8'h7b;
memory[12'h235]=8'hfe;
memory[12'h236]=8'h60;
memory[12'h237]=8'h04;
memory[12'h238]=8'he0;
memory[12'h239]=8'ha1;
memory[12'h23a]=8'h7b;
memory[12'h23b]=8'h02;
memory[12'h23c]=8'h60;
memory[12'h23d]=8'h1f;
memory[12'h23e]=8'h8b;
memory[12'h23f]=8'h02;
memory[12'h240]=8'hda;
memory[12'h241]=8'hb6;
memory[12'h242]=8'h60;
memory[12'h243]=8'h0c;
memory[12'h244]=8'he0;
memory[12'h245]=8'ha1;
memory[12'h246]=8'h7d;
memory[12'h247]=8'hfe;
memory[12'h248]=8'h60;
memory[12'h249]=8'h0d;
memory[12'h24a]=8'he0;
memory[12'h24b]=8'ha1;
memory[12'h24c]=8'h7d;
memory[12'h24d]=8'h02;
memory[12'h24e]=8'h60;
memory[12'h24f]=8'h1f;
memory[12'h250]=8'h8d;
memory[12'h251]=8'h02;
memory[12'h252]=8'hdc;
memory[12'h253]=8'hd6;
memory[12'h254]=8'ha2;
memory[12'h255]=8'hf0;
memory[12'h256]=8'hd6;
memory[12'h257]=8'h71;
memory[12'h258]=8'h86;
memory[12'h259]=8'h84;
memory[12'h25a]=8'h87;
memory[12'h25b]=8'h94;
memory[12'h25c]=8'h60;
memory[12'h25d]=8'h3f;
memory[12'h25e]=8'h86;
memory[12'h25f]=8'h02;
memory[12'h260]=8'h61;
memory[12'h261]=8'h1f;
memory[12'h262]=8'h87;
memory[12'h263]=8'h12;
memory[12'h264]=8'h46;
memory[12'h265]=8'h00;
memory[12'h266]=8'h12;
memory[12'h267]=8'h78;
memory[12'h268]=8'h46;
memory[12'h269]=8'h3f;
memory[12'h26a]=8'h12;
memory[12'h26b]=8'h82;
memory[12'h26c]=8'h47;
memory[12'h26d]=8'h1f;
memory[12'h26e]=8'h69;
memory[12'h26f]=8'hff;
memory[12'h270]=8'h47;
memory[12'h271]=8'h00;
memory[12'h272]=8'h69;
memory[12'h273]=8'h01;
memory[12'h274]=8'hd6;
memory[12'h275]=8'h71;
memory[12'h276]=8'h12;
memory[12'h277]=8'h2a;
memory[12'h278]=8'h68;
memory[12'h279]=8'h02;
memory[12'h27a]=8'h63;
memory[12'h27b]=8'h01;
memory[12'h27c]=8'h80;
memory[12'h27d]=8'h70;
memory[12'h27e]=8'h80;
memory[12'h27f]=8'hb5;
memory[12'h280]=8'h12;
memory[12'h281]=8'h8a;
memory[12'h282]=8'h68;
memory[12'h283]=8'hfe;
memory[12'h284]=8'h63;
memory[12'h285]=8'h0a;
memory[12'h286]=8'h80;
memory[12'h287]=8'h70;
memory[12'h288]=8'h80;
memory[12'h289]=8'hd5;
memory[12'h28a]=8'h3f;
memory[12'h28b]=8'h01;
memory[12'h28c]=8'h12;
memory[12'h28d]=8'ha2;
memory[12'h28e]=8'h61;
memory[12'h28f]=8'h02;
memory[12'h290]=8'h80;
memory[12'h291]=8'h15;
memory[12'h292]=8'h3f;
memory[12'h293]=8'h01;
memory[12'h294]=8'h12;
memory[12'h295]=8'hba;
memory[12'h296]=8'h80;
memory[12'h297]=8'h15;
memory[12'h298]=8'h3f;
memory[12'h299]=8'h01;
memory[12'h29a]=8'h12;
memory[12'h29b]=8'hc8;
memory[12'h29c]=8'h80;
memory[12'h29d]=8'h15;
memory[12'h29e]=8'h3f;
memory[12'h29f]=8'h01;
memory[12'h2a0]=8'h12;
memory[12'h2a1]=8'hc2;
memory[12'h2a2]=8'h60;
memory[12'h2a3]=8'h20;
memory[12'h2a4]=8'hf0;
memory[12'h2a5]=8'h18;
memory[12'h2a6]=8'h22;
memory[12'h2a7]=8'hd4;
memory[12'h2a8]=8'h8e;
memory[12'h2a9]=8'h34;
memory[12'h2aa]=8'h22;
memory[12'h2ab]=8'hd4;
memory[12'h2ac]=8'h66;
memory[12'h2ad]=8'h3e;
memory[12'h2ae]=8'h33;
memory[12'h2af]=8'h01;
memory[12'h2b0]=8'h66;
memory[12'h2b1]=8'h03;
memory[12'h2b2]=8'h68;
memory[12'h2b3]=8'hfe;
memory[12'h2b4]=8'h33;
memory[12'h2b5]=8'h01;
memory[12'h2b6]=8'h68;
memory[12'h2b7]=8'h02;
memory[12'h2b8]=8'h12;
memory[12'h2b9]=8'h16;
memory[12'h2ba]=8'h79;
memory[12'h2bb]=8'hff;
memory[12'h2bc]=8'h49;
memory[12'h2bd]=8'hfe;
memory[12'h2be]=8'h69;
memory[12'h2bf]=8'hff;
memory[12'h2c0]=8'h12;
memory[12'h2c1]=8'hc8;
memory[12'h2c2]=8'h79;
memory[12'h2c3]=8'h01;
memory[12'h2c4]=8'h49;
memory[12'h2c5]=8'h02;
memory[12'h2c6]=8'h69;
memory[12'h2c7]=8'h01;
memory[12'h2c8]=8'h60;
memory[12'h2c9]=8'h04;
memory[12'h2ca]=8'hf0;
memory[12'h2cb]=8'h18;
memory[12'h2cc]=8'h76;
memory[12'h2cd]=8'h01;
memory[12'h2ce]=8'h46;
memory[12'h2cf]=8'h40;
memory[12'h2d0]=8'h76;
memory[12'h2d1]=8'hfe;
memory[12'h2d2]=8'h12;
memory[12'h2d3]=8'h6c;
memory[12'h2d4]=8'ha2;
memory[12'h2d5]=8'hf2;
memory[12'h2d6]=8'hfe;
memory[12'h2d7]=8'h33;
memory[12'h2d8]=8'hf2;
memory[12'h2d9]=8'h65;
memory[12'h2da]=8'hf1;
memory[12'h2db]=8'h29;
memory[12'h2dc]=8'h64;
memory[12'h2dd]=8'h14;
memory[12'h2de]=8'h65;
memory[12'h2df]=8'h02;
memory[12'h2e0]=8'hd4;
memory[12'h2e1]=8'h55;
memory[12'h2e2]=8'h74;
memory[12'h2e3]=8'h15;
memory[12'h2e4]=8'hf2;
memory[12'h2e5]=8'h29;
memory[12'h2e6]=8'hd4;
memory[12'h2e7]=8'h55;
memory[12'h2e8]=8'h00;
memory[12'h2e9]=8'hee;
memory[12'h2ea]=8'h80;
memory[12'h2eb]=8'h80;
memory[12'h2ec]=8'h80;
memory[12'h2ed]=8'h80;
memory[12'h2ee]=8'h80;
memory[12'h2ef]=8'h80;
memory[12'h2f0]=8'h80;
memory[12'h2f1]=8'h00;
memory[12'h2f2]=8'h00;
memory[12'h2f3]=8'h00;
memory[12'h2f4]=8'h00;
memory[12'h2f5]=8'h00;
memory[12'h2f6]=8'hc0;
memory[12'h2f7]=8'hc0;
memory[12'h2f8]=8'hc0;
memory[12'h2f9]=8'h00;
memory[12'h2fa]=8'hff;
memory[12'h2fb]=8'h00;
memory[12'h2fc]=8'h6b;
memory[12'h2fd]=8'h20;
memory[12'h2fe]=8'h6c;
memory[12'h2ff]=8'h00;
memory[12'h300]=8'ha2;
memory[12'h301]=8'hf6;
memory[12'h302]=8'hdb;
memory[12'h303]=8'hc4;
memory[12'h304]=8'h7c;
memory[12'h305]=8'h04;
memory[12'h306]=8'h3c;
memory[12'h307]=8'h20;
memory[12'h308]=8'h13;
memory[12'h309]=8'h02;
memory[12'h30a]=8'h6a;
memory[12'h30b]=8'h00;
memory[12'h30c]=8'h6b;
memory[12'h30d]=8'h00;
memory[12'h30e]=8'h6c;
memory[12'h30f]=8'h1f;
memory[12'h310]=8'ha2;
memory[12'h311]=8'hfa;
memory[12'h312]=8'hda;
memory[12'h313]=8'hb1;
memory[12'h314]=8'hda;
memory[12'h315]=8'hc1;
memory[12'h316]=8'h7a;
memory[12'h317]=8'h08;
memory[12'h318]=8'h3a;
memory[12'h319]=8'h40;
memory[12'h31a]=8'h13;
memory[12'h31b]=8'h12;
memory[12'h31c]=8'ha2;
memory[12'h31d]=8'hf6;
memory[12'h31e]=8'h6a;
memory[12'h31f]=8'h00;
memory[12'h320]=8'h6b;
memory[12'h321]=8'h20;
memory[12'h322]=8'hdb;
memory[12'h323]=8'ha1;
memory[12'h324]=8'h00;
memory[12'h325]=8'hee;
*/

//Pacman	
/*	
memory[12'h200]=8'h12;
memory[12'h201]=8'h1a;
memory[12'h202]=8'h32;
memory[12'h203]=8'h2e;
memory[12'h204]=8'h30;
memory[12'h205]=8'h30;
memory[12'h206]=8'h20;
memory[12'h207]=8'h43;
memory[12'h208]=8'h2e;
memory[12'h209]=8'h20;
memory[12'h20a]=8'h45;
memory[12'h20b]=8'h67;
memory[12'h20c]=8'h65;
memory[12'h20d]=8'h62;
memory[12'h20e]=8'h65;
memory[12'h20f]=8'h72;
memory[12'h210]=8'h67;
memory[12'h211]=8'h20;
memory[12'h212]=8'h31;
memory[12'h213]=8'h38;
memory[12'h214]=8'h2f;
memory[12'h215]=8'h38;
memory[12'h216]=8'h2d;
memory[12'h217]=8'h27;
memory[12'h218]=8'h39;
memory[12'h219]=8'h31;
memory[12'h21a]=8'h80;
memory[12'h21b]=8'h03;
memory[12'h21c]=8'h81;
memory[12'h21d]=8'h13;
memory[12'h21e]=8'ha8;
memory[12'h21f]=8'hc8;
memory[12'h220]=8'hf1;
memory[12'h221]=8'h55;
memory[12'h222]=8'h60;
memory[12'h223]=8'h05;
memory[12'h224]=8'ha8;
memory[12'h225]=8'hcc;
memory[12'h226]=8'hf0;
memory[12'h227]=8'h55;
memory[12'h228]=8'h87;
memory[12'h229]=8'h73;
memory[12'h22a]=8'h86;
memory[12'h22b]=8'h63;
memory[12'h22c]=8'h27;
memory[12'h22d]=8'h72;
memory[12'h22e]=8'h00;
memory[12'h22f]=8'he0;
memory[12'h230]=8'h27;
memory[12'h231]=8'h94;
memory[12'h232]=8'h6e;
memory[12'h233]=8'h40;
memory[12'h234]=8'h87;
memory[12'h235]=8'he2;
memory[12'h236]=8'h6e;
memory[12'h237]=8'h27;
memory[12'h238]=8'h87;
memory[12'h239]=8'he1;
memory[12'h23a]=8'h68;
memory[12'h23b]=8'h1a;
memory[12'h23c]=8'h69;
memory[12'h23d]=8'h0c;
memory[12'h23e]=8'h6a;
memory[12'h23f]=8'h38;
memory[12'h240]=8'h6b;
memory[12'h241]=8'h00;
memory[12'h242]=8'h6c;
memory[12'h243]=8'h02;
memory[12'h244]=8'h6d;
memory[12'h245]=8'h1a;
memory[12'h246]=8'h27;
memory[12'h247]=8'h50;
memory[12'h248]=8'ha8;
memory[12'h249]=8'hed;
memory[12'h24a]=8'hda;
memory[12'h24b]=8'hb4;
memory[12'h24c]=8'hdc;
memory[12'h24d]=8'hd4;
memory[12'h24e]=8'h23;
memory[12'h24f]=8'hd0;
memory[12'h250]=8'h3e;
memory[12'h251]=8'h00;
memory[12'h252]=8'h12;
memory[12'h253]=8'h7c;
memory[12'h254]=8'ha8;
memory[12'h255]=8'hcc;
memory[12'h256]=8'hf0;
memory[12'h257]=8'h65;
memory[12'h258]=8'h85;
memory[12'h259]=8'h00;
memory[12'h25a]=8'hc4;
memory[12'h25b]=8'hff;
memory[12'h25c]=8'h84;
memory[12'h25d]=8'h52;
memory[12'h25e]=8'h24;
memory[12'h25f]=8'hf6;
memory[12'h260]=8'hc4;
memory[12'h261]=8'hff;
memory[12'h262]=8'h84;
memory[12'h263]=8'h52;
memory[12'h264]=8'h26;
memory[12'h265]=8'h1e;
memory[12'h266]=8'h60;
memory[12'h267]=8'h01;
memory[12'h268]=8'he0;
memory[12'h269]=8'ha1;
memory[12'h26a]=8'h27;
memory[12'h26b]=8'hd6;
memory[12'h26c]=8'h36;
memory[12'h26d]=8'hf7;
memory[12'h26e]=8'h12;
memory[12'h26f]=8'h4e;
memory[12'h270]=8'h8e;
memory[12'h271]=8'h60;
memory[12'h272]=8'h28;
memory[12'h273]=8'h7a;
memory[12'h274]=8'h6e;
memory[12'h275]=8'h64;
memory[12'h276]=8'h28;
memory[12'h277]=8'h7a;
memory[12'h278]=8'h27;
memory[12'h279]=8'hd6;
memory[12'h27a]=8'h12;
memory[12'h27b]=8'h2a;
memory[12'h27c]=8'hf0;
memory[12'h27d]=8'h07;
memory[12'h27e]=8'h40;
memory[12'h27f]=8'h00;
memory[12'h280]=8'h13;
memory[12'h281]=8'h10;
memory[12'h282]=8'h80;
memory[12'h283]=8'h80;
memory[12'h284]=8'h80;
memory[12'h285]=8'h06;
memory[12'h286]=8'h81;
memory[12'h287]=8'ha0;
memory[12'h288]=8'h81;
memory[12'h289]=8'h06;
memory[12'h28a]=8'h80;
memory[12'h28b]=8'h15;
memory[12'h28c]=8'h40;
memory[12'h28d]=8'h00;
memory[12'h28e]=8'h12;
memory[12'h28f]=8'h9a;
memory[12'h290]=8'h40;
memory[12'h291]=8'h01;
memory[12'h292]=8'h12;
memory[12'h293]=8'h9a;
memory[12'h294]=8'h40;
memory[12'h295]=8'hff;
memory[12'h296]=8'h12;
memory[12'h297]=8'h9a;
memory[12'h298]=8'h12;
memory[12'h299]=8'hc8;
memory[12'h29a]=8'h80;
memory[12'h29b]=8'h90;
memory[12'h29c]=8'h80;
memory[12'h29d]=8'h06;
memory[12'h29e]=8'h81;
memory[12'h29f]=8'hb0;
memory[12'h2a0]=8'h81;
memory[12'h2a1]=8'h06;
memory[12'h2a2]=8'h80;
memory[12'h2a3]=8'h15;
memory[12'h2a4]=8'h40;
memory[12'h2a5]=8'h00;
memory[12'h2a6]=8'h12;
memory[12'h2a7]=8'hb2;
memory[12'h2a8]=8'h40;
memory[12'h2a9]=8'h01;
memory[12'h2aa]=8'h12;
memory[12'h2ab]=8'hb2;
memory[12'h2ac]=8'h40;
memory[12'h2ad]=8'hff;
memory[12'h2ae]=8'h12;
memory[12'h2af]=8'hb2;
memory[12'h2b0]=8'h12;
memory[12'h2b1]=8'hc8;
memory[12'h2b2]=8'ha8;
memory[12'h2b3]=8'hed;
memory[12'h2b4]=8'hda;
memory[12'h2b5]=8'hb4;
memory[12'h2b6]=8'h6a;
memory[12'h2b7]=8'h38;
memory[12'h2b8]=8'h6b;
memory[12'h2b9]=8'h00;
memory[12'h2ba]=8'hda;
memory[12'h2bb]=8'hb4;
memory[12'h2bc]=8'h6e;
memory[12'h2bd]=8'hf3;
memory[12'h2be]=8'h87;
memory[12'h2bf]=8'he2;
memory[12'h2c0]=8'h6e;
memory[12'h2c1]=8'h04;
memory[12'h2c2]=8'h87;
memory[12'h2c3]=8'he1;
memory[12'h2c4]=8'h6e;
memory[12'h2c5]=8'h32;
memory[12'h2c6]=8'h28;
memory[12'h2c7]=8'h7a;
memory[12'h2c8]=8'h80;
memory[12'h2c9]=8'h80;
memory[12'h2ca]=8'h80;
memory[12'h2cb]=8'h06;
memory[12'h2cc]=8'h81;
memory[12'h2cd]=8'hc0;
memory[12'h2ce]=8'h81;
memory[12'h2cf]=8'h06;
memory[12'h2d0]=8'h80;
memory[12'h2d1]=8'h15;
memory[12'h2d2]=8'h40;
memory[12'h2d3]=8'h00;
memory[12'h2d4]=8'h12;
memory[12'h2d5]=8'he0;
memory[12'h2d6]=8'h40;
memory[12'h2d7]=8'h01;
memory[12'h2d8]=8'h12;
memory[12'h2d9]=8'he0;
memory[12'h2da]=8'h40;
memory[12'h2db]=8'hff;
memory[12'h2dc]=8'h12;
memory[12'h2dd]=8'he0;
memory[12'h2de]=8'h12;
memory[12'h2df]=8'h54;
memory[12'h2e0]=8'h80;
memory[12'h2e1]=8'h90;
memory[12'h2e2]=8'h80;
memory[12'h2e3]=8'h06;
memory[12'h2e4]=8'h81;
memory[12'h2e5]=8'hd0;
memory[12'h2e6]=8'h81;
memory[12'h2e7]=8'h06;
memory[12'h2e8]=8'h80;
memory[12'h2e9]=8'h15;
memory[12'h2ea]=8'h40;
memory[12'h2eb]=8'h00;
memory[12'h2ec]=8'h12;
memory[12'h2ed]=8'hf8;
memory[12'h2ee]=8'h40;
memory[12'h2ef]=8'h01;
memory[12'h2f0]=8'h12;
memory[12'h2f1]=8'hf8;
memory[12'h2f2]=8'h40;
memory[12'h2f3]=8'hff;
memory[12'h2f4]=8'h12;
memory[12'h2f5]=8'hf8;
memory[12'h2f6]=8'h12;
memory[12'h2f7]=8'h54;
memory[12'h2f8]=8'ha8;
memory[12'h2f9]=8'hed;
memory[12'h2fa]=8'hdc;
memory[12'h2fb]=8'hd4;
memory[12'h2fc]=8'h6c;
memory[12'h2fd]=8'h02;
memory[12'h2fe]=8'h6d;
memory[12'h2ff]=8'h1a;
memory[12'h300]=8'hdc;
memory[12'h301]=8'hd4;
memory[12'h302]=8'h6e;
memory[12'h303]=8'hcf;
memory[12'h304]=8'h87;
memory[12'h305]=8'he2;
memory[12'h306]=8'h6e;
memory[12'h307]=8'h20;
memory[12'h308]=8'h87;
memory[12'h309]=8'he1;
memory[12'h30a]=8'h6e;
memory[12'h30b]=8'h19;
memory[12'h30c]=8'h28;
memory[12'h30d]=8'h7a;
memory[12'h30e]=8'h12;
memory[12'h30f]=8'h54;
memory[12'h310]=8'h60;
memory[12'h311]=8'h3f;
memory[12'h312]=8'h28;
memory[12'h313]=8'ha8;
memory[12'h314]=8'h27;
memory[12'h315]=8'h50;
memory[12'h316]=8'ha8;
memory[12'h317]=8'hed;
memory[12'h318]=8'hda;
memory[12'h319]=8'hb4;
memory[12'h31a]=8'hdc;
memory[12'h31b]=8'hd4;
memory[12'h31c]=8'h6e;
memory[12'h31d]=8'h40;
memory[12'h31e]=8'h87;
memory[12'h31f]=8'he3;
memory[12'h320]=8'h80;
memory[12'h321]=8'h70;
memory[12'h322]=8'h80;
memory[12'h323]=8'he2;
memory[12'h324]=8'h30;
memory[12'h325]=8'h00;
memory[12'h326]=8'h12;
memory[12'h327]=8'h32;
memory[12'h328]=8'h8e;
memory[12'h329]=8'h60;
memory[12'h32a]=8'h28;
memory[12'h32b]=8'h7a;
memory[12'h32c]=8'h28;
memory[12'h32d]=8'h8a;
memory[12'h32e]=8'h00;
memory[12'h32f]=8'he0;
memory[12'h330]=8'h66;
memory[12'h331]=8'h11;
memory[12'h332]=8'h67;
memory[12'h333]=8'h0a;
memory[12'h334]=8'ha8;
memory[12'h335]=8'hca;
memory[12'h336]=8'h27;
memory[12'h337]=8'he6;
memory[12'h338]=8'h66;
memory[12'h339]=8'h11;
memory[12'h33a]=8'h67;
memory[12'h33b]=8'h10;
memory[12'h33c]=8'ha8;
memory[12'h33d]=8'hc8;
memory[12'h33e]=8'h27;
memory[12'h33f]=8'he6;
memory[12'h340]=8'h64;
memory[12'h341]=8'h00;
memory[12'h342]=8'h65;
memory[12'h343]=8'h08;
memory[12'h344]=8'h66;
memory[12'h345]=8'h00;
memory[12'h346]=8'h67;
memory[12'h347]=8'h0f;
memory[12'h348]=8'hab;
memory[12'h349]=8'h19;
memory[12'h34a]=8'hd4;
memory[12'h34b]=8'h69;
memory[12'h34c]=8'hab;
memory[12'h34d]=8'h22;
memory[12'h34e]=8'hd5;
memory[12'h34f]=8'h69;
memory[12'h350]=8'h60;
memory[12'h351]=8'h03;
memory[12'h352]=8'h28;
memory[12'h353]=8'ha8;
memory[12'h354]=8'h3e;
memory[12'h355]=8'h00;
memory[12'h356]=8'h13;
memory[12'h357]=8'hc6;
memory[12'h358]=8'hab;
memory[12'h359]=8'h19;
memory[12'h35a]=8'hd4;
memory[12'h35b]=8'h69;
memory[12'h35c]=8'hab;
memory[12'h35d]=8'h22;
memory[12'h35e]=8'hd5;
memory[12'h35f]=8'h69;
memory[12'h360]=8'h74;
memory[12'h361]=8'h02;
memory[12'h362]=8'h75;
memory[12'h363]=8'h02;
memory[12'h364]=8'h34;
memory[12'h365]=8'h30;
memory[12'h366]=8'h13;
memory[12'h367]=8'h48;
memory[12'h368]=8'hab;
memory[12'h369]=8'h19;
memory[12'h36a]=8'hd4;
memory[12'h36b]=8'h69;
memory[12'h36c]=8'hab;
memory[12'h36d]=8'h22;
memory[12'h36e]=8'hd5;
memory[12'h36f]=8'h69;
memory[12'h370]=8'h60;
memory[12'h371]=8'h03;
memory[12'h372]=8'h28;
memory[12'h373]=8'ha8;
memory[12'h374]=8'h3e;
memory[12'h375]=8'h00;
memory[12'h376]=8'h13;
memory[12'h377]=8'hc6;
memory[12'h378]=8'hab;
memory[12'h379]=8'h19;
memory[12'h37a]=8'hd4;
memory[12'h37b]=8'h69;
memory[12'h37c]=8'hab;
memory[12'h37d]=8'h22;
memory[12'h37e]=8'hd5;
memory[12'h37f]=8'h69;
memory[12'h380]=8'h76;
memory[12'h381]=8'h02;
memory[12'h382]=8'h36;
memory[12'h383]=8'h16;
memory[12'h384]=8'h13;
memory[12'h385]=8'h68;
memory[12'h386]=8'hab;
memory[12'h387]=8'h19;
memory[12'h388]=8'hd4;
memory[12'h389]=8'h69;
memory[12'h38a]=8'hab;
memory[12'h38b]=8'h22;
memory[12'h38c]=8'hd5;
memory[12'h38d]=8'h69;
memory[12'h38e]=8'h60;
memory[12'h38f]=8'h03;
memory[12'h390]=8'h28;
memory[12'h391]=8'ha8;
memory[12'h392]=8'h3e;
memory[12'h393]=8'h00;
memory[12'h394]=8'h13;
memory[12'h395]=8'hc6;
memory[12'h396]=8'hab;
memory[12'h397]=8'h19;
memory[12'h398]=8'hd4;
memory[12'h399]=8'h69;
memory[12'h39a]=8'hab;
memory[12'h39b]=8'h22;
memory[12'h39c]=8'hd5;
memory[12'h39d]=8'h69;
memory[12'h39e]=8'h74;
memory[12'h39f]=8'hfe;
memory[12'h3a0]=8'h75;
memory[12'h3a1]=8'hfe;
memory[12'h3a2]=8'h34;
memory[12'h3a3]=8'h00;
memory[12'h3a4]=8'h13;
memory[12'h3a5]=8'h86;
memory[12'h3a6]=8'hab;
memory[12'h3a7]=8'h19;
memory[12'h3a8]=8'hd4;
memory[12'h3a9]=8'h69;
memory[12'h3aa]=8'hab;
memory[12'h3ab]=8'h22;
memory[12'h3ac]=8'hd5;
memory[12'h3ad]=8'h69;
memory[12'h3ae]=8'h60;
memory[12'h3af]=8'h03;
memory[12'h3b0]=8'h28;
memory[12'h3b1]=8'ha8;
memory[12'h3b2]=8'h3e;
memory[12'h3b3]=8'h00;
memory[12'h3b4]=8'h13;
memory[12'h3b5]=8'hc6;
memory[12'h3b6]=8'hab;
memory[12'h3b7]=8'h19;
memory[12'h3b8]=8'hd4;
memory[12'h3b9]=8'h69;
memory[12'h3ba]=8'hab;
memory[12'h3bb]=8'h22;
memory[12'h3bc]=8'hd5;
memory[12'h3bd]=8'h69;
memory[12'h3be]=8'h76;
memory[12'h3bf]=8'hfe;
memory[12'h3c0]=8'h36;
memory[12'h3c1]=8'h00;
memory[12'h3c2]=8'h13;
memory[12'h3c3]=8'ha6;
memory[12'h3c4]=8'h13;
memory[12'h3c5]=8'h48;
memory[12'h3c6]=8'hab;
memory[12'h3c7]=8'h22;
memory[12'h3c8]=8'hd5;
memory[12'h3c9]=8'h69;
memory[12'h3ca]=8'hab;
memory[12'h3cb]=8'h2b;
memory[12'h3cc]=8'hd5;
memory[12'h3cd]=8'h69;
memory[12'h3ce]=8'h12;
memory[12'h3cf]=8'h1a;
memory[12'h3d0]=8'h83;
memory[12'h3d1]=8'h70;
memory[12'h3d2]=8'h6e;
memory[12'h3d3]=8'h03;
memory[12'h3d4]=8'h83;
memory[12'h3d5]=8'he2;
memory[12'h3d6]=8'h84;
memory[12'h3d7]=8'h80;
memory[12'h3d8]=8'h85;
memory[12'h3d9]=8'h90;
memory[12'h3da]=8'h6e;
memory[12'h3db]=8'h06;
memory[12'h3dc]=8'hee;
memory[12'h3dd]=8'ha1;
memory[12'h3de]=8'h14;
memory[12'h3df]=8'h32;
memory[12'h3e0]=8'h6e;
memory[12'h3e1]=8'h03;
memory[12'h3e2]=8'hee;
memory[12'h3e3]=8'ha1;
memory[12'h3e4]=8'h14;
memory[12'h3e5]=8'h4a;
memory[12'h3e6]=8'h6e;
memory[12'h3e7]=8'h08;
memory[12'h3e8]=8'hee;
memory[12'h3e9]=8'ha1;
memory[12'h3ea]=8'h14;
memory[12'h3eb]=8'h62;
memory[12'h3ec]=8'h6e;
memory[12'h3ed]=8'h07;
memory[12'h3ee]=8'hee;
memory[12'h3ef]=8'ha1;
memory[12'h3f0]=8'h14;
memory[12'h3f1]=8'h7a;
memory[12'h3f2]=8'h43;
memory[12'h3f3]=8'h03;
memory[12'h3f4]=8'h75;
memory[12'h3f5]=8'h02;
memory[12'h3f6]=8'h43;
memory[12'h3f7]=8'h00;
memory[12'h3f8]=8'h75;
memory[12'h3f9]=8'hfe;
memory[12'h3fa]=8'h43;
memory[12'h3fb]=8'h02;
memory[12'h3fc]=8'h74;
memory[12'h3fd]=8'h02;
memory[12'h3fe]=8'h43;
memory[12'h3ff]=8'h01;
memory[12'h400]=8'h74;
memory[12'h401]=8'hfe;
memory[12'h402]=8'h80;
memory[12'h403]=8'h40;
memory[12'h404]=8'h81;
memory[12'h405]=8'h50;
memory[12'h406]=8'h27;
memory[12'h407]=8'hba;
memory[12'h408]=8'h82;
memory[12'h409]=8'h00;
memory[12'h40a]=8'h6e;
memory[12'h40b]=8'h08;
memory[12'h40c]=8'h80;
memory[12'h40d]=8'he2;
memory[12'h40e]=8'h30;
memory[12'h40f]=8'h00;
memory[12'h410]=8'h14;
memory[12'h411]=8'h92;
memory[12'h412]=8'h6e;
memory[12'h413]=8'h07;
memory[12'h414]=8'h80;
memory[12'h415]=8'h20;
memory[12'h416]=8'h82;
memory[12'h417]=8'he2;
memory[12'h418]=8'h42;
memory[12'h419]=8'h05;
memory[12'h41a]=8'h14;
memory[12'h41b]=8'h9a;
memory[12'h41c]=8'h42;
memory[12'h41d]=8'h06;
memory[12'h41e]=8'h14;
memory[12'h41f]=8'hb2;
memory[12'h420]=8'h42;
memory[12'h421]=8'h07;
memory[12'h422]=8'h14;
memory[12'h423]=8'hec;
memory[12'h424]=8'h27;
memory[12'h425]=8'h50;
memory[12'h426]=8'h6e;
memory[12'h427]=8'hfc;
memory[12'h428]=8'h87;
memory[12'h429]=8'he2;
memory[12'h42a]=8'h87;
memory[12'h42b]=8'h31;
memory[12'h42c]=8'h88;
memory[12'h42d]=8'h40;
memory[12'h42e]=8'h89;
memory[12'h42f]=8'h50;
memory[12'h430]=8'h17;
memory[12'h431]=8'h50;
memory[12'h432]=8'h80;
memory[12'h433]=8'h40;
memory[12'h434]=8'h81;
memory[12'h435]=8'h50;
memory[12'h436]=8'h71;
memory[12'h437]=8'h02;
memory[12'h438]=8'h27;
memory[12'h439]=8'hba;
memory[12'h43a]=8'h82;
memory[12'h43b]=8'h00;
memory[12'h43c]=8'h6e;
memory[12'h43d]=8'h08;
memory[12'h43e]=8'h80;
memory[12'h43f]=8'he2;
memory[12'h440]=8'h30;
memory[12'h441]=8'h00;
memory[12'h442]=8'h13;
memory[12'h443]=8'hf2;
memory[12'h444]=8'h63;
memory[12'h445]=8'h03;
memory[12'h446]=8'h75;
memory[12'h447]=8'h02;
memory[12'h448]=8'h14;
memory[12'h449]=8'h0e;
memory[12'h44a]=8'h80;
memory[12'h44b]=8'h40;
memory[12'h44c]=8'h81;
memory[12'h44d]=8'h50;
memory[12'h44e]=8'h71;
memory[12'h44f]=8'hfe;
memory[12'h450]=8'h27;
memory[12'h451]=8'hba;
memory[12'h452]=8'h82;
memory[12'h453]=8'h00;
memory[12'h454]=8'h6e;
memory[12'h455]=8'h08;
memory[12'h456]=8'h80;
memory[12'h457]=8'he2;
memory[12'h458]=8'h30;
memory[12'h459]=8'h00;
memory[12'h45a]=8'h13;
memory[12'h45b]=8'hf2;
memory[12'h45c]=8'h63;
memory[12'h45d]=8'h00;
memory[12'h45e]=8'h75;
memory[12'h45f]=8'hfe;
memory[12'h460]=8'h14;
memory[12'h461]=8'h0e;
memory[12'h462]=8'h80;
memory[12'h463]=8'h40;
memory[12'h464]=8'h81;
memory[12'h465]=8'h50;
memory[12'h466]=8'h70;
memory[12'h467]=8'h02;
memory[12'h468]=8'h27;
memory[12'h469]=8'hba;
memory[12'h46a]=8'h82;
memory[12'h46b]=8'h00;
memory[12'h46c]=8'h6e;
memory[12'h46d]=8'h08;
memory[12'h46e]=8'h80;
memory[12'h46f]=8'he2;
memory[12'h470]=8'h30;
memory[12'h471]=8'h00;
memory[12'h472]=8'h13;
memory[12'h473]=8'hf2;
memory[12'h474]=8'h63;
memory[12'h475]=8'h02;
memory[12'h476]=8'h74;
memory[12'h477]=8'h02;
memory[12'h478]=8'h14;
memory[12'h479]=8'h0e;
memory[12'h47a]=8'h80;
memory[12'h47b]=8'h40;
memory[12'h47c]=8'h81;
memory[12'h47d]=8'h50;
memory[12'h47e]=8'h70;
memory[12'h47f]=8'hfe;
memory[12'h480]=8'h27;
memory[12'h481]=8'hba;
memory[12'h482]=8'h82;
memory[12'h483]=8'h00;
memory[12'h484]=8'h6e;
memory[12'h485]=8'h08;
memory[12'h486]=8'h80;
memory[12'h487]=8'he2;
memory[12'h488]=8'h30;
memory[12'h489]=8'h00;
memory[12'h48a]=8'h13;
memory[12'h48b]=8'hf2;
memory[12'h48c]=8'h63;
memory[12'h48d]=8'h01;
memory[12'h48e]=8'h74;
memory[12'h48f]=8'hfe;
memory[12'h490]=8'h14;
memory[12'h491]=8'h0e;
memory[12'h492]=8'h27;
memory[12'h493]=8'h50;
memory[12'h494]=8'hd8;
memory[12'h495]=8'h94;
memory[12'h496]=8'h8e;
memory[12'h497]=8'hf0;
memory[12'h498]=8'h00;
memory[12'h499]=8'hee;
memory[12'h49a]=8'h6e;
memory[12'h49b]=8'hf0;
memory[12'h49c]=8'h80;
memory[12'h49d]=8'he2;
memory[12'h49e]=8'h80;
memory[12'h49f]=8'h31;
memory[12'h4a0]=8'hf0;
memory[12'h4a1]=8'h55;
memory[12'h4a2]=8'ha8;
memory[12'h4a3]=8'hf1;
memory[12'h4a4]=8'hd4;
memory[12'h4a5]=8'h54;
memory[12'h4a6]=8'h76;
memory[12'h4a7]=8'h01;
memory[12'h4a8]=8'h61;
memory[12'h4a9]=8'h05;
memory[12'h4aa]=8'hf0;
memory[12'h4ab]=8'h07;
memory[12'h4ac]=8'h40;
memory[12'h4ad]=8'h00;
memory[12'h4ae]=8'hf1;
memory[12'h4af]=8'h18;
memory[12'h4b0]=8'h14;
memory[12'h4b1]=8'h24;
memory[12'h4b2]=8'h6e;
memory[12'h4b3]=8'hf0;
memory[12'h4b4]=8'h80;
memory[12'h4b5]=8'he2;
memory[12'h4b6]=8'h80;
memory[12'h4b7]=8'h31;
memory[12'h4b8]=8'hf0;
memory[12'h4b9]=8'h55;
memory[12'h4ba]=8'ha8;
memory[12'h4bb]=8'hf5;
memory[12'h4bc]=8'hd4;
memory[12'h4bd]=8'h54;
memory[12'h4be]=8'h76;
memory[12'h4bf]=8'h04;
memory[12'h4c0]=8'h80;
memory[12'h4c1]=8'ha0;
memory[12'h4c2]=8'h81;
memory[12'h4c3]=8'hb0;
memory[12'h4c4]=8'h27;
memory[12'h4c5]=8'hba;
memory[12'h4c6]=8'h6e;
memory[12'h4c7]=8'hf0;
memory[12'h4c8]=8'h80;
memory[12'h4c9]=8'he2;
memory[12'h4ca]=8'h30;
memory[12'h4cb]=8'h00;
memory[12'h4cc]=8'h14;
memory[12'h4cd]=8'hd2;
memory[12'h4ce]=8'h6e;
memory[12'h4cf]=8'h0c;
memory[12'h4d0]=8'h87;
memory[12'h4d1]=8'he3;
memory[12'h4d2]=8'h80;
memory[12'h4d3]=8'hc0;
memory[12'h4d4]=8'h81;
memory[12'h4d5]=8'hd0;
memory[12'h4d6]=8'h27;
memory[12'h4d7]=8'hba;
memory[12'h4d8]=8'h6e;
memory[12'h4d9]=8'hf0;
memory[12'h4da]=8'h80;
memory[12'h4db]=8'he2;
memory[12'h4dc]=8'h30;
memory[12'h4dd]=8'h00;
memory[12'h4de]=8'h14;
memory[12'h4df]=8'he4;
memory[12'h4e0]=8'h6e;
memory[12'h4e1]=8'h30;
memory[12'h4e2]=8'h87;
memory[12'h4e3]=8'he3;
memory[12'h4e4]=8'h60;
memory[12'h4e5]=8'hff;
memory[12'h4e6]=8'hf0;
memory[12'h4e7]=8'h18;
memory[12'h4e8]=8'hf0;
memory[12'h4e9]=8'h15;
memory[12'h4ea]=8'h14;
memory[12'h4eb]=8'h24;
memory[12'h4ec]=8'h43;
memory[12'h4ed]=8'h01;
memory[12'h4ee]=8'h64;
memory[12'h4ef]=8'h3a;
memory[12'h4f0]=8'h43;
memory[12'h4f1]=8'h02;
memory[12'h4f2]=8'h64;
memory[12'h4f3]=8'h00;
memory[12'h4f4]=8'h14;
memory[12'h4f5]=8'h24;
memory[12'h4f6]=8'h82;
memory[12'h4f7]=8'h70;
memory[12'h4f8]=8'h83;
memory[12'h4f9]=8'h70;
memory[12'h4fa]=8'h6e;
memory[12'h4fb]=8'h0c;
memory[12'h4fc]=8'h82;
memory[12'h4fd]=8'he2;
memory[12'h4fe]=8'h80;
memory[12'h4ff]=8'ha0;
memory[12'h500]=8'h81;
memory[12'h501]=8'hb0;
memory[12'h502]=8'h27;
memory[12'h503]=8'hba;
memory[12'h504]=8'ha8;
memory[12'h505]=8'hed;
memory[12'h506]=8'h6e;
memory[12'h507]=8'hf0;
memory[12'h508]=8'h80;
memory[12'h509]=8'he2;
memory[12'h50a]=8'h30;
memory[12'h50b]=8'h00;
memory[12'h50c]=8'h15;
memory[12'h50d]=8'h24;
memory[12'h50e]=8'hda;
memory[12'h50f]=8'hb4;
memory[12'h510]=8'h42;
memory[12'h511]=8'h0c;
memory[12'h512]=8'h7b;
memory[12'h513]=8'h02;
memory[12'h514]=8'h42;
memory[12'h515]=8'h00;
memory[12'h516]=8'h7b;
memory[12'h517]=8'hfe;
memory[12'h518]=8'h42;
memory[12'h519]=8'h08;
memory[12'h51a]=8'h7a;
memory[12'h51b]=8'h02;
memory[12'h51c]=8'h42;
memory[12'h51d]=8'h04;
memory[12'h51e]=8'h7a;
memory[12'h51f]=8'hfe;
memory[12'h520]=8'hda;
memory[12'h521]=8'hb4;
memory[12'h522]=8'h00;
memory[12'h523]=8'hee;
memory[12'h524]=8'h6e;
memory[12'h525]=8'h80;
memory[12'h526]=8'hf1;
memory[12'h527]=8'h07;
memory[12'h528]=8'h31;
memory[12'h529]=8'h00;
memory[12'h52a]=8'h15;
memory[12'h52b]=8'hd4;
memory[12'h52c]=8'h34;
memory[12'h52d]=8'h00;
memory[12'h52e]=8'h15;
memory[12'h52f]=8'hd4;
memory[12'h530]=8'h81;
memory[12'h531]=8'h00;
memory[12'h532]=8'h83;
memory[12'h533]=8'h0e;
memory[12'h534]=8'h3f;
memory[12'h535]=8'h00;
memory[12'h536]=8'h15;
memory[12'h537]=8'h56;
memory[12'h538]=8'h83;
memory[12'h539]=8'h90;
memory[12'h53a]=8'h83;
memory[12'h53b]=8'hb5;
memory[12'h53c]=8'h4f;
memory[12'h53d]=8'h00;
memory[12'h53e]=8'h15;
memory[12'h53f]=8'h8c;
memory[12'h540]=8'h33;
memory[12'h541]=8'h00;
memory[12'h542]=8'h15;
memory[12'h543]=8'h74;
memory[12'h544]=8'h87;
memory[12'h545]=8'he3;
memory[12'h546]=8'h83;
memory[12'h547]=8'h80;
memory[12'h548]=8'h83;
memory[12'h549]=8'ha5;
memory[12'h54a]=8'h4f;
memory[12'h54b]=8'h00;
memory[12'h54c]=8'h15;
memory[12'h54d]=8'hbc;
memory[12'h54e]=8'h33;
memory[12'h54f]=8'h00;
memory[12'h550]=8'h15;
memory[12'h551]=8'ha4;
memory[12'h552]=8'h87;
memory[12'h553]=8'he3;
memory[12'h554]=8'h15;
memory[12'h555]=8'hd4;
memory[12'h556]=8'h83;
memory[12'h557]=8'h80;
memory[12'h558]=8'h83;
memory[12'h559]=8'ha5;
memory[12'h55a]=8'h4f;
memory[12'h55b]=8'h00;
memory[12'h55c]=8'h15;
memory[12'h55d]=8'hbc;
memory[12'h55e]=8'h33;
memory[12'h55f]=8'h00;
memory[12'h560]=8'h15;
memory[12'h561]=8'ha4;
memory[12'h562]=8'h87;
memory[12'h563]=8'he3;
memory[12'h564]=8'h83;
memory[12'h565]=8'h90;
memory[12'h566]=8'h83;
memory[12'h567]=8'hb5;
memory[12'h568]=8'h4f;
memory[12'h569]=8'h00;
memory[12'h56a]=8'h15;
memory[12'h56b]=8'h8c;
memory[12'h56c]=8'h33;
memory[12'h56d]=8'h00;
memory[12'h56e]=8'h15;
memory[12'h56f]=8'h74;
memory[12'h570]=8'h87;
memory[12'h571]=8'he3;
memory[12'h572]=8'h15;
memory[12'h573]=8'hd4;
memory[12'h574]=8'h63;
memory[12'h575]=8'h40;
memory[12'h576]=8'h81;
memory[12'h577]=8'h32;
memory[12'h578]=8'h41;
memory[12'h579]=8'h00;
memory[12'h57a]=8'h15;
memory[12'h57b]=8'hd4;
memory[12'h57c]=8'hda;
memory[12'h57d]=8'hb4;
memory[12'h57e]=8'h7b;
memory[12'h57f]=8'h02;
memory[12'h580]=8'hda;
memory[12'h581]=8'hb4;
memory[12'h582]=8'h6e;
memory[12'h583]=8'hf3;
memory[12'h584]=8'h87;
memory[12'h585]=8'he2;
memory[12'h586]=8'h62;
memory[12'h587]=8'h0c;
memory[12'h588]=8'h87;
memory[12'h589]=8'h21;
memory[12'h58a]=8'h00;
memory[12'h58b]=8'hee;
memory[12'h58c]=8'h63;
memory[12'h58d]=8'h10;
memory[12'h58e]=8'h81;
memory[12'h58f]=8'h32;
memory[12'h590]=8'h41;
memory[12'h591]=8'h00;
memory[12'h592]=8'h15;
memory[12'h593]=8'hd4;
memory[12'h594]=8'hda;
memory[12'h595]=8'hb4;
memory[12'h596]=8'h7b;
memory[12'h597]=8'hfe;
memory[12'h598]=8'hda;
memory[12'h599]=8'hb4;
memory[12'h59a]=8'h6e;
memory[12'h59b]=8'hf3;
memory[12'h59c]=8'h87;
memory[12'h59d]=8'he2;
memory[12'h59e]=8'h62;
memory[12'h59f]=8'h00;
memory[12'h5a0]=8'h87;
memory[12'h5a1]=8'h21;
memory[12'h5a2]=8'h00;
memory[12'h5a3]=8'hee;
memory[12'h5a4]=8'h63;
memory[12'h5a5]=8'h20;
memory[12'h5a6]=8'h81;
memory[12'h5a7]=8'h32;
memory[12'h5a8]=8'h41;
memory[12'h5a9]=8'h00;
memory[12'h5aa]=8'h15;
memory[12'h5ab]=8'hd4;
memory[12'h5ac]=8'hda;
memory[12'h5ad]=8'hb4;
memory[12'h5ae]=8'h7a;
memory[12'h5af]=8'h02;
memory[12'h5b0]=8'hda;
memory[12'h5b1]=8'hb4;
memory[12'h5b2]=8'h6e;
memory[12'h5b3]=8'hf3;
memory[12'h5b4]=8'h87;
memory[12'h5b5]=8'he2;
memory[12'h5b6]=8'h62;
memory[12'h5b7]=8'h08;
memory[12'h5b8]=8'h87;
memory[12'h5b9]=8'h21;
memory[12'h5ba]=8'h00;
memory[12'h5bb]=8'hee;
memory[12'h5bc]=8'h63;
memory[12'h5bd]=8'h80;
memory[12'h5be]=8'h81;
memory[12'h5bf]=8'h32;
memory[12'h5c0]=8'h41;
memory[12'h5c1]=8'h00;
memory[12'h5c2]=8'h15;
memory[12'h5c3]=8'hd4;
memory[12'h5c4]=8'hda;
memory[12'h5c5]=8'hb4;
memory[12'h5c6]=8'h7a;
memory[12'h5c7]=8'hfe;
memory[12'h5c8]=8'hda;
memory[12'h5c9]=8'hb4;
memory[12'h5ca]=8'h6e;
memory[12'h5cb]=8'hf3;
memory[12'h5cc]=8'h87;
memory[12'h5cd]=8'he2;
memory[12'h5ce]=8'h62;
memory[12'h5cf]=8'h04;
memory[12'h5d0]=8'h87;
memory[12'h5d1]=8'h21;
memory[12'h5d2]=8'h00;
memory[12'h5d3]=8'hee;
memory[12'h5d4]=8'hc1;
memory[12'h5d5]=8'hf0;
memory[12'h5d6]=8'h80;
memory[12'h5d7]=8'h12;
memory[12'h5d8]=8'h30;
memory[12'h5d9]=8'h00;
memory[12'h5da]=8'h15;
memory[12'h5db]=8'he4;
memory[12'h5dc]=8'h6e;
memory[12'h5dd]=8'h0c;
memory[12'h5de]=8'h87;
memory[12'h5df]=8'he3;
memory[12'h5e0]=8'h82;
memory[12'h5e1]=8'he3;
memory[12'h5e2]=8'h15;
memory[12'h5e3]=8'h0e;
memory[12'h5e4]=8'hda;
memory[12'h5e5]=8'hb4;
memory[12'h5e6]=8'h80;
memory[12'h5e7]=8'h0e;
memory[12'h5e8]=8'h4f;
memory[12'h5e9]=8'h00;
memory[12'h5ea]=8'h15;
memory[12'h5eb]=8'hf2;
memory[12'h5ec]=8'h62;
memory[12'h5ed]=8'h04;
memory[12'h5ee]=8'h7a;
memory[12'h5ef]=8'hfe;
memory[12'h5f0]=8'h16;
memory[12'h5f1]=8'h14;
memory[12'h5f2]=8'h80;
memory[12'h5f3]=8'h0e;
memory[12'h5f4]=8'h4f;
memory[12'h5f5]=8'h00;
memory[12'h5f6]=8'h15;
memory[12'h5f7]=8'hfe;
memory[12'h5f8]=8'h62;
memory[12'h5f9]=8'h0c;
memory[12'h5fa]=8'h7b;
memory[12'h5fb]=8'h02;
memory[12'h5fc]=8'h16;
memory[12'h5fd]=8'h14;
memory[12'h5fe]=8'h80;
memory[12'h5ff]=8'h0e;
memory[12'h600]=8'h4f;
memory[12'h601]=8'h00;
memory[12'h602]=8'h16;
memory[12'h603]=8'h0a;
memory[12'h604]=8'h62;
memory[12'h605]=8'h08;
memory[12'h606]=8'h7a;
memory[12'h607]=8'h02;
memory[12'h608]=8'h16;
memory[12'h609]=8'h14;
memory[12'h60a]=8'h80;
memory[12'h60b]=8'h0e;
memory[12'h60c]=8'h4f;
memory[12'h60d]=8'h00;
memory[12'h60e]=8'h15;
memory[12'h60f]=8'hdc;
memory[12'h610]=8'h62;
memory[12'h611]=8'h00;
memory[12'h612]=8'h7b;
memory[12'h613]=8'hfe;
memory[12'h614]=8'hda;
memory[12'h615]=8'hb4;
memory[12'h616]=8'h6e;
memory[12'h617]=8'hf3;
memory[12'h618]=8'h87;
memory[12'h619]=8'he2;
memory[12'h61a]=8'h87;
memory[12'h61b]=8'h21;
memory[12'h61c]=8'h00;
memory[12'h61d]=8'hee;
memory[12'h61e]=8'h82;
memory[12'h61f]=8'h70;
memory[12'h620]=8'h83;
memory[12'h621]=8'h70;
memory[12'h622]=8'h6e;
memory[12'h623]=8'h30;
memory[12'h624]=8'h82;
memory[12'h625]=8'he2;
memory[12'h626]=8'h80;
memory[12'h627]=8'hc0;
memory[12'h628]=8'h81;
memory[12'h629]=8'hd0;
memory[12'h62a]=8'h27;
memory[12'h62b]=8'hba;
memory[12'h62c]=8'ha8;
memory[12'h62d]=8'hed;
memory[12'h62e]=8'h6e;
memory[12'h62f]=8'hf0;
memory[12'h630]=8'h80;
memory[12'h631]=8'he2;
memory[12'h632]=8'h30;
memory[12'h633]=8'h00;
memory[12'h634]=8'h16;
memory[12'h635]=8'h4c;
memory[12'h636]=8'hdc;
memory[12'h637]=8'hd4;
memory[12'h638]=8'h42;
memory[12'h639]=8'h30;
memory[12'h63a]=8'h7d;
memory[12'h63b]=8'h02;
memory[12'h63c]=8'h42;
memory[12'h63d]=8'h00;
memory[12'h63e]=8'h7d;
memory[12'h63f]=8'hfe;
memory[12'h640]=8'h42;
memory[12'h641]=8'h20;
memory[12'h642]=8'h7c;
memory[12'h643]=8'h02;
memory[12'h644]=8'h42;
memory[12'h645]=8'h10;
memory[12'h646]=8'h7c;
memory[12'h647]=8'hfe;
memory[12'h648]=8'hdc;
memory[12'h649]=8'hd4;
memory[12'h64a]=8'h00;
memory[12'h64b]=8'hee;
memory[12'h64c]=8'h6e;
memory[12'h64d]=8'h80;
memory[12'h64e]=8'hf1;
memory[12'h64f]=8'h07;
memory[12'h650]=8'h31;
memory[12'h651]=8'h00;
memory[12'h652]=8'h17;
memory[12'h653]=8'h04;
memory[12'h654]=8'h34;
memory[12'h655]=8'h00;
memory[12'h656]=8'h17;
memory[12'h657]=8'h04;
memory[12'h658]=8'h81;
memory[12'h659]=8'h00;
memory[12'h65a]=8'h83;
memory[12'h65b]=8'h0e;
memory[12'h65c]=8'h4f;
memory[12'h65d]=8'h00;
memory[12'h65e]=8'h16;
memory[12'h65f]=8'h7e;
memory[12'h660]=8'h83;
memory[12'h661]=8'h90;
memory[12'h662]=8'h83;
memory[12'h663]=8'hd5;
memory[12'h664]=8'h4f;
memory[12'h665]=8'h00;
memory[12'h666]=8'h16;
memory[12'h667]=8'hb6;
memory[12'h668]=8'h33;
memory[12'h669]=8'h00;
memory[12'h66a]=8'h16;
memory[12'h66b]=8'h9c;
memory[12'h66c]=8'h87;
memory[12'h66d]=8'he3;
memory[12'h66e]=8'h83;
memory[12'h66f]=8'h80;
memory[12'h670]=8'h83;
memory[12'h671]=8'hc5;
memory[12'h672]=8'h4f;
memory[12'h673]=8'h00;
memory[12'h674]=8'h16;
memory[12'h675]=8'hea;
memory[12'h676]=8'h33;
memory[12'h677]=8'h00;
memory[12'h678]=8'h16;
memory[12'h679]=8'hd0;
memory[12'h67a]=8'h87;
memory[12'h67b]=8'he3;
memory[12'h67c]=8'h17;
memory[12'h67d]=8'h04;
memory[12'h67e]=8'h83;
memory[12'h67f]=8'h80;
memory[12'h680]=8'h83;
memory[12'h681]=8'hc5;
memory[12'h682]=8'h4f;
memory[12'h683]=8'h00;
memory[12'h684]=8'h16;
memory[12'h685]=8'hea;
memory[12'h686]=8'h33;
memory[12'h687]=8'h00;
memory[12'h688]=8'h16;
memory[12'h689]=8'hd0;
memory[12'h68a]=8'h87;
memory[12'h68b]=8'he3;
memory[12'h68c]=8'h83;
memory[12'h68d]=8'h90;
memory[12'h68e]=8'h83;
memory[12'h68f]=8'hd5;
memory[12'h690]=8'h4f;
memory[12'h691]=8'h00;
memory[12'h692]=8'h16;
memory[12'h693]=8'hb6;
memory[12'h694]=8'h33;
memory[12'h695]=8'h00;
memory[12'h696]=8'h16;
memory[12'h697]=8'h9c;
memory[12'h698]=8'h87;
memory[12'h699]=8'he3;
memory[12'h69a]=8'h17;
memory[12'h69b]=8'h04;
memory[12'h69c]=8'h63;
memory[12'h69d]=8'h40;
memory[12'h69e]=8'h81;
memory[12'h69f]=8'h32;
memory[12'h6a0]=8'h41;
memory[12'h6a1]=8'h00;
memory[12'h6a2]=8'h17;
memory[12'h6a3]=8'h04;
memory[12'h6a4]=8'hdc;
memory[12'h6a5]=8'hd4;
memory[12'h6a6]=8'h7d;
memory[12'h6a7]=8'h02;
memory[12'h6a8]=8'hdc;
memory[12'h6a9]=8'hd4;
memory[12'h6aa]=8'h87;
memory[12'h6ab]=8'he3;
memory[12'h6ac]=8'h6e;
memory[12'h6ad]=8'hcf;
memory[12'h6ae]=8'h87;
memory[12'h6af]=8'he2;
memory[12'h6b0]=8'h62;
memory[12'h6b1]=8'h30;
memory[12'h6b2]=8'h87;
memory[12'h6b3]=8'h21;
memory[12'h6b4]=8'h00;
memory[12'h6b5]=8'hee;
memory[12'h6b6]=8'h63;
memory[12'h6b7]=8'h10;
memory[12'h6b8]=8'h81;
memory[12'h6b9]=8'h32;
memory[12'h6ba]=8'h41;
memory[12'h6bb]=8'h00;
memory[12'h6bc]=8'h17;
memory[12'h6bd]=8'h04;
memory[12'h6be]=8'hdc;
memory[12'h6bf]=8'hd4;
memory[12'h6c0]=8'h7d;
memory[12'h6c1]=8'hfe;
memory[12'h6c2]=8'hdc;
memory[12'h6c3]=8'hd4;
memory[12'h6c4]=8'h87;
memory[12'h6c5]=8'he3;
memory[12'h6c6]=8'h6e;
memory[12'h6c7]=8'hcf;
memory[12'h6c8]=8'h87;
memory[12'h6c9]=8'he2;
memory[12'h6ca]=8'h62;
memory[12'h6cb]=8'h00;
memory[12'h6cc]=8'h87;
memory[12'h6cd]=8'h21;
memory[12'h6ce]=8'h00;
memory[12'h6cf]=8'hee;
memory[12'h6d0]=8'h63;
memory[12'h6d1]=8'h20;
memory[12'h6d2]=8'h81;
memory[12'h6d3]=8'h32;
memory[12'h6d4]=8'h41;
memory[12'h6d5]=8'h00;
memory[12'h6d6]=8'h17;
memory[12'h6d7]=8'h04;
memory[12'h6d8]=8'hdc;
memory[12'h6d9]=8'hd4;
memory[12'h6da]=8'h7c;
memory[12'h6db]=8'h02;
memory[12'h6dc]=8'hdc;
memory[12'h6dd]=8'hd4;
memory[12'h6de]=8'h87;
memory[12'h6df]=8'he3;
memory[12'h6e0]=8'h6e;
memory[12'h6e1]=8'hcf;
memory[12'h6e2]=8'h87;
memory[12'h6e3]=8'he2;
memory[12'h6e4]=8'h62;
memory[12'h6e5]=8'h20;
memory[12'h6e6]=8'h87;
memory[12'h6e7]=8'h21;
memory[12'h6e8]=8'h00;
memory[12'h6e9]=8'hee;
memory[12'h6ea]=8'h63;
memory[12'h6eb]=8'h80;
memory[12'h6ec]=8'h81;
memory[12'h6ed]=8'h32;
memory[12'h6ee]=8'h41;
memory[12'h6ef]=8'h00;
memory[12'h6f0]=8'h17;
memory[12'h6f1]=8'h04;
memory[12'h6f2]=8'hdc;
memory[12'h6f3]=8'hd4;
memory[12'h6f4]=8'h7c;
memory[12'h6f5]=8'hfe;
memory[12'h6f6]=8'hdc;
memory[12'h6f7]=8'hd4;
memory[12'h6f8]=8'h87;
memory[12'h6f9]=8'he3;
memory[12'h6fa]=8'h6e;
memory[12'h6fb]=8'hcf;
memory[12'h6fc]=8'h87;
memory[12'h6fd]=8'he2;
memory[12'h6fe]=8'h62;
memory[12'h6ff]=8'h10;
memory[12'h700]=8'h87;
memory[12'h701]=8'h21;
memory[12'h702]=8'h00;
memory[12'h703]=8'hee;
memory[12'h704]=8'hc1;
memory[12'h705]=8'hf0;
memory[12'h706]=8'h80;
memory[12'h707]=8'h12;
memory[12'h708]=8'h30;
memory[12'h709]=8'h00;
memory[12'h70a]=8'h17;
memory[12'h70b]=8'h16;
memory[12'h70c]=8'h87;
memory[12'h70d]=8'he3;
memory[12'h70e]=8'h6e;
memory[12'h70f]=8'h30;
memory[12'h710]=8'h87;
memory[12'h711]=8'he3;
memory[12'h712]=8'h82;
memory[12'h713]=8'he3;
memory[12'h714]=8'h16;
memory[12'h715]=8'h36;
memory[12'h716]=8'hdc;
memory[12'h717]=8'hd4;
memory[12'h718]=8'h80;
memory[12'h719]=8'h0e;
memory[12'h71a]=8'h4f;
memory[12'h71b]=8'h00;
memory[12'h71c]=8'h17;
memory[12'h71d]=8'h24;
memory[12'h71e]=8'h62;
memory[12'h71f]=8'h90;
memory[12'h720]=8'h7c;
memory[12'h721]=8'hfe;
memory[12'h722]=8'h17;
memory[12'h723]=8'h46;
memory[12'h724]=8'h80;
memory[12'h725]=8'h0e;
memory[12'h726]=8'h4f;
memory[12'h727]=8'h00;
memory[12'h728]=8'h17;
memory[12'h729]=8'h30;
memory[12'h72a]=8'h62;
memory[12'h72b]=8'h30;
memory[12'h72c]=8'h7d;
memory[12'h72d]=8'h02;
memory[12'h72e]=8'h17;
memory[12'h72f]=8'h46;
memory[12'h730]=8'h80;
memory[12'h731]=8'h0e;
memory[12'h732]=8'h4f;
memory[12'h733]=8'h00;
memory[12'h734]=8'h17;
memory[12'h735]=8'h3c;
memory[12'h736]=8'h62;
memory[12'h737]=8'ha0;
memory[12'h738]=8'h7c;
memory[12'h739]=8'h02;
memory[12'h73a]=8'h17;
memory[12'h73b]=8'h46;
memory[12'h73c]=8'h80;
memory[12'h73d]=8'h0e;
memory[12'h73e]=8'h4f;
memory[12'h73f]=8'h00;
memory[12'h740]=8'h17;
memory[12'h741]=8'h0c;
memory[12'h742]=8'h62;
memory[12'h743]=8'h00;
memory[12'h744]=8'h7d;
memory[12'h745]=8'hfe;
memory[12'h746]=8'hdc;
memory[12'h747]=8'hd4;
memory[12'h748]=8'h6e;
memory[12'h749]=8'h4f;
memory[12'h74a]=8'h87;
memory[12'h74b]=8'he2;
memory[12'h74c]=8'h87;
memory[12'h74d]=8'h21;
memory[12'h74e]=8'h00;
memory[12'h74f]=8'hee;
memory[12'h750]=8'h80;
memory[12'h751]=8'h70;
memory[12'h752]=8'h6e;
memory[12'h753]=8'h03;
memory[12'h754]=8'h80;
memory[12'h755]=8'he2;
memory[12'h756]=8'h80;
memory[12'h757]=8'h0e;
memory[12'h758]=8'h81;
memory[12'h759]=8'h80;
memory[12'h75a]=8'h81;
memory[12'h75b]=8'h94;
memory[12'h75c]=8'h6e;
memory[12'h75d]=8'h02;
memory[12'h75e]=8'h81;
memory[12'h75f]=8'he2;
memory[12'h760]=8'h41;
memory[12'h761]=8'h00;
memory[12'h762]=8'h70;
memory[12'h763]=8'h01;
memory[12'h764]=8'h80;
memory[12'h765]=8'h0e;
memory[12'h766]=8'h80;
memory[12'h767]=8'h0e;
memory[12'h768]=8'ha8;
memory[12'h769]=8'hcd;
memory[12'h76a]=8'hf0;
memory[12'h76b]=8'h1e;
memory[12'h76c]=8'hd8;
memory[12'h76d]=8'h94;
memory[12'h76e]=8'h8e;
memory[12'h76f]=8'hf0;
memory[12'h770]=8'h00;
memory[12'h771]=8'hee;
memory[12'h772]=8'h6e;
memory[12'h773]=8'h00;
memory[12'h774]=8'ha9;
memory[12'h775]=8'h19;
memory[12'h776]=8'hfe;
memory[12'h777]=8'h1e;
memory[12'h778]=8'hfe;
memory[12'h779]=8'h1e;
memory[12'h77a]=8'hfe;
memory[12'h77b]=8'h1e;
memory[12'h77c]=8'hfe;
memory[12'h77d]=8'h1e;
memory[12'h77e]=8'hf3;
memory[12'h77f]=8'h65;
memory[12'h780]=8'hab;
memory[12'h781]=8'h34;
memory[12'h782]=8'hfe;
memory[12'h783]=8'h1e;
memory[12'h784]=8'hfe;
memory[12'h785]=8'h1e;
memory[12'h786]=8'hfe;
memory[12'h787]=8'h1e;
memory[12'h788]=8'hfe;
memory[12'h789]=8'h1e;
memory[12'h78a]=8'hf3;
memory[12'h78b]=8'h55;
memory[12'h78c]=8'h7e;
memory[12'h78d]=8'h01;
memory[12'h78e]=8'h3e;
memory[12'h78f]=8'h80;
memory[12'h790]=8'h17;
memory[12'h791]=8'h74;
memory[12'h792]=8'h00;
memory[12'h793]=8'hee;
memory[12'h794]=8'h82;
memory[12'h795]=8'h23;
memory[12'h796]=8'h83;
memory[12'h797]=8'h33;
memory[12'h798]=8'h6e;
memory[12'h799]=8'h0f;
memory[12'h79a]=8'h80;
memory[12'h79b]=8'h20;
memory[12'h79c]=8'h81;
memory[12'h79d]=8'h30;
memory[12'h79e]=8'h27;
memory[12'h79f]=8'hbe;
memory[12'h7a0]=8'h80;
memory[12'h7a1]=8'he2;
memory[12'h7a2]=8'h80;
memory[12'h7a3]=8'h0e;
memory[12'h7a4]=8'ha8;
memory[12'h7a5]=8'hf9;
memory[12'h7a6]=8'hf0;
memory[12'h7a7]=8'h1e;
memory[12'h7a8]=8'hd2;
memory[12'h7a9]=8'h32;
memory[12'h7aa]=8'h72;
memory[12'h7ab]=8'h02;
memory[12'h7ac]=8'h32;
memory[12'h7ad]=8'h40;
memory[12'h7ae]=8'h17;
memory[12'h7af]=8'h9a;
memory[12'h7b0]=8'h82;
memory[12'h7b1]=8'h23;
memory[12'h7b2]=8'h73;
memory[12'h7b3]=8'h02;
memory[12'h7b4]=8'h43;
memory[12'h7b5]=8'h20;
memory[12'h7b6]=8'h00;
memory[12'h7b7]=8'hee;
memory[12'h7b8]=8'h17;
memory[12'h7b9]=8'h9a;
memory[12'h7ba]=8'h70;
memory[12'h7bb]=8'h02;
memory[12'h7bc]=8'h71;
memory[12'h7bd]=8'h02;
memory[12'h7be]=8'h80;
memory[12'h7bf]=8'h06;
memory[12'h7c0]=8'h81;
memory[12'h7c1]=8'h06;
memory[12'h7c2]=8'h81;
memory[12'h7c3]=8'h0e;
memory[12'h7c4]=8'h81;
memory[12'h7c5]=8'h0e;
memory[12'h7c6]=8'h81;
memory[12'h7c7]=8'h0e;
memory[12'h7c8]=8'h81;
memory[12'h7c9]=8'h0e;
memory[12'h7ca]=8'hab;
memory[12'h7cb]=8'h34;
memory[12'h7cc]=8'hf1;
memory[12'h7cd]=8'h1e;
memory[12'h7ce]=8'hf1;
memory[12'h7cf]=8'h1e;
memory[12'h7d0]=8'hf0;
memory[12'h7d1]=8'h1e;
memory[12'h7d2]=8'hf0;
memory[12'h7d3]=8'h65;
memory[12'h7d4]=8'h00;
memory[12'h7d5]=8'hee;
memory[12'h7d6]=8'ha8;
memory[12'h7d7]=8'hcc;
memory[12'h7d8]=8'hf0;
memory[12'h7d9]=8'h65;
memory[12'h7da]=8'h80;
memory[12'h7db]=8'h06;
memory[12'h7dc]=8'hf0;
memory[12'h7dd]=8'h55;
memory[12'h7de]=8'h60;
memory[12'h7df]=8'h01;
memory[12'h7e0]=8'he0;
memory[12'h7e1]=8'ha1;
memory[12'h7e2]=8'h17;
memory[12'h7e3]=8'he0;
memory[12'h7e4]=8'h00;
memory[12'h7e5]=8'hee;
memory[12'h7e6]=8'hf1;
memory[12'h7e7]=8'h65;
memory[12'h7e8]=8'h6e;
memory[12'h7e9]=8'h01;
memory[12'h7ea]=8'h84;
memory[12'h7eb]=8'h43;
memory[12'h7ec]=8'h82;
memory[12'h7ed]=8'h00;
memory[12'h7ee]=8'h83;
memory[12'h7ef]=8'h10;
memory[12'h7f0]=8'h65;
memory[12'h7f1]=8'h10;
memory[12'h7f2]=8'h83;
memory[12'h7f3]=8'h55;
memory[12'h7f4]=8'h4f;
memory[12'h7f5]=8'h00;
memory[12'h7f6]=8'h82;
memory[12'h7f7]=8'he5;
memory[12'h7f8]=8'h4f;
memory[12'h7f9]=8'h00;
memory[12'h7fa]=8'h18;
memory[12'h7fb]=8'h0c;
memory[12'h7fc]=8'h65;
memory[12'h7fd]=8'h27;
memory[12'h7fe]=8'h82;
memory[12'h7ff]=8'h55;
memory[12'h800]=8'h4f;
memory[12'h801]=8'h00;
memory[12'h802]=8'h18;
memory[12'h803]=8'h0c;
memory[12'h804]=8'h80;
memory[12'h805]=8'h20;
memory[12'h806]=8'h81;
memory[12'h807]=8'h30;
memory[12'h808]=8'h84;
memory[12'h809]=8'he4;
memory[12'h80a]=8'h17;
memory[12'h80b]=8'hf0;
memory[12'h80c]=8'hf4;
memory[12'h80d]=8'h29;
memory[12'h80e]=8'hd6;
memory[12'h80f]=8'h75;
memory[12'h810]=8'h76;
memory[12'h811]=8'h06;
memory[12'h812]=8'h84;
memory[12'h813]=8'h43;
memory[12'h814]=8'h82;
memory[12'h815]=8'h00;
memory[12'h816]=8'h83;
memory[12'h817]=8'h10;
memory[12'h818]=8'h65;
memory[12'h819]=8'he8;
memory[12'h81a]=8'h83;
memory[12'h81b]=8'h55;
memory[12'h81c]=8'h4f;
memory[12'h81d]=8'h00;
memory[12'h81e]=8'h82;
memory[12'h81f]=8'he5;
memory[12'h820]=8'h4f;
memory[12'h821]=8'h00;
memory[12'h822]=8'h18;
memory[12'h823]=8'h34;
memory[12'h824]=8'h65;
memory[12'h825]=8'h03;
memory[12'h826]=8'h82;
memory[12'h827]=8'h55;
memory[12'h828]=8'h4f;
memory[12'h829]=8'h00;
memory[12'h82a]=8'h18;
memory[12'h82b]=8'h34;
memory[12'h82c]=8'h80;
memory[12'h82d]=8'h20;
memory[12'h82e]=8'h81;
memory[12'h82f]=8'h30;
memory[12'h830]=8'h84;
memory[12'h831]=8'he4;
memory[12'h832]=8'h18;
memory[12'h833]=8'h18;
memory[12'h834]=8'hf4;
memory[12'h835]=8'h29;
memory[12'h836]=8'hd6;
memory[12'h837]=8'h75;
memory[12'h838]=8'h76;
memory[12'h839]=8'h06;
memory[12'h83a]=8'h84;
memory[12'h83b]=8'h43;
memory[12'h83c]=8'h82;
memory[12'h83d]=8'h00;
memory[12'h83e]=8'h83;
memory[12'h83f]=8'h10;
memory[12'h840]=8'h65;
memory[12'h841]=8'h64;
memory[12'h842]=8'h83;
memory[12'h843]=8'h55;
memory[12'h844]=8'h4f;
memory[12'h845]=8'h00;
memory[12'h846]=8'h82;
memory[12'h847]=8'he5;
memory[12'h848]=8'h4f;
memory[12'h849]=8'h00;
memory[12'h84a]=8'h18;
memory[12'h84b]=8'h54;
memory[12'h84c]=8'h80;
memory[12'h84d]=8'h20;
memory[12'h84e]=8'h81;
memory[12'h84f]=8'h30;
memory[12'h850]=8'h84;
memory[12'h851]=8'he4;
memory[12'h852]=8'h18;
memory[12'h853]=8'h40;
memory[12'h854]=8'hf4;
memory[12'h855]=8'h29;
memory[12'h856]=8'hd6;
memory[12'h857]=8'h75;
memory[12'h858]=8'h76;
memory[12'h859]=8'h06;
memory[12'h85a]=8'h84;
memory[12'h85b]=8'h43;
memory[12'h85c]=8'h82;
memory[12'h85d]=8'h00;
memory[12'h85e]=8'h83;
memory[12'h85f]=8'h10;
memory[12'h860]=8'h65;
memory[12'h861]=8'h0a;
memory[12'h862]=8'h83;
memory[12'h863]=8'h55;
memory[12'h864]=8'h4f;
memory[12'h865]=8'h00;
memory[12'h866]=8'h18;
memory[12'h867]=8'h6e;
memory[12'h868]=8'h81;
memory[12'h869]=8'h30;
memory[12'h86a]=8'h84;
memory[12'h86b]=8'he4;
memory[12'h86c]=8'h18;
memory[12'h86d]=8'h60;
memory[12'h86e]=8'hf4;
memory[12'h86f]=8'h29;
memory[12'h870]=8'hd6;
memory[12'h871]=8'h75;
memory[12'h872]=8'h76;
memory[12'h873]=8'h06;
memory[12'h874]=8'hf1;
memory[12'h875]=8'h29;
memory[12'h876]=8'hd6;
memory[12'h877]=8'h75;
memory[12'h878]=8'h00;
memory[12'h879]=8'hee;
memory[12'h87a]=8'ha8;
memory[12'h87b]=8'hc8;
memory[12'h87c]=8'hf1;
memory[12'h87d]=8'h65;
memory[12'h87e]=8'h81;
memory[12'h87f]=8'he4;
memory[12'h880]=8'h3f;
memory[12'h881]=8'h00;
memory[12'h882]=8'h70;
memory[12'h883]=8'h01;
memory[12'h884]=8'ha8;
memory[12'h885]=8'hc8;
memory[12'h886]=8'hf1;
memory[12'h887]=8'h55;
memory[12'h888]=8'h00;
memory[12'h889]=8'hee;
memory[12'h88a]=8'ha8;
memory[12'h88b]=8'hc8;
memory[12'h88c]=8'hf3;
memory[12'h88d]=8'h65;
memory[12'h88e]=8'h8e;
memory[12'h88f]=8'h00;
memory[12'h890]=8'h8e;
memory[12'h891]=8'h25;
memory[12'h892]=8'h4f;
memory[12'h893]=8'h00;
memory[12'h894]=8'h00;
memory[12'h895]=8'hee;
memory[12'h896]=8'h3e;
memory[12'h897]=8'h00;
memory[12'h898]=8'h18;
memory[12'h899]=8'ha2;
memory[12'h89a]=8'h8e;
memory[12'h89b]=8'h10;
memory[12'h89c]=8'h8e;
memory[12'h89d]=8'h35;
memory[12'h89e]=8'h4f;
memory[12'h89f]=8'h00;
memory[12'h8a0]=8'h00;
memory[12'h8a1]=8'hee;
memory[12'h8a2]=8'ha8;
memory[12'h8a3]=8'hca;
memory[12'h8a4]=8'hf1;
memory[12'h8a5]=8'h55;
memory[12'h8a6]=8'h00;
memory[12'h8a7]=8'hee;
memory[12'h8a8]=8'h8e;
memory[12'h8a9]=8'he3;
memory[12'h8aa]=8'h62;
memory[12'h8ab]=8'h0f;
memory[12'h8ac]=8'h63;
memory[12'h8ad]=8'hff;
memory[12'h8ae]=8'h61;
memory[12'h8af]=8'h10;
memory[12'h8b0]=8'he2;
memory[12'h8b1]=8'ha1;
memory[12'h8b2]=8'h18;
memory[12'h8b3]=8'hc4;
memory[12'h8b4]=8'h81;
memory[12'h8b5]=8'h34;
memory[12'h8b6]=8'h31;
memory[12'h8b7]=8'h00;
memory[12'h8b8]=8'h18;
memory[12'h8b9]=8'hb0;
memory[12'h8ba]=8'h61;
memory[12'h8bb]=8'h10;
memory[12'h8bc]=8'h80;
memory[12'h8bd]=8'h34;
memory[12'h8be]=8'h30;
memory[12'h8bf]=8'h00;
memory[12'h8c0]=8'h18;
memory[12'h8c1]=8'hb0;
memory[12'h8c2]=8'h00;
memory[12'h8c3]=8'hee;
memory[12'h8c4]=8'h6e;
memory[12'h8c5]=8'h01;
memory[12'h8c6]=8'h00;
memory[12'h8c7]=8'hee;
memory[12'h8c8]=8'h00;
memory[12'h8c9]=8'h00;
memory[12'h8ca]=8'h00;
memory[12'h8cb]=8'h00;
memory[12'h8cc]=8'h05;
memory[12'h8cd]=8'h00;
memory[12'h8ce]=8'h50;
memory[12'h8cf]=8'h70;
memory[12'h8d0]=8'h20;
memory[12'h8d1]=8'h00;
memory[12'h8d2]=8'h50;
memory[12'h8d3]=8'h70;
memory[12'h8d4]=8'h20;
memory[12'h8d5]=8'h00;
memory[12'h8d6]=8'h60;
memory[12'h8d7]=8'h30;
memory[12'h8d8]=8'h60;
memory[12'h8d9]=8'h00;
memory[12'h8da]=8'h60;
memory[12'h8db]=8'h30;
memory[12'h8dc]=8'h60;
memory[12'h8dd]=8'h00;
memory[12'h8de]=8'h30;
memory[12'h8df]=8'h60;
memory[12'h8e0]=8'h30;
memory[12'h8e1]=8'h00;
memory[12'h8e2]=8'h30;
memory[12'h8e3]=8'h60;
memory[12'h8e4]=8'h30;
memory[12'h8e5]=8'h00;
memory[12'h8e6]=8'h20;
memory[12'h8e7]=8'h70;
memory[12'h8e8]=8'h50;
memory[12'h8e9]=8'h00;
memory[12'h8ea]=8'h20;
memory[12'h8eb]=8'h70;
memory[12'h8ec]=8'h50;
memory[12'h8ed]=8'h00;
memory[12'h8ee]=8'h20;
memory[12'h8ef]=8'h70;
memory[12'h8f0]=8'h70;
memory[12'h8f1]=8'h00;
memory[12'h8f2]=8'h00;
memory[12'h8f3]=8'h20;
memory[12'h8f4]=8'h00;
memory[12'h8f5]=8'h00;
memory[12'h8f6]=8'h00;
memory[12'h8f7]=8'h00;
memory[12'h8f8]=8'h00;
memory[12'h8f9]=8'h00;
memory[12'h8fa]=8'h00;
memory[12'h8fb]=8'h00;
memory[12'h8fc]=8'h00;
memory[12'h8fd]=8'h00;
memory[12'h8fe]=8'h00;
memory[12'h8ff]=8'h00;
memory[12'h900]=8'h00;
memory[12'h901]=8'h00;
memory[12'h902]=8'h00;
memory[12'h903]=8'h80;
memory[12'h904]=8'h00;
memory[12'h905]=8'h00;
memory[12'h906]=8'h00;
memory[12'h907]=8'h00;
memory[12'h908]=8'h00;
memory[12'h909]=8'hc0;
memory[12'h90a]=8'h00;
memory[12'h90b]=8'h00;
memory[12'h90c]=8'h00;
memory[12'h90d]=8'h80;
memory[12'h90e]=8'h80;
memory[12'h90f]=8'h00;
memory[12'h910]=8'h00;
memory[12'h911]=8'hc0;
memory[12'h912]=8'h80;
memory[12'h913]=8'h80;
memory[12'h914]=8'h80;
memory[12'h915]=8'hc0;
memory[12'h916]=8'h00;
memory[12'h917]=8'h80;
memory[12'h918]=8'h00;
memory[12'h919]=8'h0c;
memory[12'h91a]=8'h08;
memory[12'h91b]=8'h08;
memory[12'h91c]=8'h08;
memory[12'h91d]=8'h08;
memory[12'h91e]=8'h08;
memory[12'h91f]=8'h08;
memory[12'h920]=8'h08;
memory[12'h921]=8'h08;
memory[12'h922]=8'h08;
memory[12'h923]=8'h08;
memory[12'h924]=8'h08;
memory[12'h925]=8'h08;
memory[12'h926]=8'h08;
memory[12'h927]=8'h08;
memory[12'h928]=8'h0d;
memory[12'h929]=8'h0c;
memory[12'h92a]=8'h08;
memory[12'h92b]=8'h08;
memory[12'h92c]=8'h08;
memory[12'h92d]=8'h08;
memory[12'h92e]=8'h08;
memory[12'h92f]=8'h08;
memory[12'h930]=8'h08;
memory[12'h931]=8'h08;
memory[12'h932]=8'h08;
memory[12'h933]=8'h08;
memory[12'h934]=8'h08;
memory[12'h935]=8'h08;
memory[12'h936]=8'h08;
memory[12'h937]=8'h08;
memory[12'h938]=8'h0d;
memory[12'h939]=8'h0a;
memory[12'h93a]=8'h65;
memory[12'h93b]=8'h05;
memory[12'h93c]=8'h05;
memory[12'h93d]=8'h05;
memory[12'h93e]=8'h05;
memory[12'h93f]=8'he5;
memory[12'h940]=8'h05;
memory[12'h941]=8'h05;
memory[12'h942]=8'he5;
memory[12'h943]=8'h05;
memory[12'h944]=8'h05;
memory[12'h945]=8'h05;
memory[12'h946]=8'h05;
memory[12'h947]=8'hc5;
memory[12'h948]=8'h0a;
memory[12'h949]=8'h0a;
memory[12'h94a]=8'h65;
memory[12'h94b]=8'h05;
memory[12'h94c]=8'h05;
memory[12'h94d]=8'h05;
memory[12'h94e]=8'h05;
memory[12'h94f]=8'he5;
memory[12'h950]=8'h05;
memory[12'h951]=8'h05;
memory[12'h952]=8'he5;
memory[12'h953]=8'h05;
memory[12'h954]=8'h05;
memory[12'h955]=8'h05;
memory[12'h956]=8'h05;
memory[12'h957]=8'hc5;
memory[12'h958]=8'h0a;
memory[12'h959]=8'h0a;
memory[12'h95a]=8'h05;
memory[12'h95b]=8'h0c;
memory[12'h95c]=8'h08;
memory[12'h95d]=8'h08;
memory[12'h95e]=8'h0f;
memory[12'h95f]=8'h05;
memory[12'h960]=8'h0c;
memory[12'h961]=8'h0d;
memory[12'h962]=8'h05;
memory[12'h963]=8'h08;
memory[12'h964]=8'h08;
memory[12'h965]=8'h08;
memory[12'h966]=8'h0d;
memory[12'h967]=8'h05;
memory[12'h968]=8'h0e;
memory[12'h969]=8'h0f;
memory[12'h96a]=8'h05;
memory[12'h96b]=8'h0c;
memory[12'h96c]=8'h08;
memory[12'h96d]=8'h08;
memory[12'h96e]=8'h0f;
memory[12'h96f]=8'h05;
memory[12'h970]=8'h0c;
memory[12'h971]=8'h0d;
memory[12'h972]=8'h05;
memory[12'h973]=8'h08;
memory[12'h974]=8'h08;
memory[12'h975]=8'h08;
memory[12'h976]=8'h0d;
memory[12'h977]=8'h05;
memory[12'h978]=8'h0a;
memory[12'h979]=8'h0a;
memory[12'h97a]=8'h05;
memory[12'h97b]=8'h0a;
memory[12'h97c]=8'h65;
memory[12'h97d]=8'h06;
memory[12'h97e]=8'h05;
memory[12'h97f]=8'h95;
memory[12'h980]=8'h0a;
memory[12'h981]=8'h0a;
memory[12'h982]=8'h35;
memory[12'h983]=8'h05;
memory[12'h984]=8'h05;
memory[12'h985]=8'hc5;
memory[12'h986]=8'h0a;
memory[12'h987]=8'h35;
memory[12'h988]=8'h05;
memory[12'h989]=8'h05;
memory[12'h98a]=8'h95;
memory[12'h98b]=8'h0a;
memory[12'h98c]=8'h65;
memory[12'h98d]=8'h05;
memory[12'h98e]=8'h05;
memory[12'h98f]=8'h95;
memory[12'h990]=8'h0a;
memory[12'h991]=8'h0a;
memory[12'h992]=8'h35;
memory[12'h993]=8'h05;
memory[12'h994]=8'h06;
memory[12'h995]=8'hc5;
memory[12'h996]=8'h0a;
memory[12'h997]=8'h05;
memory[12'h998]=8'h0a;
memory[12'h999]=8'h0a;
memory[12'h99a]=8'h05;
memory[12'h99b]=8'h0f;
memory[12'h99c]=8'h05;
memory[12'h99d]=8'h08;
memory[12'h99e]=8'h08;
memory[12'h99f]=8'h08;
memory[12'h9a0]=8'h08;
memory[12'h9a1]=8'h08;
memory[12'h9a2]=8'h0c;
memory[12'h9a3]=8'h08;
memory[12'h9a4]=8'h0f;
memory[12'h9a5]=8'h05;
memory[12'h9a6]=8'h08;
memory[12'h9a7]=8'h08;
memory[12'h9a8]=8'h08;
memory[12'h9a9]=8'h08;
memory[12'h9aa]=8'h08;
memory[12'h9ab]=8'h0f;
memory[12'h9ac]=8'h05;
memory[12'h9ad]=8'h08;
memory[12'h9ae]=8'h08;
memory[12'h9af]=8'h0c;
memory[12'h9b0]=8'h08;
memory[12'h9b1]=8'h08;
memory[12'h9b2]=8'h08;
memory[12'h9b3]=8'h08;
memory[12'h9b4]=8'h0f;
memory[12'h9b5]=8'h05;
memory[12'h9b6]=8'h0f;
memory[12'h9b7]=8'h05;
memory[12'h9b8]=8'h0a;
memory[12'h9b9]=8'h0a;
memory[12'h9ba]=8'h75;
memory[12'h9bb]=8'h05;
memory[12'h9bc]=8'hb5;
memory[12'h9bd]=8'h05;
memory[12'h9be]=8'h05;
memory[12'h9bf]=8'h05;
memory[12'h9c0]=8'h05;
memory[12'h9c1]=8'hc5;
memory[12'h9c2]=8'h0a;
memory[12'h9c3]=8'h65;
memory[12'h9c4]=8'h05;
memory[12'h9c5]=8'hb5;
memory[12'h9c6]=8'h05;
memory[12'h9c7]=8'he5;
memory[12'h9c8]=8'h05;
memory[12'h9c9]=8'h05;
memory[12'h9ca]=8'he5;
memory[12'h9cb]=8'h05;
memory[12'h9cc]=8'hb5;
memory[12'h9cd]=8'h05;
memory[12'h9ce]=8'hc5;
memory[12'h9cf]=8'h0a;
memory[12'h9d0]=8'h65;
memory[12'h9d1]=8'h05;
memory[12'h9d2]=8'h05;
memory[12'h9d3]=8'h05;
memory[12'h9d4]=8'h05;
memory[12'h9d5]=8'hb5;
memory[12'h9d6]=8'h05;
memory[12'h9d7]=8'hd5;
memory[12'h9d8]=8'h0a;
memory[12'h9d9]=8'h0a;
memory[12'h9da]=8'h05;
memory[12'h9db]=8'h0c;
memory[12'h9dc]=8'h08;
memory[12'h9dd]=8'h08;
memory[12'h9de]=8'h08;
memory[12'h9df]=8'h08;
memory[12'h9e0]=8'h0d;
memory[12'h9e1]=8'h05;
memory[12'h9e2]=8'h0f;
memory[12'h9e3]=8'h05;
memory[12'h9e4]=8'h0c;
memory[12'h9e5]=8'h08;
memory[12'h9e6]=8'h0f;
memory[12'h9e7]=8'h05;
memory[12'h9e8]=8'h08;
memory[12'h9e9]=8'h0f;
memory[12'h9ea]=8'h05;
memory[12'h9eb]=8'h08;
memory[12'h9ec]=8'h08;
memory[12'h9ed]=8'h0d;
memory[12'h9ee]=8'h05;
memory[12'h9ef]=8'h0f;
memory[12'h9f0]=8'h05;
memory[12'h9f1]=8'h0c;
memory[12'h9f2]=8'h08;
memory[12'h9f3]=8'h08;
memory[12'h9f4]=8'h08;
memory[12'h9f5]=8'h08;
memory[12'h9f6]=8'h0d;
memory[12'h9f7]=8'h05;
memory[12'h9f8]=8'h0a;
memory[12'h9f9]=8'h0f;
memory[12'h9fa]=8'h05;
memory[12'h9fb]=8'h0f;
memory[12'h9fc]=8'h65;
memory[12'h9fd]=8'h05;
memory[12'h9fe]=8'h05;
memory[12'h9ff]=8'hc5;
memory[12'ha00]=8'h0a;
memory[12'ha01]=8'h35;
memory[12'ha02]=8'he5;
memory[12'ha03]=8'h95;
memory[12'ha04]=8'h0a;
memory[12'ha05]=8'h65;
memory[12'ha06]=8'h05;
memory[12'ha07]=8'hb0;
memory[12'ha08]=8'h05;
memory[12'ha09]=8'h05;
memory[12'ha0a]=8'hb5;
memory[12'ha0b]=8'h05;
memory[12'ha0c]=8'hc5;
memory[12'ha0d]=8'h0a;
memory[12'ha0e]=8'h35;
memory[12'ha0f]=8'he5;
memory[12'ha10]=8'h95;
memory[12'ha11]=8'h0a;
memory[12'ha12]=8'h65;
memory[12'ha13]=8'h05;
memory[12'ha14]=8'h05;
memory[12'ha15]=8'hc5;
memory[12'ha16]=8'h0f;
memory[12'ha17]=8'h05;
memory[12'ha18]=8'h0f;
memory[12'ha19]=8'h07;
memory[12'ha1a]=8'h74;
memory[12'ha1b]=8'h05;
memory[12'ha1c]=8'hd5;
memory[12'ha1d]=8'h08;
memory[12'ha1e]=8'h0f;
memory[12'ha1f]=8'h05;
memory[12'ha20]=8'h0e;
memory[12'ha21]=8'h0f;
memory[12'ha22]=8'h05;
memory[12'ha23]=8'h08;
memory[12'ha24]=8'h0f;
memory[12'ha25]=8'h05;
memory[12'ha26]=8'h0c;
memory[12'ha27]=8'h08;
memory[12'ha28]=8'h08;
memory[12'ha29]=8'h08;
memory[12'ha2a]=8'h08;
memory[12'ha2b]=8'h0d;
memory[12'ha2c]=8'h05;
memory[12'ha2d]=8'h08;
memory[12'ha2e]=8'h0f;
memory[12'ha2f]=8'h05;
memory[12'ha30]=8'h08;
memory[12'ha31]=8'h0f;
memory[12'ha32]=8'h05;
memory[12'ha33]=8'h08;
memory[12'ha34]=8'h0f;
memory[12'ha35]=8'h75;
memory[12'ha36]=8'h05;
memory[12'ha37]=8'hd4;
memory[12'ha38]=8'h07;
memory[12'ha39]=8'h0a;
memory[12'ha3a]=8'h05;
memory[12'ha3b]=8'h0a;
memory[12'ha3c]=8'h35;
memory[12'ha3d]=8'h05;
memory[12'ha3e]=8'h05;
memory[12'ha3f]=8'hf5;
memory[12'ha40]=8'h05;
memory[12'ha41]=8'h05;
memory[12'ha42]=8'hb5;
memory[12'ha43]=8'h05;
memory[12'ha44]=8'h05;
memory[12'ha45]=8'hd5;
memory[12'ha46]=8'h08;
memory[12'ha47]=8'h08;
memory[12'ha48]=8'h0d;
memory[12'ha49]=8'h0c;
memory[12'ha4a]=8'h08;
memory[12'ha4b]=8'h0f;
memory[12'ha4c]=8'h75;
memory[12'ha4d]=8'h05;
memory[12'ha4e]=8'h05;
memory[12'ha4f]=8'hb5;
memory[12'ha50]=8'h05;
memory[12'ha51]=8'h05;
memory[12'ha52]=8'hf5;
memory[12'ha53]=8'h05;
memory[12'ha54]=8'h05;
memory[12'ha55]=8'h95;
memory[12'ha56]=8'h0a;
memory[12'ha57]=8'h05;
memory[12'ha58]=8'h0a;
memory[12'ha59]=8'h0a;
memory[12'ha5a]=8'h05;
memory[12'ha5b]=8'h08;
memory[12'ha5c]=8'h08;
memory[12'ha5d]=8'h08;
memory[12'ha5e]=8'h0d;
memory[12'ha5f]=8'h05;
memory[12'ha60]=8'h0c;
memory[12'ha61]=8'h08;
memory[12'ha62]=8'h08;
memory[12'ha63]=8'h08;
memory[12'ha64]=8'h0d;
memory[12'ha65]=8'h35;
memory[12'ha66]=8'h05;
memory[12'ha67]=8'hc5;
memory[12'ha68]=8'h0a;
memory[12'ha69]=8'h0a;
memory[12'ha6a]=8'h65;
memory[12'ha6b]=8'h05;
memory[12'ha6c]=8'h95;
memory[12'ha6d]=8'h0c;
memory[12'ha6e]=8'h08;
memory[12'ha6f]=8'h08;
memory[12'ha70]=8'h08;
memory[12'ha71]=8'h0d;
memory[12'ha72]=8'h05;
memory[12'ha73]=8'h0c;
memory[12'ha74]=8'h08;
memory[12'ha75]=8'h08;
memory[12'ha76]=8'h0f;
memory[12'ha77]=8'h05;
memory[12'ha78]=8'h0a;
memory[12'ha79]=8'h0a;
memory[12'ha7a]=8'h75;
memory[12'ha7b]=8'h05;
memory[12'ha7c]=8'h06;
memory[12'ha7d]=8'hc5;
memory[12'ha7e]=8'h0a;
memory[12'ha7f]=8'h05;
memory[12'ha80]=8'h08;
memory[12'ha81]=8'h08;
memory[12'ha82]=8'h08;
memory[12'ha83]=8'h08;
memory[12'ha84]=8'h08;
memory[12'ha85]=8'h08;
memory[12'ha86]=8'h0f;
memory[12'ha87]=8'h05;
memory[12'ha88]=8'h08;
memory[12'ha89]=8'h0f;
memory[12'ha8a]=8'h05;
memory[12'ha8b]=8'h08;
memory[12'ha8c]=8'h08;
memory[12'ha8d]=8'h08;
memory[12'ha8e]=8'h08;
memory[12'ha8f]=8'h08;
memory[12'ha90]=8'h08;
memory[12'ha91]=8'h0f;
memory[12'ha92]=8'h05;
memory[12'ha93]=8'h0a;
memory[12'ha94]=8'h65;
memory[12'ha95]=8'h06;
memory[12'ha96]=8'h05;
memory[12'ha97]=8'hd5;
memory[12'ha98]=8'h0a;
memory[12'ha99]=8'h0a;
memory[12'ha9a]=8'h05;
memory[12'ha9b]=8'h0c;
memory[12'ha9c]=8'h0d;
memory[12'ha9d]=8'h05;
memory[12'ha9e]=8'h0a;
memory[12'ha9f]=8'h35;
memory[12'haa0]=8'h05;
memory[12'haa1]=8'h05;
memory[12'haa2]=8'h05;
memory[12'haa3]=8'h05;
memory[12'haa4]=8'he5;
memory[12'haa5]=8'h05;
memory[12'haa6]=8'h05;
memory[12'haa7]=8'hf5;
memory[12'haa8]=8'h05;
memory[12'haa9]=8'h05;
memory[12'haaa]=8'hf5;
memory[12'haab]=8'h05;
memory[12'haac]=8'h05;
memory[12'haad]=8'he5;
memory[12'haae]=8'h05;
memory[12'haaf]=8'h05;
memory[12'hab0]=8'h05;
memory[12'hab1]=8'h05;
memory[12'hab2]=8'h95;
memory[12'hab3]=8'h0a;
memory[12'hab4]=8'h05;
memory[12'hab5]=8'h0c;
memory[12'hab6]=8'h0d;
memory[12'hab7]=8'h05;
memory[12'hab8]=8'h0a;
memory[12'hab9]=8'h0a;
memory[12'haba]=8'h05;
memory[12'habb]=8'h08;
memory[12'habc]=8'h0f;
memory[12'habd]=8'h05;
memory[12'habe]=8'h08;
memory[12'habf]=8'h08;
memory[12'hac0]=8'h08;
memory[12'hac1]=8'h08;
memory[12'hac2]=8'h08;
memory[12'hac3]=8'h0f;
memory[12'hac4]=8'h05;
memory[12'hac5]=8'h0c;
memory[12'hac6]=8'h0d;
memory[12'hac7]=8'h05;
memory[12'hac8]=8'h08;
memory[12'hac9]=8'h0f;
memory[12'haca]=8'h05;
memory[12'hacb]=8'h0c;
memory[12'hacc]=8'h0d;
memory[12'hacd]=8'h05;
memory[12'hace]=8'h08;
memory[12'hacf]=8'h08;
memory[12'had0]=8'h08;
memory[12'had1]=8'h08;
memory[12'had2]=8'h08;
memory[12'had3]=8'h0f;
memory[12'had4]=8'h05;
memory[12'had5]=8'h08;
memory[12'had6]=8'h0f;
memory[12'had7]=8'h05;
memory[12'had8]=8'h0a;
memory[12'had9]=8'h0a;
memory[12'hada]=8'h35;
memory[12'hadb]=8'h05;
memory[12'hadc]=8'h05;
memory[12'hadd]=8'hb5;
memory[12'hade]=8'h05;
memory[12'hadf]=8'h05;
memory[12'hae0]=8'h05;
memory[12'hae1]=8'h05;
memory[12'hae2]=8'h05;
memory[12'hae3]=8'h05;
memory[12'hae4]=8'h95;
memory[12'hae5]=8'h0a;
memory[12'hae6]=8'h0a;
memory[12'hae7]=8'h35;
memory[12'hae8]=8'h05;
memory[12'hae9]=8'h05;
memory[12'haea]=8'h95;
memory[12'haeb]=8'h0a;
memory[12'haec]=8'h0a;
memory[12'haed]=8'h35;
memory[12'haee]=8'h05;
memory[12'haef]=8'h05;
memory[12'haf0]=8'h05;
memory[12'haf1]=8'h05;
memory[12'haf2]=8'h05;
memory[12'haf3]=8'h05;
memory[12'haf4]=8'hb5;
memory[12'haf5]=8'h05;
memory[12'haf6]=8'h05;
memory[12'haf7]=8'h95;
memory[12'haf8]=8'h0a;
memory[12'haf9]=8'h08;
memory[12'hafa]=8'h08;
memory[12'hafb]=8'h08;
memory[12'hafc]=8'h08;
memory[12'hafd]=8'h08;
memory[12'hafe]=8'h08;
memory[12'haff]=8'h08;
memory[12'hb00]=8'h08;
memory[12'hb01]=8'h08;
memory[12'hb02]=8'h08;
memory[12'hb03]=8'h08;
memory[12'hb04]=8'h08;
memory[12'hb05]=8'h0f;
memory[12'hb06]=8'h08;
memory[12'hb07]=8'h08;
memory[12'hb08]=8'h08;
memory[12'hb09]=8'h08;
memory[12'hb0a]=8'h08;
memory[12'hb0b]=8'h0f;
memory[12'hb0c]=8'h08;
memory[12'hb0d]=8'h08;
memory[12'hb0e]=8'h08;
memory[12'hb0f]=8'h08;
memory[12'hb10]=8'h08;
memory[12'hb11]=8'h08;
memory[12'hb12]=8'h08;
memory[12'hb13]=8'h08;
memory[12'hb14]=8'h08;
memory[12'hb15]=8'h08;
memory[12'hb16]=8'h08;
memory[12'hb17]=8'h08;
memory[12'hb18]=8'h0f;
memory[12'hb19]=8'h3c;
memory[12'hb1a]=8'h42;
memory[12'hb1b]=8'h99;
memory[12'hb1c]=8'h99;
memory[12'hb1d]=8'h42;
memory[12'hb1e]=8'h3c;
memory[12'hb1f]=8'h01;
memory[12'hb20]=8'h10;
memory[12'hb21]=8'h0f;
memory[12'hb22]=8'h78;
memory[12'hb23]=8'h84;
memory[12'hb24]=8'h32;
memory[12'hb25]=8'h32;
memory[12'hb26]=8'h84;
memory[12'hb27]=8'h78;
memory[12'hb28]=8'h00;
memory[12'hb29]=8'h10;
memory[12'hb2a]=8'he0;
memory[12'hb2b]=8'h78;
memory[12'hb2c]=8'hfc;
memory[12'hb2d]=8'hfe;
memory[12'hb2e]=8'hfe;
memory[12'hb2f]=8'h84;
memory[12'hb30]=8'h78;
memory[12'hb31]=8'h00;
memory[12'hb32]=8'h10;
memory[12'hb33]=8'he0;		
*/		
/*
memory[12'h200]=8'h6e;
memory[12'h201]=8'h05;
memory[12'h202]=8'h65;
memory[12'h203]=8'h00;
memory[12'h204]=8'h6b;
memory[12'h205]=8'h06;
memory[12'h206]=8'h6a;
memory[12'h207]=8'h00;
memory[12'h208]=8'ha3;
memory[12'h209]=8'h0c;
memory[12'h20a]=8'hda;
memory[12'h20b]=8'hb1;
memory[12'h20c]=8'h7a;
memory[12'h20d]=8'h04;
memory[12'h20e]=8'h3a;
memory[12'h20f]=8'h40;
memory[12'h210]=8'h12;
memory[12'h211]=8'h08;
memory[12'h212]=8'h7b;
memory[12'h213]=8'h02;
memory[12'h214]=8'h3b;
memory[12'h215]=8'h12;
memory[12'h216]=8'h12;
memory[12'h217]=8'h06;
memory[12'h218]=8'h6c;
memory[12'h219]=8'h20;
memory[12'h21a]=8'h6d;
memory[12'h21b]=8'h1f;
memory[12'h21c]=8'ha3;
memory[12'h21d]=8'h10;
memory[12'h21e]=8'hdc;
memory[12'h21f]=8'hd1;
memory[12'h220]=8'h22;
memory[12'h221]=8'hf6;
memory[12'h222]=8'h60;
memory[12'h223]=8'h00;
memory[12'h224]=8'h61;
memory[12'h225]=8'h00;
memory[12'h226]=8'ha3;
memory[12'h227]=8'h12;
memory[12'h228]=8'hd0;
memory[12'h229]=8'h11;
memory[12'h22a]=8'h70;
memory[12'h22b]=8'h08;
memory[12'h22c]=8'ha3;
memory[12'h22d]=8'h0e;
memory[12'h22e]=8'hd0;
memory[12'h22f]=8'h11;
memory[12'h230]=8'h60;
memory[12'h231]=8'h40;
memory[12'h232]=8'hf0;
memory[12'h233]=8'h15;
memory[12'h234]=8'hf0;
memory[12'h235]=8'h07;
memory[12'h236]=8'h30;
memory[12'h237]=8'h00;
memory[12'h238]=8'h12;
memory[12'h239]=8'h34;
memory[12'h23a]=8'hc6;
memory[12'h23b]=8'h0f;
memory[12'h23c]=8'h67;
memory[12'h23d]=8'h1e;
memory[12'h23e]=8'h68;
memory[12'h23f]=8'h01;
memory[12'h240]=8'h69;
memory[12'h241]=8'hff;
memory[12'h242]=8'ha3;
memory[12'h243]=8'h0e;
memory[12'h244]=8'hd6;
memory[12'h245]=8'h71;
memory[12'h246]=8'ha3;
memory[12'h247]=8'h10;
memory[12'h248]=8'hdc;
memory[12'h249]=8'hd1;
memory[12'h24a]=8'h60;
memory[12'h24b]=8'h04;
memory[12'h24c]=8'he0;
memory[12'h24d]=8'ha1;
memory[12'h24e]=8'h7c;
memory[12'h24f]=8'hfe;
memory[12'h250]=8'h60;
memory[12'h251]=8'h06;
memory[12'h252]=8'he0;
memory[12'h253]=8'ha1;
memory[12'h254]=8'h7c;
memory[12'h255]=8'h02;
memory[12'h256]=8'h60;
memory[12'h257]=8'h3f;
memory[12'h258]=8'h8c;
memory[12'h259]=8'h02;
memory[12'h25a]=8'hdc;
memory[12'h25b]=8'hd1;
memory[12'h25c]=8'ha3;
memory[12'h25d]=8'h0e;
memory[12'h25e]=8'hd6;
memory[12'h25f]=8'h71;
memory[12'h260]=8'h86;
memory[12'h261]=8'h84;
memory[12'h262]=8'h87;
memory[12'h263]=8'h94;
memory[12'h264]=8'h60;
memory[12'h265]=8'h3f;
memory[12'h266]=8'h86;
memory[12'h267]=8'h02;
memory[12'h268]=8'h61;
memory[12'h269]=8'h1f;
memory[12'h26a]=8'h87;
memory[12'h26b]=8'h12;
memory[12'h26c]=8'h47;
memory[12'h26d]=8'h1f;
memory[12'h26e]=8'h12;
memory[12'h26f]=8'hac;
memory[12'h270]=8'h46;
memory[12'h271]=8'h00;
memory[12'h272]=8'h68;
memory[12'h273]=8'h01;
memory[12'h274]=8'h46;
memory[12'h275]=8'h3f;
memory[12'h276]=8'h68;
memory[12'h277]=8'hff;
memory[12'h278]=8'h47;
memory[12'h279]=8'h00;
memory[12'h27a]=8'h69;
memory[12'h27b]=8'h01;
memory[12'h27c]=8'hd6;
memory[12'h27d]=8'h71;
memory[12'h27e]=8'h3f;
memory[12'h27f]=8'h01;
memory[12'h280]=8'h12;
memory[12'h281]=8'haa;
memory[12'h282]=8'h47;
memory[12'h283]=8'h1f;
memory[12'h284]=8'h12;
memory[12'h285]=8'haa;
memory[12'h286]=8'h60;
memory[12'h287]=8'h05;
memory[12'h288]=8'h80;
memory[12'h289]=8'h75;
memory[12'h28a]=8'h3f;
memory[12'h28b]=8'h00;
memory[12'h28c]=8'h12;
memory[12'h28d]=8'haa;
memory[12'h28e]=8'h60;
memory[12'h28f]=8'h01;
memory[12'h290]=8'hf0;
memory[12'h291]=8'h18;
memory[12'h292]=8'h80;
memory[12'h293]=8'h60;
memory[12'h294]=8'h61;
memory[12'h295]=8'hfc;
memory[12'h296]=8'h80;
memory[12'h297]=8'h12;
memory[12'h298]=8'ha3;
memory[12'h299]=8'h0c;
memory[12'h29a]=8'hd0;
memory[12'h29b]=8'h71;
memory[12'h29c]=8'h60;
memory[12'h29d]=8'hfe;
memory[12'h29e]=8'h89;
memory[12'h29f]=8'h03;
memory[12'h2a0]=8'h22;
memory[12'h2a1]=8'hf6;
memory[12'h2a2]=8'h75;
memory[12'h2a3]=8'h01;
memory[12'h2a4]=8'h22;
memory[12'h2a5]=8'hf6;
memory[12'h2a6]=8'h45;
memory[12'h2a7]=8'h60;
memory[12'h2a8]=8'h12;
memory[12'h2a9]=8'hde;
memory[12'h2aa]=8'h12;
memory[12'h2ab]=8'h46;
memory[12'h2ac]=8'h69;
memory[12'h2ad]=8'hff;
memory[12'h2ae]=8'h80;
memory[12'h2af]=8'h60;
memory[12'h2b0]=8'h80;
memory[12'h2b1]=8'hc5;
memory[12'h2b2]=8'h3f;
memory[12'h2b3]=8'h01;
memory[12'h2b4]=8'h12;
memory[12'h2b5]=8'hca;
memory[12'h2b6]=8'h61;
memory[12'h2b7]=8'h02;
memory[12'h2b8]=8'h80;
memory[12'h2b9]=8'h15;
memory[12'h2ba]=8'h3f;
memory[12'h2bb]=8'h01;
memory[12'h2bc]=8'h12;
memory[12'h2bd]=8'he0;
memory[12'h2be]=8'h80;
memory[12'h2bf]=8'h15;
memory[12'h2c0]=8'h3f;
memory[12'h2c1]=8'h01;
memory[12'h2c2]=8'h12;
memory[12'h2c3]=8'hee;
memory[12'h2c4]=8'h80;
memory[12'h2c5]=8'h15;
memory[12'h2c6]=8'h3f;
memory[12'h2c7]=8'h01;
memory[12'h2c8]=8'h12;
memory[12'h2c9]=8'he8;
memory[12'h2ca]=8'h60;
memory[12'h2cb]=8'h20;
memory[12'h2cc]=8'hf0;
memory[12'h2cd]=8'h18;
memory[12'h2ce]=8'ha3;
memory[12'h2cf]=8'h0e;
memory[12'h2d0]=8'h7e;
memory[12'h2d1]=8'hff;
memory[12'h2d2]=8'h80;
memory[12'h2d3]=8'he0;
memory[12'h2d4]=8'h80;
memory[12'h2d5]=8'h04;
memory[12'h2d6]=8'h61;
memory[12'h2d7]=8'h00;
memory[12'h2d8]=8'hd0;
memory[12'h2d9]=8'h11;
memory[12'h2da]=8'h3e;
memory[12'h2db]=8'h00;
memory[12'h2dc]=8'h12;
memory[12'h2dd]=8'h30;
memory[12'h2de]=8'h12;
memory[12'h2df]=8'hde;
memory[12'h2e0]=8'h78;
memory[12'h2e1]=8'hff;
memory[12'h2e2]=8'h48;
memory[12'h2e3]=8'hfe;
memory[12'h2e4]=8'h68;
memory[12'h2e5]=8'hff;
memory[12'h2e6]=8'h12;
memory[12'h2e7]=8'hee;
memory[12'h2e8]=8'h78;
memory[12'h2e9]=8'h01;
memory[12'h2ea]=8'h48;
memory[12'h2eb]=8'h02;
memory[12'h2ec]=8'h68;
memory[12'h2ed]=8'h01;
memory[12'h2ee]=8'h60;
memory[12'h2ef]=8'h04;
memory[12'h2f0]=8'hf0;
memory[12'h2f1]=8'h18;
memory[12'h2f2]=8'h69;
memory[12'h2f3]=8'hff;
memory[12'h2f4]=8'h12;
memory[12'h2f5]=8'h70;
memory[12'h2f6]=8'ha3;
memory[12'h2f7]=8'h14;
memory[12'h2f8]=8'hf5;
memory[12'h2f9]=8'h33;
memory[12'h2fa]=8'hf2;
memory[12'h2fb]=8'h65;
memory[12'h2fc]=8'hf1;
memory[12'h2fd]=8'h29;
memory[12'h2fe]=8'h63;
memory[12'h2ff]=8'h37;
memory[12'h300]=8'h64;
memory[12'h301]=8'h00;
memory[12'h302]=8'hd3;
memory[12'h303]=8'h45;
memory[12'h304]=8'h73;
memory[12'h305]=8'h05;
memory[12'h306]=8'hf2;
memory[12'h307]=8'h29;
memory[12'h308]=8'hd3;
memory[12'h309]=8'h45;
memory[12'h30a]=8'h00;
memory[12'h30b]=8'hee;
memory[12'h30c]=8'hf0;
memory[12'h30d]=8'h00;
memory[12'h30e]=8'h80;
memory[12'h30f]=8'h00;
memory[12'h310]=8'hfc;
memory[12'h311]=8'h00;
memory[12'h312]=8'haa;
memory[12'h313]=8'h00;
memory[12'h314]=8'h00;
memory[12'h315]=8'h00;
memory[12'h316]=8'h00;
memory[12'h317]=8'h00;	
*/	

//Tetris
/*
memory[12'h200]=8'ha2;
memory[12'h201]=8'hb4;
memory[12'h202]=8'h23;
memory[12'h203]=8'he6;
memory[12'h204]=8'h22;
memory[12'h205]=8'hb6;
memory[12'h206]=8'h70;
memory[12'h207]=8'h01;
memory[12'h208]=8'hd0;
memory[12'h209]=8'h11;
memory[12'h20a]=8'h30;
memory[12'h20b]=8'h25;
memory[12'h20c]=8'h12;
memory[12'h20d]=8'h06;
memory[12'h20e]=8'h71;
memory[12'h20f]=8'hff;
memory[12'h210]=8'hd0;
memory[12'h211]=8'h11;
memory[12'h212]=8'h60;
memory[12'h213]=8'h1a;
memory[12'h214]=8'hd0;
memory[12'h215]=8'h11;
memory[12'h216]=8'h60;
memory[12'h217]=8'h25;
memory[12'h218]=8'h31;
memory[12'h219]=8'h00;
memory[12'h21a]=8'h12;
memory[12'h21b]=8'h0e;
memory[12'h21c]=8'hc4;
memory[12'h21d]=8'h70;
memory[12'h21e]=8'h44;
memory[12'h21f]=8'h70;
memory[12'h220]=8'h12;
memory[12'h221]=8'h1c;
memory[12'h222]=8'hc3;
memory[12'h223]=8'h03;
memory[12'h224]=8'h60;
memory[12'h225]=8'h1e;
memory[12'h226]=8'h61;
memory[12'h227]=8'h03;
memory[12'h228]=8'h22;
memory[12'h229]=8'h5c;
memory[12'h22a]=8'hf5;
memory[12'h22b]=8'h15;
memory[12'h22c]=8'hd0;
memory[12'h22d]=8'h14;
memory[12'h22e]=8'h3f;
memory[12'h22f]=8'h01;
memory[12'h230]=8'h12;
memory[12'h231]=8'h3c;
memory[12'h232]=8'hd0;
memory[12'h233]=8'h14;
memory[12'h234]=8'h71;
memory[12'h235]=8'hff;
memory[12'h236]=8'hd0;
memory[12'h237]=8'h14;
memory[12'h238]=8'h23;
memory[12'h239]=8'h40;
memory[12'h23a]=8'h12;
memory[12'h23b]=8'h1c;
memory[12'h23c]=8'he7;
memory[12'h23d]=8'ha1;
memory[12'h23e]=8'h22;
memory[12'h23f]=8'h72;
memory[12'h240]=8'he8;
memory[12'h241]=8'ha1;
memory[12'h242]=8'h22;
memory[12'h243]=8'h84;
memory[12'h244]=8'he9;
memory[12'h245]=8'ha1;
memory[12'h246]=8'h22;
memory[12'h247]=8'h96;
memory[12'h248]=8'he2;
memory[12'h249]=8'h9e;
memory[12'h24a]=8'h12;
memory[12'h24b]=8'h50;
memory[12'h24c]=8'h66;
memory[12'h24d]=8'h00;
memory[12'h24e]=8'hf6;
memory[12'h24f]=8'h15;
memory[12'h250]=8'hf6;
memory[12'h251]=8'h07;
memory[12'h252]=8'h36;
memory[12'h253]=8'h00;
memory[12'h254]=8'h12;
memory[12'h255]=8'h3c;
memory[12'h256]=8'hd0;
memory[12'h257]=8'h14;
memory[12'h258]=8'h71;
memory[12'h259]=8'h01;
memory[12'h25a]=8'h12;
memory[12'h25b]=8'h2a;
memory[12'h25c]=8'ha2;
memory[12'h25d]=8'hc4;
memory[12'h25e]=8'hf4;
memory[12'h25f]=8'h1e;
memory[12'h260]=8'h66;
memory[12'h261]=8'h00;
memory[12'h262]=8'h43;
memory[12'h263]=8'h01;
memory[12'h264]=8'h66;
memory[12'h265]=8'h04;
memory[12'h266]=8'h43;
memory[12'h267]=8'h02;
memory[12'h268]=8'h66;
memory[12'h269]=8'h08;
memory[12'h26a]=8'h43;
memory[12'h26b]=8'h03;
memory[12'h26c]=8'h66;
memory[12'h26d]=8'h0c;
memory[12'h26e]=8'hf6;
memory[12'h26f]=8'h1e;
memory[12'h270]=8'h00;
memory[12'h271]=8'hee;
memory[12'h272]=8'hd0;
memory[12'h273]=8'h14;
memory[12'h274]=8'h70;
memory[12'h275]=8'hff;
memory[12'h276]=8'h23;
memory[12'h277]=8'h34;
memory[12'h278]=8'h3f;
memory[12'h279]=8'h01;
memory[12'h27a]=8'h00;
memory[12'h27b]=8'hee;
memory[12'h27c]=8'hd0;
memory[12'h27d]=8'h14;
memory[12'h27e]=8'h70;
memory[12'h27f]=8'h01;
memory[12'h280]=8'h23;
memory[12'h281]=8'h34;
memory[12'h282]=8'h00;
memory[12'h283]=8'hee;
memory[12'h284]=8'hd0;
memory[12'h285]=8'h14;
memory[12'h286]=8'h70;
memory[12'h287]=8'h01;
memory[12'h288]=8'h23;
memory[12'h289]=8'h34;
memory[12'h28a]=8'h3f;
memory[12'h28b]=8'h01;
memory[12'h28c]=8'h00;
memory[12'h28d]=8'hee;
memory[12'h28e]=8'hd0;
memory[12'h28f]=8'h14;
memory[12'h290]=8'h70;
memory[12'h291]=8'hff;
memory[12'h292]=8'h23;
memory[12'h293]=8'h34;
memory[12'h294]=8'h00;
memory[12'h295]=8'hee;
memory[12'h296]=8'hd0;
memory[12'h297]=8'h14;
memory[12'h298]=8'h73;
memory[12'h299]=8'h01;
memory[12'h29a]=8'h43;
memory[12'h29b]=8'h04;
memory[12'h29c]=8'h63;
memory[12'h29d]=8'h00;
memory[12'h29e]=8'h22;
memory[12'h29f]=8'h5c;
memory[12'h2a0]=8'h23;
memory[12'h2a1]=8'h34;
memory[12'h2a2]=8'h3f;
memory[12'h2a3]=8'h01;
memory[12'h2a4]=8'h00;
memory[12'h2a5]=8'hee;
memory[12'h2a6]=8'hd0;
memory[12'h2a7]=8'h14;
memory[12'h2a8]=8'h73;
memory[12'h2a9]=8'hff;
memory[12'h2aa]=8'h43;
memory[12'h2ab]=8'hff;
memory[12'h2ac]=8'h63;
memory[12'h2ad]=8'h03;
memory[12'h2ae]=8'h22;
memory[12'h2af]=8'h5c;
memory[12'h2b0]=8'h23;
memory[12'h2b1]=8'h34;
memory[12'h2b2]=8'h00;
memory[12'h2b3]=8'hee;
memory[12'h2b4]=8'h80;
memory[12'h2b5]=8'h00;
memory[12'h2b6]=8'h67;
memory[12'h2b7]=8'h05;
memory[12'h2b8]=8'h68;
memory[12'h2b9]=8'h06;
memory[12'h2ba]=8'h69;
memory[12'h2bb]=8'h04;
memory[12'h2bc]=8'h61;
memory[12'h2bd]=8'h1f;
memory[12'h2be]=8'h65;
memory[12'h2bf]=8'h10;
memory[12'h2c0]=8'h62;
memory[12'h2c1]=8'h07;
memory[12'h2c2]=8'h00;
memory[12'h2c3]=8'hee;
memory[12'h2c4]=8'h40;
memory[12'h2c5]=8'he0;
memory[12'h2c6]=8'h00;
memory[12'h2c7]=8'h00;
memory[12'h2c8]=8'h40;
memory[12'h2c9]=8'hc0;
memory[12'h2ca]=8'h40;
memory[12'h2cb]=8'h00;
memory[12'h2cc]=8'h00;
memory[12'h2cd]=8'he0;
memory[12'h2ce]=8'h40;
memory[12'h2cf]=8'h00;
memory[12'h2d0]=8'h40;
memory[12'h2d1]=8'h60;
memory[12'h2d2]=8'h40;
memory[12'h2d3]=8'h00;
memory[12'h2d4]=8'h40;
memory[12'h2d5]=8'h40;
memory[12'h2d6]=8'h60;
memory[12'h2d7]=8'h00;
memory[12'h2d8]=8'h20;
memory[12'h2d9]=8'he0;
memory[12'h2da]=8'h00;
memory[12'h2db]=8'h00;
memory[12'h2dc]=8'hc0;
memory[12'h2dd]=8'h40;
memory[12'h2de]=8'h40;
memory[12'h2df]=8'h00;
memory[12'h2e0]=8'h00;
memory[12'h2e1]=8'he0;
memory[12'h2e2]=8'h80;
memory[12'h2e3]=8'h00;
memory[12'h2e4]=8'h40;
memory[12'h2e5]=8'h40;
memory[12'h2e6]=8'hc0;
memory[12'h2e7]=8'h00;
memory[12'h2e8]=8'h00;
memory[12'h2e9]=8'he0;
memory[12'h2ea]=8'h20;
memory[12'h2eb]=8'h00;
memory[12'h2ec]=8'h60;
memory[12'h2ed]=8'h40;
memory[12'h2ee]=8'h40;
memory[12'h2ef]=8'h00;
memory[12'h2f0]=8'h80;
memory[12'h2f1]=8'he0;
memory[12'h2f2]=8'h00;
memory[12'h2f3]=8'h00;
memory[12'h2f4]=8'h40;
memory[12'h2f5]=8'hc0;
memory[12'h2f6]=8'h80;
memory[12'h2f7]=8'h00;
memory[12'h2f8]=8'hc0;
memory[12'h2f9]=8'h60;
memory[12'h2fa]=8'h00;
memory[12'h2fb]=8'h00;
memory[12'h2fc]=8'h40;
memory[12'h2fd]=8'hc0;
memory[12'h2fe]=8'h80;
memory[12'h2ff]=8'h00;
memory[12'h300]=8'hc0;
memory[12'h301]=8'h60;
memory[12'h302]=8'h00;
memory[12'h303]=8'h00;
memory[12'h304]=8'h80;
memory[12'h305]=8'hc0;
memory[12'h306]=8'h40;
memory[12'h307]=8'h00;
memory[12'h308]=8'h00;
memory[12'h309]=8'h60;
memory[12'h30a]=8'hc0;
memory[12'h30b]=8'h00;
memory[12'h30c]=8'h80;
memory[12'h30d]=8'hc0;
memory[12'h30e]=8'h40;
memory[12'h30f]=8'h00;
memory[12'h310]=8'h00;
memory[12'h311]=8'h60;
memory[12'h312]=8'hc0;
memory[12'h313]=8'h00;
memory[12'h314]=8'hc0;
memory[12'h315]=8'hc0;
memory[12'h316]=8'h00;
memory[12'h317]=8'h00;
memory[12'h318]=8'hc0;
memory[12'h319]=8'hc0;
memory[12'h31a]=8'h00;
memory[12'h31b]=8'h00;
memory[12'h31c]=8'hc0;
memory[12'h31d]=8'hc0;
memory[12'h31e]=8'h00;
memory[12'h31f]=8'h00;
memory[12'h320]=8'hc0;
memory[12'h321]=8'hc0;
memory[12'h322]=8'h00;
memory[12'h323]=8'h00;
memory[12'h324]=8'h40;
memory[12'h325]=8'h40;
memory[12'h326]=8'h40;
memory[12'h327]=8'h40;
memory[12'h328]=8'h00;
memory[12'h329]=8'hf0;
memory[12'h32a]=8'h00;
memory[12'h32b]=8'h00;
memory[12'h32c]=8'h40;
memory[12'h32d]=8'h40;
memory[12'h32e]=8'h40;
memory[12'h32f]=8'h40;
memory[12'h330]=8'h00;
memory[12'h331]=8'hf0;
memory[12'h332]=8'h00;
memory[12'h333]=8'h00;
memory[12'h334]=8'hd0;
memory[12'h335]=8'h14;
memory[12'h336]=8'h66;
memory[12'h337]=8'h35;
memory[12'h338]=8'h76;
memory[12'h339]=8'hff;
memory[12'h33a]=8'h36;
memory[12'h33b]=8'h00;
memory[12'h33c]=8'h13;
memory[12'h33d]=8'h38;
memory[12'h33e]=8'h00;
memory[12'h33f]=8'hee;
memory[12'h340]=8'ha2;
memory[12'h341]=8'hb4;
memory[12'h342]=8'h8c;
memory[12'h343]=8'h10;
memory[12'h344]=8'h3c;
memory[12'h345]=8'h1e;
memory[12'h346]=8'h7c;
memory[12'h347]=8'h01;
memory[12'h348]=8'h3c;
memory[12'h349]=8'h1e;
memory[12'h34a]=8'h7c;
memory[12'h34b]=8'h01;
memory[12'h34c]=8'h3c;
memory[12'h34d]=8'h1e;
memory[12'h34e]=8'h7c;
memory[12'h34f]=8'h01;
memory[12'h350]=8'h23;
memory[12'h351]=8'h5e;
memory[12'h352]=8'h4b;
memory[12'h353]=8'h0a;
memory[12'h354]=8'h23;
memory[12'h355]=8'h72;
memory[12'h356]=8'h91;
memory[12'h357]=8'hc0;
memory[12'h358]=8'h00;
memory[12'h359]=8'hee;
memory[12'h35a]=8'h71;
memory[12'h35b]=8'h01;
memory[12'h35c]=8'h13;
memory[12'h35d]=8'h50;
memory[12'h35e]=8'h60;
memory[12'h35f]=8'h1b;
memory[12'h360]=8'h6b;
memory[12'h361]=8'h00;
memory[12'h362]=8'hd0;
memory[12'h363]=8'h11;
memory[12'h364]=8'h3f;
memory[12'h365]=8'h00;
memory[12'h366]=8'h7b;
memory[12'h367]=8'h01;
memory[12'h368]=8'hd0;
memory[12'h369]=8'h11;
memory[12'h36a]=8'h70;
memory[12'h36b]=8'h01;
memory[12'h36c]=8'h30;
memory[12'h36d]=8'h25;
memory[12'h36e]=8'h13;
memory[12'h36f]=8'h62;
memory[12'h370]=8'h00;
memory[12'h371]=8'hee;
memory[12'h372]=8'h60;
memory[12'h373]=8'h1b;
memory[12'h374]=8'hd0;
memory[12'h375]=8'h11;
memory[12'h376]=8'h70;
memory[12'h377]=8'h01;
memory[12'h378]=8'h30;
memory[12'h379]=8'h25;
memory[12'h37a]=8'h13;
memory[12'h37b]=8'h74;
memory[12'h37c]=8'h8e;
memory[12'h37d]=8'h10;
memory[12'h37e]=8'h8d;
memory[12'h37f]=8'he0;
memory[12'h380]=8'h7e;
memory[12'h381]=8'hff;
memory[12'h382]=8'h60;
memory[12'h383]=8'h1b;
memory[12'h384]=8'h6b;
memory[12'h385]=8'h00;
memory[12'h386]=8'hd0;
memory[12'h387]=8'he1;
memory[12'h388]=8'h3f;
memory[12'h389]=8'h00;
memory[12'h38a]=8'h13;
memory[12'h38b]=8'h90;
memory[12'h38c]=8'hd0;
memory[12'h38d]=8'he1;
memory[12'h38e]=8'h13;
memory[12'h38f]=8'h94;
memory[12'h390]=8'hd0;
memory[12'h391]=8'hd1;
memory[12'h392]=8'h7b;
memory[12'h393]=8'h01;
memory[12'h394]=8'h70;
memory[12'h395]=8'h01;
memory[12'h396]=8'h30;
memory[12'h397]=8'h25;
memory[12'h398]=8'h13;
memory[12'h399]=8'h86;
memory[12'h39a]=8'h4b;
memory[12'h39b]=8'h00;
memory[12'h39c]=8'h13;
memory[12'h39d]=8'ha6;
memory[12'h39e]=8'h7d;
memory[12'h39f]=8'hff;
memory[12'h3a0]=8'h7e;
memory[12'h3a1]=8'hff;
memory[12'h3a2]=8'h3d;
memory[12'h3a3]=8'h01;
memory[12'h3a4]=8'h13;
memory[12'h3a5]=8'h82;
memory[12'h3a6]=8'h23;
memory[12'h3a7]=8'hc0;
memory[12'h3a8]=8'h3f;
memory[12'h3a9]=8'h01;
memory[12'h3aa]=8'h23;
memory[12'h3ab]=8'hc0;
memory[12'h3ac]=8'h7a;
memory[12'h3ad]=8'h01;
memory[12'h3ae]=8'h23;
memory[12'h3af]=8'hc0;
memory[12'h3b0]=8'h80;
memory[12'h3b1]=8'ha0;
memory[12'h3b2]=8'h6d;
memory[12'h3b3]=8'h07;
memory[12'h3b4]=8'h80;
memory[12'h3b5]=8'hd2;
memory[12'h3b6]=8'h40;
memory[12'h3b7]=8'h04;
memory[12'h3b8]=8'h75;
memory[12'h3b9]=8'hfe;
memory[12'h3ba]=8'h45;
memory[12'h3bb]=8'h02;
memory[12'h3bc]=8'h65;
memory[12'h3bd]=8'h04;
memory[12'h3be]=8'h00;
memory[12'h3bf]=8'hee;
memory[12'h3c0]=8'ha7;
memory[12'h3c1]=8'h00;
memory[12'h3c2]=8'hf2;
memory[12'h3c3]=8'h55;
memory[12'h3c4]=8'ha8;
memory[12'h3c5]=8'h04;
memory[12'h3c6]=8'hfa;
memory[12'h3c7]=8'h33;
memory[12'h3c8]=8'hf2;
memory[12'h3c9]=8'h65;
memory[12'h3ca]=8'hf0;
memory[12'h3cb]=8'h29;
memory[12'h3cc]=8'h6d;
memory[12'h3cd]=8'h32;
memory[12'h3ce]=8'h6e;
memory[12'h3cf]=8'h00;
memory[12'h3d0]=8'hdd;
memory[12'h3d1]=8'he5;
memory[12'h3d2]=8'h7d;
memory[12'h3d3]=8'h05;
memory[12'h3d4]=8'hf1;
memory[12'h3d5]=8'h29;
memory[12'h3d6]=8'hdd;
memory[12'h3d7]=8'he5;
memory[12'h3d8]=8'h7d;
memory[12'h3d9]=8'h05;
memory[12'h3da]=8'hf2;
memory[12'h3db]=8'h29;
memory[12'h3dc]=8'hdd;
memory[12'h3dd]=8'he5;
memory[12'h3de]=8'ha7;
memory[12'h3df]=8'h00;
memory[12'h3e0]=8'hf2;
memory[12'h3e1]=8'h65;
memory[12'h3e2]=8'ha2;
memory[12'h3e3]=8'hb4;
memory[12'h3e4]=8'h00;
memory[12'h3e5]=8'hee;
memory[12'h3e6]=8'h6a;
memory[12'h3e7]=8'h00;
memory[12'h3e8]=8'h60;
memory[12'h3e9]=8'h19;
memory[12'h3ea]=8'h00;
memory[12'h3eb]=8'hee;
memory[12'h3ec]=8'h37;
memory[12'h3ed]=8'h23;
*/

memory[12'h200]=8'h62;
memory[12'h201]=8'h01;
memory[12'h202]=8'h63;
memory[12'h203]=8'h07;
memory[12'h204]=8'h61;
memory[12'h205]=8'h0E;
memory[12'h206]=8'hF1;
memory[12'h207]=8'h29;
memory[12'h208]=8'hD2;
memory[12'h209]=8'h35;

memory[12'h20A]=8'h62;
memory[12'h20B]=8'h07;
memory[12'h20C]=8'h61;
memory[12'h20D]=8'h0C;
memory[12'h20E]=8'hF1;
memory[12'h20F]=8'h29;
memory[12'h210]=8'hD2;
memory[12'h211]=8'h35;



memory[12'h212]=8'h62;
memory[12'h213]=8'h0D;
memory[12'h214]=8'h61;
memory[12'h215]=8'h0E;
memory[12'h216]=8'hF1;
memory[12'h217]=8'h29;
memory[12'h218]=8'hD2;
memory[12'h219]=8'h35;


	
		end
		FETCH:begin
			IR[15:8]=memory[PC];
			IR[7:0]=memory[PC+4'd1];
			
			
			if(sound_timer>0)
				sound_timer=sound_timer-1;
			if(delay_timer>0)
				delay_timer=delay_timer-1;
		
		end
		
		DECODE:begin
		
		
		
		casez (IR[15:12])
		
		4'h0:begin
				
				casez(IR[7:0])
				
				8'hE0:begin
				//00E0 - CLS
				//Clear the display.
				PC=PC+4'd2;
				end
				
				8'hEE:begin
				
					SP =SP - 4'd1;
					PC =STACK[SP] + 4'h2;
					
				end
				
				endcase	
				
		end
		

		4'h1:begin
		//1nnn - JP addr
		//Jump to location nnn.
		//The interpreter sets the program counter to nnn.
			PC <= IR[11:0];
		end
		4'h2:begin
		//2nnn - CALL addr
		//Call subroutine at nnn.
		//The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
			STACK[SP] = PC;
			SP =SP+4'd1;
			PC = IR[11:0];
		end
		4'h3:begin
		//3xkk - SE Vx, byte
		//Skip next instruction if Vx = kk.
		//The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
		
		if( V[IR[11:8]] == IR[7:0])
			PC=PC+4'd4;
		else
			PC=PC+4'd2;
		
		end
		4'h4:begin
		//4xkk - SNE Vx, byte
		//Skip next instruction if Vx != kk.
		//The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
		
		if( V[IR[11:8]] != IR[7:0])
			PC=PC+4'd4;
		else
			PC=PC+4'd2;
		
		end
		
		4'h5:begin
		
		//5xy0 - SE Vx, Vy
		//Skip next instruction if Vx = Vy.
		//The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
		
			
		if( V[IR[11:8]] == V[IR[7:4]])
			PC=PC+4'd4;
		else
			PC=PC+4'd2;
		
		
		end
		
		4'h6:begin
		//6xkk - LD Vx, byte
		//Set Vx = kk.
		//The interpreter puts the value kk into register Vx.
		
		V[IR[11:8]]<=IR[7:0];
		PC<=PC+4'd2;
		
		end
		
		4'h7:begin
		//7xkk - ADD Vx, byte
		//Set Vx = Vx + kk.
		//Adds the value kk to the value of register Vx, then stores the result in Vx. 
		
		V[IR[11:8]]<=IR[7:0] + V[IR[11:8]];
		PC<=PC+4'd2;
		
		end
		
		
		4'h8:begin
		
		
			casez(IR[3:0])
		
				4'h0:begin
			//8xy0 - LD Vx, Vy
			//Set Vx = Vy.
			//Stores the value of register Vy in register Vx.
		
			V[IR[11:8]]<=V[IR[7:4]];
		
			end
		
		
				4'h1:begin
			//8xy1 - OR Vx, Vy
			//Set Vx = Vx OR Vy.

			//Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx. A bitwise OR compares the corrseponding 	
			//bits from two values, and if either bit is 1, then the same bit in the result is also 1. Otherwise, it is 0. 
			
			V[IR[11:8]]<=V[IR[7:4]] | V[IR[11:8]];
		
		
			end
		
				4'h2:begin

		//8xy2 - AND Vx, Vy
		//Set Vx = Vx AND Vy.

		//Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx. A bitwise AND compares the 	
		//corrseponding bits from two values, and if both bits are 1, then the same bit in the result is also 1. 
		//Otherwise, it is 0.
	
		V[IR[11:8]]<=V[IR[7:4]] & V[IR[11:8]];
		end

				4'h3:begin
		//8xy3 - XOR Vx, Vy
		//Set Vx = Vx XOR Vy.

		//Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx. An exclusive OR compares the 	 corrseponding bits from two values, and if the bits are not both the same, then the corresponding bit in the result is set to 1. Otherwise, it is 0. 
		
		V[IR[11:8]]<=V[IR[7:4]] ^ V[IR[11:8]];
		
		end

				4'h4:begin
		//8xy4 - ADD Vx, Vy
		//Set Vx = Vx + Vy, set VF = carry.

//The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0. Only the lowest 8 bits of the result are kept, and stored in Vx.
		
		addition = V[IR[7:4]] + V[IR[11:8]];
		
		V[IR[11:8]]=addition[7:0];
		
		V[4'hF] = addition[8]; 

		end

		
				4'h5:begin
		//8xy5 - SUB Vx, Vy
		//Set Vx = Vx - Vy, set VF = NOT borrow.

		//If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
		
		if(V[IR[11:8]]>V[IR[7:4]])
		V[4'hF]=8'h01;
		else
		V[4'hF]=8'h00;
		
		V[IR[11:8]] = V[IR[11:8]]-V[IR[7:4]];

		end

				4'h6:begin
		//8xy6 - SHR Vx {, Vy}
		//Set Vx = Vx SHR 1.

		//If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
		
		
		V[4'hF] = V[IR[11:8]][0]; 

		V[IR[11:8]] = {1'b0 , V[IR[11:8]][7:1]};
		
	
		end

				4'h7:begin		
		//8xy7 - SUBN Vx, Vy
		//Set Vx = Vy - Vx, set VF = NOT borrow.

		//If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
		
		if(V[IR[7:4]]>V[IR[11:8]])
		V[4'hF]=8'h01;
		else
		V[4'hF]=8'h00;
		
		V[IR[11:8]] =V[IR[7:4]]-V[IR[11:8]];
		
		end

				4'hE:begin
		//8xyE - SHL Vx {, Vy}
		//Set Vx = Vx SHL 1.

		//If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
		
		V[4'hF] = V[IR[11:8]][7]; 

		V[IR[11:8]] = {V[IR[11:8]][6:0],1'b0};
		
		end
		
				default:begin
		end
		
		
			endcase
		
			PC=PC+4'd2;
		
		end
					

		4'h9:begin
		
		//9xy0 - SE Vx, Vy
		//Skip next instruction if Vx != Vy.
		//The interpreter compares register Vx to register Vy, and if they are  not equal, increments the program counter by 2.
		
			
		if( V[IR[11:8]] != V[IR[7:4]])
			PC=PC+4'd4;
		else
			PC=PC+4'd2;
		
		
		end
		
		
		4'hA:begin
		//Annn - LD I, addr
		//Set I = nnn.

		//The value of register I is set to nnn.
		
		I<=IR[11:0];
		PC<=PC+4'd2;

		end
		
		4'hB:begin
		//Bnnn - JP V0, addr
		//Jump to location nnn + V0.
		//The program counter is set to nnn plus the value of V0.
		
		
		PC<=V[4'h0]+IR[11:0];

		end
		
		4'hC:begin
		//Cxkk - RND Vx, byte
		//Set Vx = random byte AND kk.
		//The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk.
		//The results are stored in Vx.
		
		V[IR[11:8]] = randnum & IR[7:0];
		
		PC=PC+4'd2;
		
		end
		4'hD:begin
		//Dxyn - DRW Vx, Vy, nibble
		//Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.

		//The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites
		//on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is
		//set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it 
		//wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display,
		//for more information on the Chip-8 screen and sprites.
		
			
		end
		
		4'hE:begin
		
				casez(IR[7:0])
				
				8'h9E:begin
				//Ex9E - SKP Vx
				//Skip next instruction if key with the value of Vx is pressed.
				//Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, 
				//PC is increased by 2.
				
				if( keys[V[IR[11:8]]] == 1'b1)
					PC=PC+4'd4;
				else
					PC=PC+4'd2;
				end
				
				
				8'hA1:begin
				//ExA1 - SKNP Vx
				//Skip next instruction if key with the value of Vx is not pressed.
				//Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position,
				//PC is increased by 2.
				
				if( keys[V[IR[11:8]]] != 1'b1)
					PC=PC+4'd4;
				else
					PC=PC+4'd2;
				
				
				end
				
				default:begin
				end
				
				endcase
		
		end
		
		4'hF:begin
			
			casez(IR[7:0])
			
			8'h07:begin
			//Fx07 - LD Vx, DT
			//Set Vx = delay timer value.
			//The value of DT is placed into Vx.
			
			V[IR[11:8]] = delay_timer;
			PC=PC+4'd2;
			end
			
			8'h0A:begin
			//Fx0A - LD Vx, K
			//Wait for a key press, store the value of the key in Vx.
			//All execution stops until a key is pressed, then the value of that key is stored in Vx.
			PC=PC+4'd2;
			end
			
			8'h15:begin
			//Fx15 - LD DT, Vx
			//Set delay timer = Vx.
			//DT is set equal to the value of Vx.
			
			delay_timer = V[IR[11:8]];
			PC=PC+4'd2;
			
			end
			
			
			8'h18:begin
			//Fx18 - LD ST, Vx
			//Set sound timer = Vx.
			//ST is set equal to the value of Vx.
			
			sound_timer = V[IR[11:8]];
			PC=PC+4'd2;
			
			end
			
			8'h1E:begin
			//Fx1E - ADD I, Vx
			//Set I = I + Vx.
			//The values of I and Vx are added, and the results are stored in I.
			
			additionI = I + V[IR[11:8]];
			I= additionI[15:0];
			PC=PC+4'd2;
			end
			
			8'h29:begin
			//Fx29 - LD F, Vx
			//Set I = location of sprite for digit Vx.
			//do some case statement on character
			//The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. 
			//See section 2.4, Display, for more information on the Chip-8 hexadecimal font.
			
				casez(V[IR[11:8]])
				
				4'h0:begin
					I=8'h50;
				end
				
				4'h1:begin
					I=8'h55;
				end
				
				4'h2:begin
					I=8'h5A;
				end
				
				4'h3:begin
					I=8'h5F;
				end
				4'h4:begin
					I=8'h64;
				end
				4'h5:begin
					I=8'h69;
				end
				4'h6:begin
					I=8'h6E;
				end
				4'h7:begin
					I=8'h73;
				end
				4'h8:begin
					I=8'h78;
				end
				4'h9:begin
					I=8'h7D;
				end
				4'hA:begin
					I=8'h82;
				end
				4'hB:begin
					I=8'h87;
				end
				4'hC:begin
					I=8'h8C;
				end
				4'hD:begin
					I=8'h91;
				end
				4'hE:begin
					I=8'h96;
				end
				4'hF:begin
					I=8'h9B;
				end
				
				default:begin
				end
				
				endcase
			PC=PC+4'd2;	
			end

			8'h33:begin
			//Fx33 - LD B, Vx
			//Store BCD representation of Vx in memory locations I, I+1, and I+2.
			//The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, 
			//the tens digit at location I+1, and the ones digit at location I+2.
			
			PC=PC+4'd2;
			end

			8'h55:begin
			//Fx55 - LD [I], Vx
			//Store registers V0 through Vx in memory starting at location I.
			//The interpreter copies the values of registers V0 through Vx into memory, starting at the address in I.
			//memory[I]<=V[4'h0]
			//memory[I+1]<=V[4'h1]
				/*
				casez(V[IR[11:8]])
				
				4'h0:begin
					memory[I] = V[4'h0];
				end
				
				
				4'h1:begin
					memory[I] = V[4'h0];
					memory[I+4'h1] = V[4'h1];
				end
				
				4'h2:begin
					memory[I] = V[4'h0];
					memory[I+4'h1] = V[4'h1];
					memory[I+4'h2] = V[4'h2];
				end
				
				4'h3:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
				end
				4'h4:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
				end
				4'h5:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
				end
				4'h6:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
				end
				4'h7:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
				end
				4'h8:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
				end
				4'h9:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];  

				end
				4'hA:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
				end
				4'hB:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
					memory[I+4'hB]=V[4'hB];  
				end
				4'hC:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
					memory[I+4'hB]=V[4'hB];  
					memory[I+4'hC]=V[4'hC];  
				end
				4'hD:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
					memory[I+4'hB]=V[4'hB];  
					memory[I+4'hC]=V[4'hC];  
					memory[I+4'hD]=V[4'hD];
				end
				4'hE:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
					memory[I+4'hB]=V[4'hB];  
					memory[I+4'hC]=V[4'hC];  
					memory[I+4'hD]=V[4'hD];
					memory[I+4'hE]=V[4'hE];  
				end
				4'hF:begin
					memory[I]=V[4'h0];
					memory[I+4'h1]=V[4'h1];
					memory[I+4'h2]=V[4'h2];  
					memory[I+4'h3]=V[4'h3];  
					memory[I+4'h4]=V[4'h4]; 
					memory[I+4'h5]=V[4'h5];
					memory[I+4'h6]=V[4'h6];  
					memory[I+4'h7]=V[4'h7];  
					memory[I+4'h8]=V[4'h8];  
					memory[I+4'h9]=V[4'h9];
					memory[I+4'hA]=V[4'hA];  
					memory[I+4'hB]=V[4'hB];  
					memory[I+4'hC]=V[4'hC];  
					memory[I+4'hD]=V[4'hD];
					memory[I+4'hE]=V[4'hE];  
					memory[I+4'hF]=V[4'hF];  
				end
				
				default:begin
				end
				
				endcase
				*/
			
			PC=PC+4'd2;
			end

			8'h65:begin
			//Fx65 - LD Vx, [I]
			//Read registers V0 through Vx from memory starting at location I.
			//The interpreter reads values from memory starting at location I into registers V0 through Vx.
			
			/*
			casez(V[IR[11:8]])
				
				4'h0:begin
					V[4'h0] = memory[I];
				end
				
				4'h1:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
				end
				
				4'h2:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
				end
				
				4'h3:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
				end
				4'h4:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
				end
				4'h5:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
				end
				4'h6:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
				end
				4'h7:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					
				end
				4'h8:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					
				end
				4'h9:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					
				end
				4'hA:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
				end
				4'hB:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
					V[4'hB] = memory[I+4'hB];
				
				end
				4'hC:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
					V[4'hB] = memory[I+4'hB];
					V[4'hC] = memory[I+4'hC];
		
				end
				4'hD:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
					V[4'hB] = memory[I+4'hB];
					V[4'hC] = memory[I+4'hC];
					V[4'hD] = memory[I+4'hD];
				
				end
				4'hE:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
					V[4'hB] = memory[I+4'hB];
					V[4'hC] = memory[I+4'hC];
					V[4'hD] = memory[I+4'hD];
					V[4'hE] = memory[I+4'hE];
				
				end
				4'hF:begin
					V[4'h0] = memory[I];
					V[4'h1] = memory[I+4'h1];
					V[4'h2] = memory[I+4'h2];
					V[4'h3] = memory[I+4'h3];
					V[4'h4] = memory[I+4'h4];
					V[4'h5] = memory[I+4'h5];
					V[4'h6] = memory[I+4'h6];
					V[4'h7] = memory[I+4'h7];
					V[4'h8] = memory[I+4'h8];
					V[4'h9] = memory[I+4'h9];
					V[4'hA] = memory[I+4'hA];
					V[4'hB] = memory[I+4'hB];
					V[4'hC] = memory[I+4'hC];
					V[4'hD] = memory[I+4'hD];
					V[4'hE] = memory[I+4'hE];
					V[4'hF] = memory[I+4'hF];
			
				end
				
				default:begin
				end
				
				endcase
				*/
			
			
			PC=PC+4'd2;
			end
			
			default:begin
			end
			
			endcase
		
		end
		
		
		default:begin
		end
		
	endcase
	
end

DRAW_SETUP:begin

	
	counter=0;
	V[4'hf] = 8'h00;
	//loc_in_display=loc_in_display+X;

end

DRAW_1:begin


		displaybuffer[7]<=display[V[IR[11:8]]][V[IR[7:4]]+counter];
		displaybuffer[6]<=display[V[IR[11:8]]+1][V[IR[7:4]]+counter];
		displaybuffer[5]<=display[V[IR[11:8]]+2][V[IR[7:4]]+counter];
		displaybuffer[4]<=display[V[IR[11:8]]+3][V[IR[7:4]]+counter];
		displaybuffer[3]<=display[V[IR[11:8]]+4][V[IR[7:4]]+counter];
		displaybuffer[2]<=display[V[IR[11:8]]+5][V[IR[7:4]]+counter];
		displaybuffer[1]<=display[V[IR[11:8]]+6][V[IR[7:4]]+counter];
		displaybuffer[0]<=display[V[IR[11:8]]+7][V[IR[7:4]]+counter];
		
		

end

DRAW_1_1:begin
	
		if(displaybuffer[0] == 1'b1 && memory[I+counter][0]==1'b1 ||
			displaybuffer[1] == 1'b1 && memory[I+counter][1]==1'b1 ||
			displaybuffer[2] == 1'b1 && memory[I+counter][2]==1'b1 ||
			displaybuffer[3] == 1'b1 && memory[I+counter][3]==1'b1 ||
			displaybuffer[4] == 1'b1 && memory[I+counter][4]==1'b1 ||
			displaybuffer[5] == 1'b1 && memory[I+counter][5]==1'b1 ||
			displaybuffer[6] == 1'b1 && memory[I+counter][6]==1'b1 ||
			displaybuffer[7] == 1'b1 && memory[I+counter][7]==1'b1
			)
		begin
		 V[4'hf] = 8'h01;
		end


end

DRAW_1_2:begin

displaybuffer=displaybuffer^memory[I+counter];

end

DRAW_1_3:begin

		display[V[IR[11:8]]][V[IR[7:4]]+counter]<=displaybuffer[7];
		display[V[IR[11:8]]+1][V[IR[7:4]]+counter]<=displaybuffer[6];
		display[V[IR[11:8]]+2][V[IR[7:4]]+counter]<=displaybuffer[5];
		display[V[IR[11:8]]+3][V[IR[7:4]]+counter]<=displaybuffer[4];
		display[V[IR[11:8]]+4][V[IR[7:4]]+counter]<=displaybuffer[3];
		display[V[IR[11:8]]+5][V[IR[7:4]]+counter]<=displaybuffer[2];
		display[V[IR[11:8]]+6][V[IR[7:4]]+counter]<=displaybuffer[1];
		display[V[IR[11:8]]+7][V[IR[7:4]]+counter]<=displaybuffer[0];

end

DRAW_1_4:begin

		
		//loc_in_display=loc_in_display+32'd64;
		counter=counter+1;

end

DRAW_2:begin
	
	
end

DRAW_DONE:begin
	
	PC<=PC+4'd2;
	
end

		
endcase

end

end

always_comb begin
	next_state = state;
	case (state)
		WAIT: begin
			if (start)
				next_state = FETCH;
		end
		
		FETCH: begin
				next_state = DECODE;
		end
	
		DECODE:begin
				if(IR[15:12]==4'hD)
				next_state = DRAW_SETUP;
				else
				next_state = FETCH;
		end
		
		DRAW_SETUP:begin	
		
				next_state = DRAW_1;
		end
		
		DRAW_1:begin	
		
			next_state = DRAW_1_1;
				
		end
		
		DRAW_1_1:begin	
		
			next_state = DRAW_1_2;
				
		end
		
		DRAW_1_2:begin	
		
			next_state = DRAW_1_3;
				
		end
		
		DRAW_1_3:begin
			next_state = DRAW_1_4;
		end
		
		DRAW_1_4:begin
			next_state = DRAW_2;
		end
		
		DRAW_2:begin
		
			if(counter==IR[3:0])
				next_state=DRAW_DONE;
			else	
				next_state=DRAW_1;
		end
		
		DRAW_DONE:begin	
			
			next_state=FETCH;
			
		end
		
		
	endcase	
	
end

always_comb begin
	
		
	
	case (state)
		
		WAIT:begin
	
		end
		FETCH:begin
			
		end
		
		DECODE:begin
		
		end
		
		default:begin
		
		end
		
	endcase	
end
	

	assign disp=display;
	assign opcode = IR;


	
endmodule







