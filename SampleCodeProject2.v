//-------------------------------------------------
//
// Sample Testbench and Breadbaord
//
//-------------------------------------------------

/*
Hello everyone here's the sample code. I went ahead and copied and pasted all of the sample code onto one document
In order to run this verilog prorgam is it very simple. On your terminal you will go ahead and write the following commands.
Some things to note, make sure this file is saved in the same bin as your verilog and you should be fine!
You'd type 'iverilog *.v' ↵  
Then 'vvp a.out' ↵ 
This will then look like this:

C:\iverilog\bin>iverilog *.v

C:\iverilog\bin>vvp a.out

[   B][   A][  OP][       C][ E];
[0010][0010][0100][00000100][00]:Addition;
[0010][0100][0101][11111110][00]:Subtraction;
[0010][0010][0110][00000100][00]:Multipy;
[0010][0010][0111][00000001][00]:Divide;
[0010][0010][1000][00000000][00]:Modulus;
[0100][0100][0100][11111000][01]:Addition with Error;
[1100][0110][0101][00000110][01]:Subtraction with Error;
[0100][0000][0111][xxxxxxxx][10]:Division with Error;
[0100][0000][1000][xxxxxxxx][10]:Modulus with Error;
[0100][0000][0110][00000000][00]:Multiply with 0;
main.v:311: $finish called at 102 (1s)

*/

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
	input [15:0] A; //A will now recieve an input of 16 bits [3:0] → [15:0]
	input [15:0] B; //B will now recieve an input of 16 bits [3:0] → [15:0]
	input [3:0] opcode; //opcode will remain the same 
	wire clk;
	wire rst;
	wire [15:0] A;
	wire [15:0] B;
	wire [3:0] opcode;

	output [1:0]error;
	reg [1:0]error;
//----------------------------------
	output [31:0] C; //output will now become 32 bits, [7:0] → [31:0]
	reg [31:0] C;	//likewise reg will 32 bits
//----------------------------------


//=======================================================
//
// CONTROL
//
//========================================================
wire [15:0][7:0]channels; //16 and 8 wide
wire [15:0] select; //one hot select
	wire [31:0] b;
	wire [31:0] unknown;

Dec4x16 dec1(opcode,select); //convert to a 16 bit one hot number
StructMux mux1(channels,select,b); //behavior (built in operations) or structurtally(gates), 

//=======================================================
//
// OPERATIONS
//
//=======================================================
	//these wires will now reflect an OUTPUT of 32 bits [7:0] → [31:0]
	wire [31:0] outputADDSUB;
	wire ADDerror;
	wire [31:0] outputMUL;
	wire [31:0] outputDIV;
	wire DIVerror;
	wire [31:0] outputMOD;
	wire MODerror;
//above are all outputs

