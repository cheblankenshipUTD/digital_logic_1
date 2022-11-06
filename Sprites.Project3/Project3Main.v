
//============================================
//D Flip-Flop
//============================================
module DFF(clk,in,out);
	input          clk;
	input   in;
	output  out;
	reg     out;

	always @(posedge clk)
	out = in;
endmodule

//============================================
//AND operation
//============================================
module ANDER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			result=inputA&inputB;
			outputC=result;
		end
 
endmodule

//============================================
//XOR operation
//============================================
module XORER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			result=inputA^inputB;
			outputC=result;
		end
 
endmodule

//============================================
// OR operation
//============================================
module ORER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			result=inputA|inputB;
			outputC=result;
		end
 
endmodule

//============================================
// NAND operation
//============================================
module NANDER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			//input = 0 & 1 → output = 1
			result= ~(inputA&inputB);
			outputC=result;
		end
 
endmodule

//============================================
// NOT operation
//============================================
module NOTER(inputA,outputC);
	input  [15:0] inputA;
	output [15:0] outputC;
	wire   [15:0] inputA;
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			// this has to be a not gate, I will be using '~' to implement not A, similarly would be for Not B
			// input = 0001 → output = 1110
			result= ~inputA;
			outputC=result;
		end
 
endmodule

//============================================
// NOR operation
//============================================
module NORER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			result= ~(inputA|inputB);
			outputC=result;
		end
 
endmodule

