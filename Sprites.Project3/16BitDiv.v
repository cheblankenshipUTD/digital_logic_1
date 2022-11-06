//-------------------------------------------------
//
// Sample Behavioral Divider with padded 4 bits.
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


module SixTeenBitDivision(numerator,denominator,quotient,error);
input [15:0] numerator;
input [15:0] denominator;
output [31:0] quotient;
output error;

wire [15:0] numerator;
wire [15:0] denominator;
reg [31:0] quotient;
reg error;

always @(numerator,denominator)
begin
quotient = numerator/denominator;
quotient[16] = quotient[15];
quotient[17] = quotient[15];
quotient[18] = quotient[15];
quotient[19] = quotient[15];
quotient[20] = quotient[15];
quotient[21] = quotient[15];
quotient[22] = quotient[15];
quotient[23] = quotient[15];
quotient[24] = quotient[15];
quotient[25] = quotient[15];
quotient[26] = quotient[15];
quotient[27] = quotient[15];
quotient[28] = quotient[15];
quotient[29] = quotient[15];
quotient[30] = quotient[15];
quotient[31] = quotient[15];
error = ~(
	denominator[15]|denominator[14]|denominator[13]|denominator[12]|
	denominator[11]|denominator[10]|denominator[9]|denominator[8]|
	denominator[7]|denominator[6]|denominator[5]|denominator[4]|
	denominator[3]|denominator[2]|denominator[1]|denominator[0]
);
end

endmodule



// module testbench();

// reg [15:0]inputA;
// reg [15:0]inputB;
// wire [31:0] quotient;
// wire error;

// FourBitDivision D40(inputB,inputA,quotient,error);

// initial begin
// 	inputB=16'b1111111111111111;
// 	inputA=16'b0000000000000010;
// 	#60;
// 	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);

// 	inputB=16'b1111111111111111;
// 	inputA=16'b0000000000000000;
// 	#60;
// 	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);
// end
// endmodule