FourBitAddSub     add1(B,A,modeSUB,outputADDSUB,Carry,ADDerror); //B + A 
FourBitMultiplier mul1(B,A,outputMUL);
FourBitDivision   div1(B,A,outputDIV,DIVerror);
FourBitModulus    mod1(B,A,outputMOD,MODerror); 

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
assign channels[ 4]=outputADDSUB; //as of now this reflects our diagram for the MUX
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
	reg  [15:0] inputB;  //our inputB will now accept 16 bits, [3:0] → [15:0]
	reg  [15:0] inputA; //our inputA will now accept 16 bits, [3:0] → [15:0]
   	reg  [3:0] opcode;
	wire [31:0] outputC; //our outputC will now accept 32 bits, [7:0] → [31:0]
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
	$write("[   B]");
	$write("[   A]");
	$write("[  OP]");
	$write("[       C]");
	$write("[ E]");
	$display(";");
	//---------------------------------
	inputB=4'b0010001000100010; // we will modify this to reflect our 16 bit input
	inputA=4'b0010001000100010; // we will modify this to reflect our 16 bit input
	opcode=4'b0100;//ADD
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Addition");
	$display(";");
	//---------------------------------
	inputB=4'b0010;
	inputA=4'b0100;
	opcode=4'b0101;//SUB
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Subtraction");
	$display(";");
	//---------------------------------
	inputB=4'b0010;
	inputA=4'b0010;
	opcode=4'b0110;//MUL
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Multipy");
	$display(";");
	//---------------------------------
	inputB=4'b0010;	
	inputA=4'b0010;
	opcode=4'b0111;//DIV
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Divide");
	$display(";");
	//---------------------------------
	inputB=4'b0010;	
	inputA=4'b0010;
	opcode=4'b1000;//MOD
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Modulus");
	$display(";");
	//---------------------------------
	inputB=4'b0100;
	inputA=4'b0100;
	opcode=4'b0100;//Addition with Error
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Addition with Error");
	$display(";");

	//---------------------------------
	inputB=4'b1100;	
	inputA=4'b0110;
	opcode=4'b0101;//Subtraction with Error
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Subtraction with Error");
	$display(";");

	//---------------------------------
	inputB=4'b0100;
	inputA=4'b0000;
	opcode=4'b0111;//Division with Error
	#100	

	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Division with Error");
	$display(";");
	
	//---------------------------------
	inputB=4'b0100;
	inputA=4'b0000;
	opcode=4'b1000;//Modulus with Error
	#100	
	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Modulus with Error");
	$display(";");
		
	//---------------------------------
	inputB=4'b0100;	
	inputA=4'b0000;
	opcode=4'b0110;//Multiply with Zero
	#100	
	
	$write("[%4b]",inputB);
	$write("[%4b]",inputA);
	$write("[%4b]",opcode);
	$write("[%7b]",outputC);
	$write("[%2b]",error);	
	$write(":Multiply with 0");
	$display(";");
	//---------------------------------		

	$finish;
	end

endmodule




//-------------------------------------------------
//
// Sample 1-Bit Full Adder
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------



//=============================================
//
// Full Adder
//
//=============================================
module FullAdder(A,B,C,carry,sum);
	input A;
	input B;
	input C;
	output carry;
	output sum;
	reg carry;
	reg sum;
//---------------------------------------------	
 
	always @(*) 
	  begin
		sum= A^B^C;
		carry= ((A^B)&C)|(A&B);  
	  end
//---------------------------------------------
endmodule; //this stays the same

/*
module testbench();
reg inputA;
reg inputB;
reg inputC;
wire outputC;
wire outputS;
FullAdder FA0(inputB,inputA,inputC,outputC,outputS);

initial begin
inputA=1'b1;
inputB=1'b1;
inputC=1'b1;
#60;
$display("%2b+%2b+%2b= %b%b",inputA,inputB,inputC,outputC,outputS);
$display("%2d+%2d+%2d= %2d",inputA,inputB,inputC,2*outputC+outputS);
end
endmodule
*/



//-------------------------------------------------
//
// Sample 4-Bit Full Adder
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


//=============================================
//
// FourBitFullAdder
//
//=============================================
module FourBitFullAdder(A,B,C,Carry,Sum);
input [3:0] A;
input [3:0] B;
input C;
output Carry;
output [3:0] Sum;
 
wire temp[2:0];

FullAdder FA0(A[0],B[0],C      ,temp[0],Sum[0]);
FullAdder FA1(A[1],B[1],temp[0],temp[1],Sum[1]);
FullAdder FA2(A[2],B[2],temp[1],temp[2],Sum[2]);
FullAdder FA3(A[3],B[3],temp[2],Carry,Sum[3]);

endmodule

/*
module testbench();
//Data Inputs
reg [3:0]dataA;
reg [3:0]dataB;
reg dataC;
//Outputs
wire[3:0]result;
wire carry;
FourBitFullAdder F4A0(dataA,dataB,dataC,carry,result);
initial
begin
//        0123456789ABCDEF
$display("Addition");
dataA=4'b1111; 
dataB=4'b1111;
dataC=0;
#100;

$display("%b+%b+%b=%b:%b",dataA,dataB,dataC,carry,result);

end
endmodule;
*/


