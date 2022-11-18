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

	output [31:0] result;
	reg [31:0] result;

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
	reg [15:0] length;
	reg [15:0] width;
	reg [15:0] height;
	reg [15:0] side1;
   	reg [15:0] side2;
	reg [15:0] base1;
	reg [15:0] base2;
	// Area of rectangle
	reg [15:0] rectangleLength0;
	reg [15:0] rectangleWidth0;
	// Perimter of rectangle
	reg [15:0] rectangleLength1;
	reg [15:0] rectangleWidth1;
	//Perimeter of Parallelogram
	reg [15:0] parallelogramLength;
	reg [15:0] parallelogramWidth;
	
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
	
	// 1. Area of Square
	
	base = 20;
			
	$display();
		$display("----------------------------------------");
		$display("Area of a square, base =%d", base);
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
		$display("Multiply by Base");
		clk=0;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
	
		$display("----------------------------------------");
	$display("Area of a square, base =%d,  is %d",base,result);
	
		
	// 2. Volume of Cube
		
		
	base = 24;
	
	$display();
		$display("----------------------------------------");
		$display("Volume of a cube, base =%d", base);
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
		$display("Multiply by Base");
		clk=0;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Multiply by base");
		clk=0;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display("----------------------------------------");
	$display("Volume of a cube, base =%d,  is %d",base,result);
	
	
	// 3. Volume of triangular prism
	
	length = 16;
	width = 24;
	height =54;
		
	
	$display();
		$display("----------------------------------------");
		$display("Volume of a triangular prism, length =%d, width =%d, and height =%d", length, width, height);
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
		$display("Add Length");
		clk=0;inputA=length  ; opcode=4'b0100;#5;//Add 4 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=length  ; opcode=4'b0100;#5;//Add 4 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Multiply by width");
		clk=0;inputA=width ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=width ; opcode=4'b0110;#5;//Multiply by R 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Multiply by height");
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
	$display("Volume of a triangular prism, length =%d, width =%d, and height =%d is %d",length,width,height,result);
	
	
	// 4. Area of triangle
	
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

		
	// 5. Perimeter of triangle
	
	side1 = 7284;
	base = 1812;
	side2 = 5643;

	$display();
		$display("----------------------------------------");
		$display("Perimeter of a triangle, side1 = %d, base = %d, side2 = %d",side1, base, side2);
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
	
	
		
	// 6. Area of Trapezoid
	
	base1 = 10;
	base2 = 30;
	height = 15;

	$display();
		$display("----------------------------------------");
		$display("Area of a Trapezoid, base 1 =%d, base 2 =%d, height =%d ", base1,base2, height);
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
		$display("Add Base 1");
		clk=0;inputA=base1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Add Base 2");
		clk=0;inputA=base2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Divide By 2");
		clk=0;inputA=16'd2  ; opcode=4'b0111;#5;//Divide operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=16'd2  ; opcode=4'b0111;#5;//Divide operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Multiply By Height");
		clk=0;inputA=height  ; opcode=4'b0110;#5;//Multiply operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=height  ; opcode=4'b0110;#5;//Multiply operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
	$display("Area of a Trapezoid, base 1 =%d, base 2 =%d, height =%d  is %d", base1,base2, height, result);

		
	// 7. Perimeter of Trapezoid
		
	base1 = 200;
	base2 = 400;
	side1 = 600;
	side2 = 100;

	$display();
		$display("----------------------------------------");
		$display("Perimeter of a Trapezoid, base 1 =%d, base 2 =%d, side 1 =%d, side 2 = %d ", base1,base2,side1,side2);
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
		$display("Add Base 1");
		clk=0;inputA=base1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Add Base 2");
		clk=0;inputA=base2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=base2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Add Side 1");
		clk=0;inputA=side1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=side1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Add Side 2");
		clk=0;inputA=side2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=side2  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
	$display("Perimeter of a Trapezoid, base 1 =%d, base 2 =%d, side 1 =%d, side2 =%d  is %d", base1,base2,side1,side2,result);
	
		
	// 8. Area of rectangle

	rectangleLength0 = 111;
	rectangleWidth0 = 22;
		
	$display();
		$display("----------------------------------------");
		$display("Area of a rectangle, length = %d, width = %d",rectangleLength0,rectangleWidth0);
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
		$display("Add length");
		clk=0;inputA=rectangleLength0  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=rectangleLength0  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Multiply the current value (length) by width");
		clk=0;inputA=rectangleWidth0 ; opcode=4'b0110;#5;//Multiply by width
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=rectangleWidth0 ; opcode=4'b0110;#5;//Multiply by width
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display("----------------------------------------");
	$display("Area of a rectangle, length = %d, width = %d is%d",rectangleLength0,rectangleWidth0,result);
	
		
	// 9. Perimeter of rectangle
		
	rectangleLength1 = 80;
	rectangleWidth1 = 20;
		
	$display();
		$display("----------------------------------------");
		$display("Perimeter of a rectangle, length = %d, width = %d",rectangleLength1,rectangleWidth1);
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
		$display("Add length");
		clk=0;inputA=rectangleLength1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=rectangleLength1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Add width");
		clk=0;inputA=rectangleWidth1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=rectangleWidth1  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		
		$display();
		$display("----------------------------------------");
		$display("Multiply the current sum by 2");
		clk=0;inputA=2 ; opcode=4'b0110;#5;//Multiply by 2
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=2 ; opcode=4'b0110;#5;//Multiply by 2 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display("----------------------------------------");
	$display("Perimeter of a rectangle, length = %d, width = %d is%d",rectangleLength1,rectangleWidth1,result);
	
	
	// 10. Perimeter of a parallelogram
		
	parallelogramLength = 40;
	parallelogramWidth = 22;

	$display();
		$display("----------------------------------------");
		$display("Perimeter of a Parallelogram, length = %d, width = %d",parallelogramLength,parallelogramWidth);
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
		$display("Add length");
		clk=0;inputA=parallelogramLength  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=parallelogramLength  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Add width");
		clk=0;inputA=parallelogramWidth  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=parallelogramWidth  ; opcode=4'b0100;#5;//Add operation
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display();
		$display("----------------------------------------");
		$display("Multiply the current sum by 2");
		clk=0;inputA=2 ; opcode=4'b0110;#5;//Multiply by 2
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);
		clk=1;inputA=2 ; opcode=4'b0110;#5;//Multiply by 2 
		$display("%b|%d|%b|%d|%b",clk,inputA,opcode,result,error);

		$display("----------------------------------------");
	$display("Perimeter of a Parallelogram, length = %d, width = %d is%d",parallelogramLength,parallelogramWidth,result);
	

	$finish;
	end

endmodule
