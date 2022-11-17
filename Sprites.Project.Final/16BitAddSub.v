//-------------------------------------------------
//
// Sample 4-Bit Adder/Subtractor with padded 4 bits
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


module SixTeenBitAddSub(inputA,inputB,mode,carry,sum,overflow);
    input [15:0] inputA;
	input [15:0] inputB;
    input mode;
    output [15:0] sum;
	output carry;
    output overflow;
 wire [15:0] xorInterface; //XOR Interfaces
	wire [15:0] carryInterface; //Carry Interfaces
	
 
	
	assign xorInterface={16{mode}}^inputB;

FullAdder FA00(inputA[ 0],xorInterface[ 0],              mode,carryInterface[ 0],sum[ 0]);
FullAdder FA01(inputA[ 1],xorInterface[ 1],carryInterface[ 0],carryInterface[ 1],sum[ 1]);
FullAdder FA02(inputA[ 2],xorInterface[ 2],carryInterface[ 1],carryInterface[ 2],sum[ 2]);
FullAdder FA03(inputA[ 3],xorInterface[ 3],carryInterface[ 2],carryInterface[ 3],sum[ 3]);
FullAdder FA04(inputA[ 4],xorInterface[ 4],carryInterface[ 3],carryInterface[ 4],sum[ 4]);
FullAdder FA05(inputA[ 5],xorInterface[ 5],carryInterface[ 4],carryInterface[ 5],sum[ 5]);
FullAdder FA06(inputA[ 6],xorInterface[ 6],carryInterface[ 5],carryInterface[ 6],sum[ 6]);
FullAdder FA07(inputA[ 7],xorInterface[ 7],carryInterface[ 6],carryInterface[ 7],sum[ 7]);
FullAdder FA08(inputA[ 8],xorInterface[ 8],carryInterface[ 7],carryInterface[ 8],sum[ 8]);
FullAdder FA09(inputA[ 9],xorInterface[ 9],carryInterface[ 8],carryInterface[ 9],sum[ 9]);
FullAdder FA10(inputA[10],xorInterface[10],carryInterface[ 9],carryInterface[10],sum[10]);
FullAdder FA11(inputA[11],xorInterface[11],carryInterface[10],carryInterface[11],sum[11]);
FullAdder FA12(inputA[12],xorInterface[12],carryInterface[11],carryInterface[12],sum[12]);
FullAdder FA13(inputA[13],xorInterface[13],carryInterface[12],carryInterface[13],sum[13]);
FullAdder FA14(inputA[14],xorInterface[14],carryInterface[13],carryInterface[14],sum[14]);
FullAdder FA15(inputA[15],xorInterface[15],carryInterface[14],carryInterface[15],sum[15]);



 
 
	assign carry=carryInterface[15];
	assign overflow=carryInterface[15]^carryInterface[14];
	//wire c0; //MOde assigned to C0

   // wire b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15; //XOR Interfaces
	//wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; //Carry Interfaces
	
//	assign c0=mode;//Mode=0, Addition; Mode=1, Subtraction
	
 //   assign b0 = inputB[0] ^ mode;//Flip the Bit if Subtraction
//    assign b1 = inputB[1] ^ mode;//Flip the Bit if Subtraction
//    assign b2 = inputB[2] ^ mode;//Flip the Bit if Subtraction
//    assign b3 = inputB[3] ^ mode;//Flip the Bit if Subtraction
//	assign b4 = inputB[4] ^ mode;//Flip the Bit if Subtraction
//	assign b5 = inputB[5] ^ mode;//Flip the Bit if Subtraction
//	assign b6 = inputB[6] ^ mode;//Flip the Bit if Subtraction
//	assign b7 = inputB[7] ^ mode;//Flip the Bit if Subtraction
//	assign b8 = inputB[8] ^ mode;//Flip the Bit if Subtraction
//	assign b9 = inputB[9] ^ mode;//Flip the Bit if Subtraction
//	assign b10 = inputB[10] ^ mode;//Flip the Bit if Subtraction
//	assign b11 = inputB[11] ^ mode;//Flip the Bit if Subtraction
//	assign b12 = inputB[12] ^ mode;//Flip the Bit if Subtraction
//	assign b13 = inputB[13] ^ mode;//Flip the Bit if Subtraction
//	assign b14 = inputB[14] ^ mode;//Flip the Bit if Subtraction
//	assign b15 = inputB[15] ^ mode;//Flip the Bit if Subtraction

	
 