//-------------------------------------------------
//
// Sample 4-Bit Adder/Subtractor with padded 4 bits
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------

//This file extends over to the 1bitAdd.v file

// update FourBitAddSub to SixTeenAddSub
module SixTeenBitAddSub(inputA,inputB,mode,sum,carry,overflow);
    input [15:0] inputA;
	input [15:0] inputB;
    input mode;
    output [31:0] sum;
	output carry;
    output overflow;

	wire c0; //MOde assigned to C0

    wire b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15; //XOR Interfaces
	wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; //Carry Interfaces
	
	assign c0=mode;//Mode=0, Addition; Mode=1, Subtraction

	assign b0 = inputB[0] ^ mode;//Flip the Bit if Subtraction
	assign b1 = inputB[1] ^ mode;//Flip the Bit if Subtraction
	assign b2 = inputB[2] ^ mode;//Flip the Bit if Subtraction
	assign b3 = inputB[3] ^ mode;//Flip the Bit if Subtraction
	assign b4 = inputB[4] ^ mode;//Flip the Bit if Subtraction
	assign b5 = inputB[5] ^ mode;//Flip the Bit if Subtraction
	assign b6 = inputB[6] ^ mode;//Flip the Bit if Subtraction
	assign b7 = inputB[7] ^ mode;//Flip the Bit if Subtraction
	assign b8 = inputB[8] ^ mode;//Flip the Bit if Subtraction
	assign b9 = inputB[9] ^ mode;//Flip the Bit if Subtraction
	assign b10 = inputB[10] ^ mode;//Flip the Bit if Subtraction
	assign b11 = inputB[11] ^ mode;//Flip the Bit if Subtraction
	assign b12 = inputB[12] ^ mode;//Flip the Bit if Subtraction
	assign b13 = inputB[13] ^ mode;//Flip the Bit if Subtraction
	assign b14 = inputB[14] ^ mode;//Flip the Bit if Subtraction
	assign b15 = inputB[15] ^ mode;//Flip the Bit if Subtraction

	
 
	FullAdder FA0(inputA[0],b0,  c0,c1,sum[0]);
	FullAdder FA1(inputA[1],b1,  c1,c2,sum[1]);
	FullAdder FA2(inputA[2],b2,  c2,c3,sum[2]);
	FullAdder FA3(inputA[3],b3,  c3,c4,sum[3]);
	FullAdder FA4(inputA[4],b4,  c4,c5,sum[4]);
	FullAdder FA5(inputA[5],b5,  c5,c6,sum[5]);
	FullAdder FA6(inputA[6],b6,  c6,c7,sum[6]);
	FullAdder FA7(inputA[7],b7,  c7,c8,sum[7]);
	FullAdder FA8(inputA[8],b8,  c8,c9,sum[8]);
	FullAdder FA9(inputA[9],b9,  c9,c10,sum[9]);
	FullAdder FA10(inputA[10],b10,  c10,c11,sum[10]);
	FullAdder FA11(inputA[11],b11,  c11,c12,sum[11]);
	FullAdder FA12(inputA[12],b12,  c12,c13,sum[12]);
	FullAdder FA13(inputA[13],b13,  c13,c14,sum[13]);
	FullAdder FA14(inputA[14],b14,  c14,c15,sum[14]);
	FullAdder FA15(inputA[15],b15,  c15,c16,sum[15]);


	assign sum[16]=sum[15];
	assign sum[17]=sum[15];
	assign sum[18]=sum[15];
	assign sum[19]=sum[15];
	assign sum[20]=sum[15];
	assign sum[21]=sum[15];
	assign sum[22]=sum[15];
	assign sum[23]=sum[15];
	assign sum[24]=sum[15];
	assign sum[25]=sum[15];
	assign sum[26]=sum[15];
	assign sum[27]=sum[15];
	assign sum[28]=sum[15];
	assign sum[29]=sum[15];
	assign sum[30]=sum[15];
	assign sum[31]=sum[15];


	
	assign carry=c16;
	assign overflow=c16^c15;
 
