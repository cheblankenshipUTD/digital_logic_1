
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