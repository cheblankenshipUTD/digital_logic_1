//-------------------------------------------------
//
// Sample 16-Bit Full Adder
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
module SixTeenBitFullAdder(A,B,C,Carry,Sum);
input [15:0] A;
input [15:0] B;
input C;
output Carry;
output [15:0] Sum;
 
wire temp[14:0];

FullAdder FA0(A[0],B[0],C      ,temp[0],Sum[0]);
FullAdder FA1(A[1],B[1],temp[0],temp[1],Sum[1]);
FullAdder FA2(A[2],B[2],temp[1],temp[2],Sum[2]);
FullAdder FA3(A[3],B[3],temp[2],temp[3],Sum[3]);
FullAdder FA4(A[4],B[4],temp[3],temp[4],Sum[4]);
FullAdder FA5(A[5],B[5],temp[4],temp[5],Sum[5]);
FullAdder FA6(A[6],B[6],temp[5],temp[6],Sum[6]);
FullAdder FA7(A[7],B[7],temp[6],temp[7],Sum[7]);
FullAdder FA8(A[8],B[8],temp[7],temp[8],Sum[8]);
FullAdder FA9(A[9],B[9],temp[8],temp[9],Sum[9]);
FullAdder FA10(A[10],B[10],temp[9],temp[10],Sum[10]);
FullAdder FA11(A[11],B[11],temp[10],temp[11],Sum[11]);
FullAdder FA12(A[12],B[12],temp[11],temp[12],Sum[12]);
FullAdder FA13(A[13],B[13],temp[12],temp[13],Sum[13]);
FullAdder FA14(A[14],B[14],temp[13],temp[14],Sum[14]);
FullAdder FA15(A[15],B[15],temp[14],Carry,Sum[15]);

endmodule


// module testbench();
// //Data Inputs
// reg [15:0]dataA;
// reg [15:0]dataB;
// reg dataC;
// //Outputs
// wire[15:0]result;
// wire carry;
// SixTeenBitFullAdder F16A0(dataA,dataB,dataC,carry,result);
// initial
// begin
// //        0123456789ABCDEF
// $display("Addition");
// dataA=16'b1111111111111111; 
// dataB=16'b1111111111111111;
// dataC=0;
// #100;

// $display("%b+%b+%b=%b:%b",dataA,dataB,dataC,carry,result);

// end

// endmodule