endmodule


/*
module testbench();


//Data Inputs
reg [15:0]dataA;
reg [15:0]dataB;
reg mode;

//Outputs
wire[31:0]result;
wire carry;
wire err;

//Instantiate the Modules
SixTeenBitAddSub addsub(dataA,dataB,mode,result,carry,err);


initial
begin
//        0123456789ABCDEF
$display("Addition");
mode=0; 
dataA=16'b0000000000000010; 
dataB=16'b0000000000000010;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);

 
mode=0; 
dataA=16'b0000000000000100;
dataB=16'b0000000000000100;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result); 
$display("err=%b",err);

mode=0; 
dataA=16'b1111111111111111;
dataB=16'b1111111111111111;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);



mode=0; 
dataA=16'b0010000000000100;
dataB=16'b0000000000001110;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


$display("Subtraction");
mode=1; 
dataA=16'b0000000000001110; 
dataB=16'b0000000000001100;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


mode=1; 
dataA=16'b0000000000001100;
dataB=16'b0000000000000010;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);


mode=1; 
dataA=16'b0000000000001100;
dataB=16'b0000000000000111;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);

mode=1; 
dataA=16'b0000000000001100;
dataB=16'b0000000000001110;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);




end




endmodule
*/



//-------------------------------------------------
/*
SixteenBitDivision
Completed by: Salem Nassar
*/
//-------------------------------------------------


module SixteenBitDivision(numerator,denominator,quotient,error);
// changed inputs to 16 bits
input [15:0] numerator;
input [15:0] denominator;
// changes outputs to 32 bits
output [31:0] quotient;
output error;

// changed wires to 16 bits
wire [15:0] numerator;
wire [15:0] denominator;
// changes registers to 32 bits
reg [31:0] quotient;
reg error;

always @(numerator,denominator)
begin
quotient=numerator/denominator;
// changed to match sample code but with new bit ammounts
quotient[16]=quotient[15];
quotient[17]=quotient[15];
quotient[18]=quotient[15];
quotient[19]=quotient[15];
quotient[20]=quotient[15];
quotient[21]=quotient[15];
quotient[22]=quotient[15];
quotient[23]=quotient[15];
quotient[24]=quotient[15];
quotient[25]=quotient[15];
quotient[26]=quotient[15];
quotient[27]=quotient[15];
quotient[28]=quotient[15];
quotient[29]=quotient[15];
quotient[30]=quotient[15];
quotient[31]=quotient[15];

// checks for divide by zero but with 16 bits
error=~(denominator[0]|denominator[1]|denominator[2]|denominator[3]|denominator[4]|denominator[5]|denominator[6]|denominator[7]|denominator[8]|denominator[9]|denominator[10]|denominator[11]|denominator[12]|denominator[13]|denominator[14]|denominator[15]);
end

endmodule


/*
module testbench();

// changed inputs to 16 bits
reg [15:0]inputA;
reg [15:0]inputB;
// changes output to 32 bits
wire [31:0] quotient;
wire error;

FourBitDivision D40(inputB,inputA,quotient,error);

initial begin
	
	// changed inputs to 16 bit binary numbers
	inputB=16'b0101101011001111;
	inputA=16'b0000101011000010;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);

	// changed inputs to 16 bit binary numbers
	inputB=16'b1111111111111111;
	inputA=16'b0000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);

end
endmodule
*/


//-------------------------------------------------
/*
SixteenBitModulus
Completed by: Salem Nassar
*/
//-------------------------------------------------


module SixteenBitModulus(numerator,denominator,modulus,error);
// changed inputs to 16 bits
input [15:0] numerator;
input [15:0] denominator;
// changed outputs to 32 bits
output [31:0] modulus;
output error;

// changed wires to 16 bits
wire [15:0] numerator;
wire [15:0] denominator;
//changed register to 32 bits
reg [31:0] modulus;
reg error;

