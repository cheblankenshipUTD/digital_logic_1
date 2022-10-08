//-------------------------------------------------
//
// Sample Testbench and Breadbaord
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------



//=================================================================
//
//Breadboard
//
//=================================================================
module breadboard(A,B,C,opcode,error);
//=======================================================
//
// Parameter Definitions
//
//========================================================
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
output [32:0] C;
reg [32:0] C;
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
// OPERATIONS
//
//=======================================================
wire [31:0] outputADDSUB;
wire ADDerror;
wire [31:0] outputMUL;
wire [31:0] outputDIV;
wire DIVerror;
wire [31:0] outputMOD;
wire MODerror;

SixTeenBitAddSub     add1(B,A,modeSUB,outputADDSUB,Carry,ADDerror);
SixTeenBitMultiplier mul1(B,A,outputMUL);
SixTeenBitDivision   div1(B,A,outputDIV,DIVerror);
SixTeenBitModulus    mod1(B,A,outputMOD,MODerror); 

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
assign channels[ 0]=unknown;
assign channels[ 1]=unknown;
assign channels[ 2]=unknown;
assign channels[ 3]=unknown;
assign channels[ 4]=outputADDSUB;
assign channels[ 5]=outputADDSUB;
assign channels[ 6]=outputMUL;
assign channels[ 7]=outputDIV;
assign channels[ 8]=outputMOD;
assign channels[ 9]=unknown;
assign channels[10]=unknown;
assign channels[11]=unknown;
assign channels[12]=unknown;
assign channels[13]=unknown;
assign channels[14]=unknown;
assign channels[15]=unknown;

//====================================================
//
//Perform the gate-level operations in the Breadboard
//
//====================================================
always@(*)
begin
   modeADD=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
   modeSUB=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
   modeDIV=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
   modeMOD= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
   C=b; //Just a jumper
   error[0]=ADDerror&(modeADD|modeSUB);//Only show overflow if in add or subtract operation
   error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);//only show divide by zero if in division or modulus operation
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
   reg  [15:0] inputB;
   reg  [15:0] inputA;
   reg  [3:0] opcode;
   wire [32:0] outputC;
   wire [1:0] error;
   
//====================================================
//
// Create Breadboard
//
//====================================================
	breadboard bb8(inputA,inputB,outputC,opcode,error);

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
	inputB=16'b100111000100000001;
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
	inputB=16'b100111000100000001;	
	inputA=16'b100111000100000001;
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
	inputB=16'b100111000100000001;
	inputA=16'b100111000100000001;
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
	inputB=16'b100111000100000010;
	inputA=16'b100111000100000001;
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
	inputB=16'b100111000100000001;	
	inputA=16'b100111000100000001;
	opcode=4'b0110;//Multiply with Zero
	#10	
	
	$write("[%5d]",inputB);
	$write("[%5d]",inputA);
	$write("[%4b]",opcode);
	$write("[%7d]",outputC);
	$write("[%2d]",error);	
	$write(":Multiply (160001 * 160001 = 25600320001)");
	$display(";");
	//---------------------------------		
 



	$finish;
	end

endmodule