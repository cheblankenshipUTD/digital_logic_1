//-------------------------------------------------
//
// Sample Behavioral Modulus with padded 4-bits
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


module SixTeenBitModulus(numerator,denominator,modulus,error);
// changed inputs to 16 bits
input [15:0] numerator;
input [15:0] denominator;
// changed outputs to 32 bits
output [15:0] modulus;
output error;

// changed wires to 16 bits
wire [15:0] numerator;
wire [15:0] denominator;
//changed register to 32 bits
reg [15:0] modulus;
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

reg [3:0]inputA;
reg [3:0]inputB;
wire [3:0] modulus;
wire error;

SixTeenBitModulus M40(inputB,inputA,modulus,error);

initial begin
	inputB=4'b1111;
	inputA=4'b0010;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

	inputB=4'b1111;
	inputA=4'b0000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

end
endmodule
*/
 
