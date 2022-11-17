//=================================================================
//
//Breadboard
//
//=================================================================
module breadboard(clk,inputA, opcode, result, error);
//=======================================================
//
// Parameter Definitions
//
//========================================================
	input clk; 
	input [15:0] inputA;
	input [3:0] opcode;
	
	wire clk;	
	wire [15:0] A;
	wire [3:0] opcode;

	output [1:0]error;
	reg [1:0]error;
//----------------------------------
	output [31:0] result;
	reg [31:0] result;
//----------------------------------


//=======================================================
//
// CONTROL
//
//========================================================
	wire [15:0] [31:0] channels;
	wire [15:0] select;
	wire [31:0] b;
	wire [15:0] unknown;


//=======================================================
//
// Airthmetic OPERATIONS
//
//=======================================================
	
	
	wire [15:0] outputADDSUB;
	wire [15:0] outputSUB;
	wire [31:0] outputMUL;
	wire [15:0] outputDIV;
	wire DIVerror;
	wire [15:0] outputMOD;
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
	reg mode;


// DFF Memory Reg Interfaces
	reg  [31:0] next;
	wire [31:0] cur;
	
//Accumulator Register
	
	
	DFF ACC1 [31:0] (clk,next,cur);
	Dec4x16 dec1(opcode,select);
	StructMux mux1(channels,select,b);
//======================================================================
//
//	Here's where I went ahead and added the Arithmetic OPERATIONS
//
//======================================================================

	SixTeenBitAddSub     add1(regB,regA,mode,Carry, outputADDSUB,overflow);
	SixTeenBitMultiplier mul1(regB,regA,outputMUL);
	SixTeenBitDivision   div1(regB,regA,outputDIV,DIVerror);
	SixTeenBitModulus    mod1(regB,regA,outputMOD,MODerror); 

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
	assign channels[ 0]=cur;	//NO-Op
	assign channels[ 1]=32'b00000000000000000000000000000000;	//Reset
	assign channels[ 2]=32'b11111111111111111111111111111111;	//Preset
	assign channels[ 3]=cur;
	assign channels[ 4]={{16{outputADDSUB[15]}},outputADDSUB};	//Addition Arith Op
	assign channels[ 5]={{16{outputADDSUB[15]}},outputADDSUB};	//Subtraction Arith Op
	assign channels[ 6]=outputMUL;		//Multiplcation Arirth Op
	assign channels[ 7]={{16{outputDIV[15]}},outputDIV};		//Divsion (Behavioral) Arirth Op
	assign channels[ 8]={{16{outputMOD[15]}},outputMOD};		//Modulus (Behavioral) Arirth Op	
	assign channels[ 9]=outputAND;		//AND Logic Op
	assign channels[10]=outputOR;		//OR Logic Op
	assign channels[11]=outputXOR;		//XOR Logic Op
	assign channels[12]=outputNOT;		//NOT Logic Op
	assign channels[13]=outputNAND;		//NAND Logic Op
	assign channels[14]=outputNOR;		//NOR Logic Op
	assign channels[15]=outputXNOR;		//XNOR Logic Op
	
//=======================================================
//
// Error Reporting
//
//=======================================================
	reg modeADD;
	reg modeSUB;
	reg modeDIV;
	reg modeMOD;

//====================================================
//
//Perform the gate-level operations in the Breadboard
//
//====================================================
	always@(*)
		begin
		
			regA= inputA;
			regB= cur[15:0]; 
		
			//0101
			mode = (~opcode[3]& opcode[2]&~opcode[1]& opcode[0]);
			
			modeADD=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
			modeSUB=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
			modeDIV=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
			modeMOD= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
		 
			error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);
			error[0]=(overflow )&(modeADD|modeSUB);
   
   assign result = cur;
   assign next = b;
			
			//error[0]=ADDerror&(modeADD|modeSUB);//Only show overflow if in add or subtract operation
			//error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);//only show divide by zero if in division or modulus operation


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
   reg  [15:0] inputA;
   wire [31:0] result;
   reg  [3:0] opcode;
   wire [1:0] error;


   reg [15:0] radius;
   reg [31:0] hold;
   reg [31:0] whole;
   reg [31:0] fraction;
  
  
	reg [15:0] base;
	reg [15:0] height;
   reg [15:0] side1;
   reg [15:0] side2;
//====================================================
//
// Create Breadboard
//
//====================================================

 breadboard bb8(clk,inputA, opcode, result, error);

	