//============================================
//XNOR operation
//============================================
module XNORER(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	output [15:0] outputC;
	
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	
	reg    [15:0] outputC;
	reg    [15:0] result;

	always@(*)
		begin
			result= ~(inputA^inputB);
			outputC=result;
		end
 
endmodule


//=================================================================
//
//Breadboard
//
//=================================================================
module breadboard(clk,rst,A,B,C,opcode,error);
//=======================================================
//
// Parameter Definitions
//
//========================================================
	input clk; 
	input rst;
	input [15:0] A;
	input [15:0] B;
	input [3:0] opcode;
	
	wire clk;
	wire rst;
	wire [15:0] A;
	wire [15:0] B;
	wire [3:0] opcode;

	output [1:0]error;
	reg [1:0]error;
//----------------------------------
	output [31:0] C;
	reg [31:0] C;
//----------------------------------


//=======================================================
//
// CONTROL
//
//========================================================
	wire [31:0][15:0]channels;
	wire [15:0] select;
	wire [31:0] b;
	wire [7:0] unknown;

	Dec4x16 dec1(opcode,select);
	StructMux mux1(channels,select,b);

//=======================================================
//
// Airthmetic OPERATIONS
//
//=======================================================
	wire [31:0] outputADDSUB;
	wire ADDerror;
	wire [31:0] outputMUL;
	wire [31:0] outputDIV;
	wire DIVerror;
	wire [31:0] outputMOD;
	wire MODerror;

//=======================================================
//
// Logic OPERATIONS
//
//=======================================================


	wire [15:0] outputAND;
	wire [15:0] outputXOR;
	wire [15:0] outputOR;
	wire [15:0] outputNAND;
	wire [15:0] outputNOT;
	wire [15:0] outputNOR;
	wire [15:0] outputXNOR;


	reg [15:0] regA;
	reg [15:0] regB;

	reg  [15:0] next;
	wire [15:0] cur;

//======================================================================
//
//	Here's where I went ahead and added the Arithmetic OPERATIONS
//
//======================================================================

	SixTeenBitAddSub     add1(B,A,modeSUB,outputADDSUB,Carry,ADDerror);
	SixTeenBitMultiplier mul1(B,A,outputMUL);
	SixTeenBitDivision   div1(B,A,outputDIV,DIVerror);
	SixTeenBitModulus    mod1(B,A,outputMOD,MODerror); 

//======================================================================
//
//	Here's where I went ahead and added the Logic OPERATIONS
//
//======================================================================
	ANDER and1(regA,regB,outputAND);
	XORER xor1(regA,regB,outputXOR);
	ORER  or1(regA,regB,outputOR);
	NANDER nand1(regA, regB, outputNAND);
	NOTER noter1(regA, outputNOT);
	NORER norer1(regA, regB, outputNOR);
	XNORER xnorer1(regA, regB, outputXNOR);

	//Accumulator Register
	DFF ACC1 [15:0] (clk,next,cur);

//=======================================================
//
// Error Reporting
//
//=======================================================
	reg modeADD;
	reg modeSUB;
	reg modeDIV;
	reg modeMOD;

//=======================================================
//
// Connect the MUX to the OpCodes
//
// Channel 4, Opcode 0100, Addition
// Channel 5, Opcode 0101, Subtraction
// Channel 6, Opcode 0110, Mulitplication
// Channel 7, Opcode 0111, Division (Behavioral)
// Channel 8, Opcode 1000, Modulus (Behavioral)
//
//=======================================================
	assign channels[ 0]=cur;			//NO-Op
	assign channels[ 1]=0;				//Reset
	assign channels[ 2]=1111111111111111;				//Preset
	assign channels[ 3]=unknown;
	assign channels[ 4]=outputADDSUB;	//Addition Arith Op
	assign channels[ 5]=outputADDSUB;	//Subtraction Arith Op
	assign channels[ 6]=outputMUL;		//Multiplcation Arirth Op
	assign channels[ 7]=outputDIV;		//Divsion (Behavioral) Arirth Op
	assign channels[ 8]=outputMOD;		//Modulus (Behavioral) Arirth Op	
	assign channels[ 9]=outputAND;		//AND Logic Op
	assign channels[10]=outputOR;		//OR Logic Op
	assign channels[11]=outputXOR;		//XOR Logic Op
	assign channels[12]=outputNOT;		//NOT Logic Op
	assign channels[13]=outputNAND;		//NAND Logic Op
	assign channels[14]=outputNOR;		//NOR Logic Op
	assign channels[15]=outputXNOR;		//XNOR Logic Op

//====================================================
//
//Perform the gate-level operations in the Breadboard
//
//====================================================
	always@(*)
		begin
		
			regA= A;
			regB= cur[15:0]; 
			//to get the lower two bytes...
			//high bytes=cur[31:16]
			//low bytes=cur[15:0]
			
			if (opcode==4'b1)
			 begin
			   error=0;
			 end

		  
		  
		 C=b;//Might be better if C = Cur value....
		 next=b;
			
			
			modeADD=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
			modeSUB=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
			modeDIV=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
			modeMOD= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
			//C=b; //Just a jumper
			//C=b; //Just a jumper
			
			error[0]=ADDerror&(modeADD|modeSUB);//Only show overflow if in add or subtract operation
			error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);//only show divide by zero if in division or modulus operation


			

			//error=Div0 | Overflow;//Register=wire.
		 
		 

		 //assign C=b;//Might be better if C = Cur value....
		 //assign next=b;
		 

		end

endmodule



//====================================================
//
//TEST BENCH
//
//====================================================
module testbench();

//====================================================
//
//Local Variables
//
//====================================================
   reg clk;
   reg rst;
   reg  [15:0] inputB;
   reg  [15:0] inputA;
   wire [31:0] outputC;
   reg  [3:0] opcode;
   wire [1:0] error;

   
//====================================================
//
// Create Breadboard
//
//====================================================
	breadboard bb8(clk,rst,inputA,inputB,outputC,opcode,error);

//=================================================
 //CLOCK Thread
 //=================================================
   initial begin //Start Clock Thread
     forever //While TRUE
        begin //Do Clock Procedural
          clk=0; //square wave is low
          #5; //half a wave is 5 time units
          clk=1;//square wave is high
          #5; //half a wave is 5 time units
		  $display("Ticking");
        end
    end
	
	
//=================================================
// Display Thread
//=================================================

    initial begin //Start Output Thread
	forever
         begin
 
			//logic operations
		 case (opcode)
//		 # = what channel from the MUX
		 0:  $display("%16b ==> %16b         , NO-OP",bb8.cur,bb8.b);
		 1:  $display("%16b ==> %16b         , RESET",16'b0000000000000000,bb8.b);
		 2:  $display("%16b ==> %16b        , PRESET",16'b1111111111111111,bb8.b);
		 9:  $display("%16b AND %16b = %16b  , AND"  ,bb8.cur,inputA,bb8.b);
		 10: $display("%16b OR %16b = %16b  , OR"  ,bb8.cur,inputA,bb8.b);		 
		 11: $display("%16b XOR %16b = %16b  , XOR"  ,bb8.cur,inputA,bb8.b);
		 13: $display("%16b NAND %16b = %16b  , NAND", bb8.cur, inputA, bb8.b); 
		 12: $display("%16b NOT %16b = %16b  , NOT", bb8.cur, inputA, bb8.b);
		 14: $display("%16b NOR %16b = %16b  , NOR", bb8.cur, inputA, bb8.b);
		 15: $display("%16b XNOR %16b = %16b  , XNOR", bb8.cur, inputA, bb8.b);
		 endcase
		 
		 #10;
		 end
	end
//====================================================
//
// STIMULOUS
//
//====================================================


	initial begin//Start Stimulous Thread
	#2;	
	
	//---------------------------------
	$write("[    B]");
	$write("[    A]");
	$write("[  OP]");
	$write("[      C]");
	$write("[ E]");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000001010;
	inputA=16'b0000000000001100;
	opcode=4'b0100;//ADD
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Addition (10 + 12 = 22)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000000001;
	inputA=16'b0000000000000001;
	opcode=4'b0101;//SUB
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Subtraction (1 - 1 = 0)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000010100;
	inputA=16'b0000000000010100;
	opcode=4'b0110;//MUL
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Multipy (20 * 20 = 400)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000010100;
	inputA=16'b0000000000000101;
	opcode=4'b0111;//DIV
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Divide (20 / 5 = 4)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000001011;
	inputA=16'b0000000000000010;
	opcode=4'b1000;//MOD
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Modulus (11 mod 2 = 1)");
	$display(";");
	//---------------------------------
	inputB=16'b1001110001000000;
	inputA=16'b0000000000000100;
	opcode=4'b0100;//Addition
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);
	$write(":Addition (160001 + 160001 = 32002)");
	$display(";");

	//---------------------------------
	inputB=16'b1001110001000001;	
	inputA=16'b1001110001000001;
	opcode=4'b0101;//Subtraction with Error
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Subtraction (160001 - 160001 = 0)");
	$display(";");

	//---------------------------------
	inputB=16'b1001110001000001;
	inputA=16'b1001110001000001;
	opcode=4'b0111;//Division with Error
	#10	

	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Division (160001 / 160001 = 1)");
	$display(";");
	
	//---------------------------------
	inputB=16'b1001110001000010;
	inputA=16'b1001110001000001;
	opcode=4'b1000;//Modulus with Error
	#10	
	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Modulus (160002 mod 160001 = 1)");
	$display(";");
		
	//---------------------------------
	inputB=16'b1001110001000001;	
	inputA=16'b1001110001000001;
	opcode=4'b0110;//Multiply with Zero
	#10	
	
	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Multiply (160001 * 160001 = 25600320001)");
	$display(";");
		
	#10
	
	//===============================================
	//
	//	Starting from here are the logic operations
	//
	//===============================================
 
	inputA=16'b0000000000000000;
	opcode=4'b0000;//NOOP
	
	//---------------------------------	
	#10;
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0001;//Reset
	#10;
	
	//---------------------------------	
 	
 	inputA=16'b1010101010101010;
	opcode=4'b1010;//OR
	#10;		
	
	inputA=16'b1111111111111111;
	opcode=4'b1010;//OR
	#10;
	
	
	inputA=16'b1111111100000000;
	opcode=4'b1011;//XOR
	#10;
	//---------------------------------	
 
 
	inputA=16'b1010101010101010;
	opcode=4'b1101;//NAND
	#10;	
	
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0001;//Reset
	#10;
 
	//---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b1100; //NOT channel 12
	#10
	
	inputA=16'b1010101010101010;
	opcode=4'b1110;//NOR  channel 14
	#10;
 
	inputA=16'b1010101010101010;
	opcode=4'b1111;// XNOR channel 15
	#10;
	
	inputA=16'b1010101010101010;
	opcode=4'b1001;// And channel 9
	#10;

	inputA=16'b1111111111111111;
	opcode=4'b0010;//Preset
	#10;
	
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0001;//Reset
	#10;
	
	inputA=16'b1111111111111111;
	opcode=4'b0010;//Preset
	#10;

	inputA=16'b0000000000000000;
	opcode=4'b0000;//NOOP
	#10
	
	inputA=16'b1111111111111111;
	opcode=4'b1010;//OR
	#10;
	
	
	inputA=16'b1111111111111111;
	opcode=4'b1110;//NOR  channel 14
	#10;
	
	
	
	$finish;
	end

endmodule