always @(numerator,denominator)
begin
modulus=numerator%denominator;
// adjusted to match sample code but with new bit ammounts
modulus[16]=modulus[15];
modulus[16]=modulus[15];
modulus[18]=modulus[15];
modulus[19]=modulus[15];
modulus[20]=modulus[15];
modulus[21]=modulus[15];
modulus[22]=modulus[15];
modulus[23]=modulus[15];
modulus[24]=modulus[15];
modulus[25]=modulus[15];
modulus[26]=modulus[15];
modulus[27]=modulus[15];
modulus[28]=modulus[15];
modulus[29]=modulus[15];
modulus[30]=modulus[15];
modulus[31]=modulus[15];

// checks for divide by zero but with 16 bits
error=~(denominator[0]|denominator[1]|denominator[2]|denominator[3]|denominator[4]|denominator[5]|denominator[6]|denominator[7]|denominator[8]|denominator[9]|denominator[10]|denominator[11]|denominator[12]|denominator[13]|denominator[14]|denominator[15]);
end
endmodule

/*
module testbench();
// change inputs to 16 bits
reg [15:0]inputA;
reg [15:0]inputB;
// change output to 32 bits
wire [31:0] modulus;
wire error;

FourBitModulus M40(inputB,inputA,modulus,error);

initial begin

	// change inputs to 16 bit binary numbers
	inputB=16'b1111010111000010;
	inputA=16'b0000101111011111;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);
	
	// change inputs to 16 bit binary numbers
	inputB=16'b1111111100101111;
	inputA=16'b0000000000000000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

end
endmodule
*/
 
//-------------------------------------------------
//
// Sample 4-Bit Multiplier. No padding needed.
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


//=================================================================
//
// FourBitMultiplier
//
// Inputs:
// A, a 4-Bit Integer Input
// B, a 4-Bit Integer Input
// C, an 8-Bit Integer Output
//=================================================================
module FourBitMultiplier(A,B,C);
input  [3:0] A;
input  [3:0] B;
output [7:0] C;

reg [7:0] C;

//Local Variables
reg  [3:0] Augend0;
reg  [3:0] Adend0;
wire [3:0] Sum0;
wire  Carry0;

reg  [3:0] Augend1;
reg  [3:0] Adend1;
wire [3:0] Sum1;
wire  Carry1;

reg  [3:0] Augend2;
reg  [3:0] Adend2;
wire [3:0] Sum2;
wire  Carry2;

reg  [3:0] Augend3;
reg  [3:0] Adend3;
wire [3:0] Sum3;
wire  Carry3;
//16 clusters of this total



