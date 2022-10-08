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
endmodule

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