//====================================================
//
// STIMULOUS
//
//====================================================


	initial begin//Start Stimulous Thread
	
	
	base = 10;
	height = 45;
	
	
	$display();
	$display("----------------------------------------");
	$display("Area of a triangle, base =%d, height =%d", base, height);
	$display("----------------------------------------");
	$display("No-Op");
	$display("Clk | inputA | opcode | result | error");
	clk=0;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("----------------------------------------");
	$display("Reset");
	clk=0;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("----------------------------------------");
	$display("Add Base");
	clk=0;inputA=base  ; opcode=4'b0100;#5;//Add 4 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=base  ; opcode=4'b0100;#5;//Add 4 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("----------------------------------------");
	$display("Multiply by Height");
	clk=0;inputA=height ; opcode=4'b0110;#5;//Multiply by R 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=height ; opcode=4'b0110;#5;//Multiply by R 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("----------------------------------------");
	$display("Divide by 2");
	clk=0;inputA=16'd2;	opcode=4'b0111;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd2;	opcode=4'b0111;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display("----------------------------------------");
	$display("Area of a triangle with base = %2d and height = %2d is %3d.",base,height,result);
	
	
	
	side1 = 7284;
	base = 1812;
	side2 = 5643;


	$display();
	$display("----------------------------------------");
	$display("Perimter of a triangle, side1 = %d, base = %d, side2 = %d",side1, base, side2);
	$display("----------------------------------------");
	$display("No-Op");
	$display("Clk | inputA | opcode | result | error");
	clk=0;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("----------------------------------------");
	$display("Reset");
	clk=0;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("----------------------------------------");
	$display("Add Side1");
	clk=0;inputA=side1  ; opcode=4'b0100;#5;//Add operation
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=side1  ; opcode=4'b0100;#5;//Add operation
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("----------------------------------------");
	$display("Add Base");
	clk=0;inputA=base  ; opcode=4'b0100;#5;//Add 4 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=base  ; opcode=4'b0100;#5;//Add 4 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("----------------------------------------");
	$display("Add Side2");
	clk=0;inputA=side2  ; opcode=4'b0100;#5;//Add operation
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=side2  ; opcode=4'b0100;#5;//Add operation
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display("----------------------------------------");
	$display("Perimter of a triangle, side1 = %d, base = %d, side2 = %d is%d",side1,base,side2,result);
	
	
	
	
	
	
	/*
	This was just me verifying that the logic operations are still working properly
	//---------------------------------	
	$display();
	clk=0;
	inputA=16'b0000000000000000;
	opcode=4'b0001;//Reset
	#10;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	clk=1;
	inputA=16'b0000000000000000;
	opcode=4'b0001;//Reset
	#10;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	clk=0;
	inputA=16'b1010101010101010;
	opcode=4'b1010;//OR
	#10;
	$display("%b|%b|%b|%b|%b",clk,inputA,opcode,result,error);
		
		
		
	$display();
	clk=1;
	inputA=16'b1010101010101010;
	opcode=4'b1010;//OR
	#10;
	$display("%b|%b|%b|%b|%b",clk,inputA,opcode,result,error);
	
	
	
	
	
	
	Professor's example of circumference of a circle
	radius=5;
	
	$display();
	$display("--------------------------");
	$display("No-Op");
	clk=0;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; 	opcode=4'b0000;	#10;//No-Op
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("--------------------------");
	$display("Reset");
	clk=0;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("--------------------------");
	$display("Add 2");
	clk=0;inputA=16'd2  ; opcode=4'b0100;#5;//Add 2 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd2  ; opcode=4'b0100;#5;//Add 2 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("--------------------------");
	$display("Multiply by Radius");
	clk=0;inputA=radius ; opcode=4'b0110;#5;//Multiply by R 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=radius ; opcode=4'b0110;#5;//Multiply by R 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	$display();
	$display("--------------------------");
	$display("Multiply by 314");
	clk=0;inputA=16'd314; opcode=4'b0110;#5;//Multiply by 314
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd314; opcode=4'b0110;#5;//Multiply by 314
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	hold=result;

	
	$display();
	$display("--------------------------");
	$display("Divide by 100");
	clk=0;inputA=16'd100;	opcode=4'b0111;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd100;	opcode=4'b0111;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	
	whole=result;#5;//Divide by 100
	
	$display();
	$display("--------------------------");
	$display("Reset");
	clk=0;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd0  ; opcode=4'b0001;#5;//Reset 
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	
	
	$display();
	$display("--------------------------");
	$display("Add back temp value");
 	clk=0;inputA=hold   ; opcode=4'b0100;#5;//Add Temp back
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=hold   ; opcode=4'b0100;#5;//Add Temp back
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
	$display();
	$display("--------------------------");
	$display("Modulus by 100");
	clk=0;inputA=16'd100;	opcode=4'b1000;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	clk=1;inputA=16'd100;	opcode=4'b1000;#5;
	$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

	fraction=result;
	
	
	$display("==========================");
	$display("Circumference of a circle with radius %2d is %3d.%-2d.",radius,whole,fraction);
	
	 */
	
	$finish;
	end

endmodule