//	FullAdder FA0(inputA[0],b0,  c0,c1,sum[0]);
//	FullAdder FA1(inputA[1],b1,  c1,c2,sum[1]);
//	FullAdder FA2(inputA[2],b2,  c2,c3,sum[2]);
//	FullAdder FA3(inputA[3],b3,  c3,c4,sum[3]);
//	FullAdder FA4(inputA[4],b4,  c4,c5,sum[4]);
//	FullAdder FA5(inputA[5],b5,  c5,c6,sum[5]);
//	FullAdder FA6(inputA[6],b6,  c6,c7,sum[6]);
//	FullAdder FA7(inputA[7],b7,  c7,c8,sum[7]);
//	FullAdder FA8(inputA[8],b8,  c8,c9,sum[8]);
//	FullAdder FA9(inputA[9],b9,  c9,c10,sum[9]);
//	FullAdder FA10(inputA[10],b10,  c10,c11,sum[10]);
//	FullAdder FA11(inputA[11],b11,  c11,c12,sum[11]);
//	FullAdder FA12(inputA[12],b12,  c12,c13,sum[12]);
//	FullAdder FA13(inputA[13],b13,  c13,c14,sum[13]);
//	FullAdder FA14(inputA[14],b14,  c14,c15,sum[14]);
//	FullAdder FA15(inputA[15],b15,  c15,c16,sum[15]);


//	assign sum[16]=sum[15];
//	assign sum[17]=sum[15];
//	assign sum[18]=sum[15];
//	assign sum[19]=sum[15];
//	assign sum[20]=sum[15];
//	assign sum[21]=sum[15];
//	assign sum[22]=sum[15];
//	assign sum[23]=sum[15];
//	assign sum[24]=sum[15];
//	assign sum[25]=sum[15];
//	assign sum[26]=sum[15];
//	assign sum[27]=sum[15];
//	assign sum[28]=sum[15];
//	assign sum[29]=sum[15];
///	assign sum[31]=sum[15];


	
//	assign carry=c16;
//	assign overflow=c16^c15;
	
 
endmodule



// module testbench();


// //Data Inputs
// reg [15:0]dataA;
// reg [15:0]dataB;
// reg mode;

// //Outputs
// wire[31:0]result;
// wire carry;
// wire err;

// //Instantiate the Modules
// SixTeenBitAddSub addsub(dataA,dataB,mode,result,carry,err);


// initial
// begin
// //        0123456789ABCDEF
// $display("Addition");
// mode=0; 
// dataA=16'b0000000000000010; 
// dataB=16'b0000000000000010;
// #100;
 
// $write("mode=%b;",mode);
// $write("%b+%b=[%b];",dataA,dataB,result);
// $display("err=%b",err);

 
// mode=0; 
// dataA=16'b0000000000000100;
// dataB=16'b0000000000000100;
// #100;
// $write("mode=%b;",mode);
// $write("%b+%b=[%b];",dataA,dataB,result); 
// $display("err=%b",err);

// mode=0; 
// dataA=16'b1111111111111111;
// dataB=16'b1111111111111111;
// #100;
 
// $write("mode=%b;",mode);
// $write("%b+%b=[%b];",dataA,dataB,result);
// $display("err=%b",err);



// mode=0; 
// dataA=16'b0010000000000100;
// dataB=16'b0000000000001110;
// #100;
// $write("mode=%b;",mode);
// $write("%b+%b=[%b];",dataA,dataB,result);
// $display("err=%b",err);


// $display("Subtraction");
// mode=1; 
// dataA=16'b0000000000001110; 
// dataB=16'b0000000000001100;
// #100;
// $write("mode=%b;",mode);
// $write("%b-%b=[%b];",dataA,dataB,result);
// $display("err=%b",err);


// mode=1; 
// dataA=16'b0000000000001100;
// dataB=16'b0000000000000010;
// #100;
// $write("mode=%b;",mode);
// $write("%b-%b=[%b];",dataA,dataB,result);
 
// $display("err=%b",err);


// mode=1; 
// dataA=16'b0000000000001100;
// dataB=16'b0000000000000111;
// #100;
// $write("mode=%b;",mode);
// $write("%b-%b=[%b];",dataA,dataB,result);
 
// $display("err=%b",err);

// mode=1; 
// dataA=16'b0000000000000000;
// dataB=16'b0000000000001110;
// #100;
// $write("mode=%b;",mode);
// $write("%b-%b=[%b];",dataA,dataB,result);
 
// $display("err=%b",err);




// end




// endmodule