FourBitFullAdder add0(Augend0,Adend0,1'b0,Carry0,Sum0);
FourBitFullAdder add1(Augend1,Adend1,1'b0,Carry1,Sum1);
FourBitFullAdder add2(Augend2,Adend2,1'b0,Carry2,Sum2);
FourBitFullAdder add3(Augend3,Adend3,1'b0,Carry3,Sum3); //this is refered to the 4bitAdd.v file

always@(*)
begin


//Ihis is where you can write a program and use its output and use that to finish off the little guy
  
  Augend0={     1'b0,A[0]&B[3],A[0]&B[2],A[0]&B[1]}; //A[0] by B
   Adend0={A[1]&B[3],A[1]&B[2],A[1]&B[1],A[1]&B[0]}; //A[1] by B

  Augend1={Carry0 ,  Sum0[3],  Sum0[2],  Sum0[1]};
   Adend1={A[2]&B[3],A[2]&B[2],A[2]&B[1],A[2]&B[0]}; //A[2] by B

  Augend2={Carry1 ,  Sum1[3],  Sum1[2],  Sum1[1]};
   Adend2={A[3]&B[3],A[3]&B[2],A[3]&B[1],A[3]&B[0]}; //A[3] by B
   

  
   
  C[0]=  A[0]&B[0];//From Gates
//=================================  
  C[1]=  Sum0[0];//From Adder0
 //=================================
  C[2]=  Sum1[0];//From Adder1
 //=================================
  C[3] = Sum2[0];//From Adder2
  C[4] = Sum2[1];//From Adder2
  C[5] = Sum2[2];//From Adder2
  C[6] = Sum2[3];//From Adder2
  C[7] = Carry2 ;//From Adder2
	// This will go to C[31]
 end
endmodule


/*

module testbench();

reg [5:0]row;
reg [5:0]col;
reg [15:0] mark;

//Data Inputs
reg [5:0]dataA;
reg [5:0]dataB;
 

//Outputs
wire[7:0]result;
 

//Instantiate the Modules
FourBitMultiplier F4M(row[3:0],col[3:0],result);
initial
begin
//        0123456789ABCDEF
 

 
for (row=0;row<16;row++)
begin
	for (col=0;col<16;col++)
	begin
		#60;
		$write("%4d",result);
	end
$display();
end



end

endmodule
*/


//-------------------------------------------------
//
// Sample 4 to 16 decoder, Structural. 
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


//=================================================================
//
// DECODER
//
//=================================================================
module Dec4x16(binary,onehot);

	input [3:0] binary;
	output [15:0]onehot;
	
	assign onehot[ 0]=~binary[3]&~binary[2]&~binary[1]&~binary[0];
	assign onehot[ 1]=~binary[3]&~binary[2]&~binary[1]& binary[0];
	assign onehot[ 2]=~binary[3]&~binary[2]& binary[1]&~binary[0];
	assign onehot[ 3]=~binary[3]&~binary[2]& binary[1]& binary[0];
	assign onehot[ 4]=~binary[3]& binary[2]&~binary[1]&~binary[0];
	assign onehot[ 5]=~binary[3]& binary[2]&~binary[1]& binary[0];
	assign onehot[ 6]=~binary[3]& binary[2]& binary[1]&~binary[0];
	assign onehot[ 7]=~binary[3]& binary[2]& binary[1]& binary[0];
	assign onehot[ 8]= binary[3]&~binary[2]&~binary[1]&~binary[0];
	assign onehot[ 9]= binary[3]&~binary[2]&~binary[1]& binary[0];
	assign onehot[10]= binary[3]&~binary[2]& binary[1]&~binary[0];
	assign onehot[11]= binary[3]&~binary[2]& binary[1]& binary[0];
	assign onehot[12]= binary[3]& binary[2]&~binary[1]&~binary[0];
	assign onehot[13]= binary[3]& binary[2]&~binary[1]& binary[0];
	assign onehot[14]= binary[3]& binary[2]& binary[1]&~binary[0];
	assign onehot[15]= binary[3]& binary[2]& binary[1]& binary[0];
	//This will work as is, should not need to change
	
	
endmodule



//-------------------------------------------------
//
// Sample Multiplexer Circuit
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------



//=================================================================
//
// 8-bit, 16 channel Multiplexer
//
//=================================================================

module StructMux(channels, select, b);
input [15:0][7:0] channels;
input      [15:0] select; //one hot number 
output      [7:0] b;


	assign b = ({8{select[15]}} & channels[15]) | 
               ({8{select[14]}} & channels[14]) |
			   ({8{select[13]}} & channels[13]) |
			   ({8{select[12]}} & channels[12]) |
			   ({8{select[11]}} & channels[11]) |
			   ({8{select[10]}} & channels[10]) |
			   ({8{select[ 9]}} & channels[ 9]) | 
			   ({8{select[ 8]}} & channels[ 8]) |
			   ({8{select[ 7]}} & channels[ 7]) |
			   ({8{select[ 6]}} & channels[ 6]) |
			   ({8{select[ 5]}} & channels[ 5]) |  
			   ({8{select[ 4]}} & channels[ 4]) |  
			   ({8{select[ 3]}} & channels[ 3]) |  
			   ({8{select[ 2]}} & channels[ 2]) |  
               ({8{select[ 1]}} & channels[ 1]) |  
               ({8{select[ 0]}} & channels[ 0]) ; //change to 32 instead of 8

endmodule









