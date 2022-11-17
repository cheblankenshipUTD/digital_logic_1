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
module SixTeenBitMultiplier(A,B,C);
input  [15:0] A;
input  [15:0] B;
output [31:0] C;

reg [31:0] C;

//Local Variables
reg  [15:0] Augend00;
reg  [15:0] Adend00;
wire [15:0] Sum00;
wire [15:0] Carry00;
reg  [15:0] Augend01;
reg  [15:0] Adend01;
wire [15:0] Sum01;
wire [15:0] Carry01;
reg  [15:0] Augend02;
reg  [15:0] Adend02;
wire [15:0] Sum02;
wire [15:0] Carry02;
reg  [15:0] Augend03;
reg  [15:0] Adend03;
wire [15:0] Sum03;
wire [15:0] Carry03;
reg  [15:0] Augend04;
reg  [15:0] Adend04;
wire [15:0] Sum04;
wire [15:0] Carry04;
reg  [15:0] Augend05;
reg  [15:0] Adend05;
wire [15:0] Sum05;
wire [15:0] Carry05;
reg  [15:0] Augend06;
reg  [15:0] Adend06;
wire [15:0] Sum06;
wire [15:0] Carry06;
reg  [15:0] Augend07;
reg  [15:0] Adend07;
wire [15:0] Sum07;
wire [15:0] Carry07;
reg  [15:0] Augend08;
reg  [15:0] Adend08;
wire [15:0] Sum08;
wire [15:0] Carry08;
reg  [15:0] Augend09;
reg  [15:0] Adend09;
wire [15:0] Sum09;
wire [15:0] Carry09;
reg  [15:0] Augend10;
reg  [15:0] Adend10;
wire [15:0] Sum10;
wire [15:0] Carry10;
reg  [15:0] Augend11;
reg  [15:0] Adend11;
wire [15:0] Sum11;
wire [15:0] Carry11;
reg  [15:0] Augend12;
reg  [15:0] Adend12;
wire [15:0] Sum12;
wire [15:0] Carry12;
reg  [15:0] Augend13;
reg  [15:0] Adend13;
wire [15:0] Sum13;
wire [15:0] Carry13;
reg  [15:0] Augend14;
reg  [15:0] Adend14;
wire [15:0] Sum14;
wire [15:0] Carry14;
reg  [15:0] Augend15;
reg  [15:0] Adend15;
wire [15:0] Sum15;
wire [15:0] Carry15;


SixTeenBitFullAdder add00(Augend00,Adend00,1'b0,Carry00,Sum00);
SixTeenBitFullAdder add01(Augend01,Adend01,1'b0,Carry01,Sum01);
SixTeenBitFullAdder add02(Augend02,Adend02,1'b0,Carry02,Sum02);
SixTeenBitFullAdder add03(Augend03,Adend03,1'b0,Carry03,Sum03);
SixTeenBitFullAdder add04(Augend04,Adend04,1'b0,Carry04,Sum04);
SixTeenBitFullAdder add05(Augend05,Adend05,1'b0,Carry05,Sum05);
SixTeenBitFullAdder add06(Augend06,Adend06,1'b0,Carry06,Sum06);
SixTeenBitFullAdder add07(Augend07,Adend07,1'b0,Carry07,Sum07);
SixTeenBitFullAdder add08(Augend08,Adend08,1'b0,Carry08,Sum08);
SixTeenBitFullAdder add09(Augend09,Adend09,1'b0,Carry09,Sum09);
SixTeenBitFullAdder add10(Augend10,Adend10,1'b0,Carry10,Sum10);
SixTeenBitFullAdder add11(Augend11,Adend11,1'b0,Carry11,Sum11);
SixTeenBitFullAdder add12(Augend12,Adend12,1'b0,Carry12,Sum12);
SixTeenBitFullAdder add13(Augend13,Adend13,1'b0,Carry13,Sum13);
SixTeenBitFullAdder add14(Augend14,Adend14,1'b0,Carry14,Sum14);
SixTeenBitFullAdder add15(Augend15,Adend15,1'b0,Carry15,Sum15);


always@(*)
begin
  
  Adend00={A[  1]&B[ 15],A[  1]&B[ 14],A[  1]&B[ 13],A[  1]&B[ 12],A[  1]&B[ 11],A[  1]&B[ 10],A[  1]&B[  9],A[  1]&B[  8],A[  1]&B[  7],A[  1]&B[  6],A[  1]&B[  5],A[  1]&B[  4],A[  1]&B[  3],A[  1]&B[  2],A[  1]&B[  1],A[  1]&B[  0]};
  Adend01={A[  2]&B[ 15],A[  2]&B[ 14],A[  2]&B[ 13],A[  2]&B[ 12],A[  2]&B[ 11],A[  2]&B[ 10],A[  2]&B[  9],A[  2]&B[  8],A[  2]&B[  7],A[  2]&B[  6],A[  2]&B[  5],A[  2]&B[  4],A[  2]&B[  3],A[  2]&B[  2],A[  2]&B[  1],A[  2]&B[  0]};
  Adend02={A[  3]&B[ 15],A[  3]&B[ 14],A[  3]&B[ 13],A[  3]&B[ 12],A[  3]&B[ 11],A[  3]&B[ 10],A[  3]&B[  9],A[  3]&B[  8],A[  3]&B[  7],A[  3]&B[  6],A[  3]&B[  5],A[  3]&B[  4],A[  3]&B[  3],A[  3]&B[  2],A[  3]&B[  1],A[  3]&B[  0]};
  Adend03={A[  4]&B[ 15],A[  4]&B[ 14],A[  4]&B[ 13],A[  4]&B[ 12],A[  4]&B[ 11],A[  4]&B[ 10],A[  4]&B[  9],A[  4]&B[  8],A[  4]&B[  7],A[  4]&B[  6],A[  4]&B[  5],A[  4]&B[  4],A[  4]&B[  3],A[  4]&B[  2],A[  4]&B[  1],A[  4]&B[  0]};
  Adend04={A[  5]&B[ 15],A[  5]&B[ 14],A[  5]&B[ 13],A[  5]&B[ 12],A[  5]&B[ 11],A[  5]&B[ 10],A[  5]&B[  9],A[  5]&B[  8],A[  5]&B[  7],A[  5]&B[  6],A[  5]&B[  5],A[  5]&B[  4],A[  5]&B[  3],A[  5]&B[  2],A[  5]&B[  1],A[  5]&B[  0]};
  Adend05={A[  6]&B[ 15],A[  6]&B[ 14],A[  6]&B[ 13],A[  6]&B[ 12],A[  6]&B[ 11],A[  6]&B[ 10],A[  6]&B[  9],A[  6]&B[  8],A[  6]&B[  7],A[  6]&B[  6],A[  6]&B[  5],A[  6]&B[  4],A[  6]&B[  3],A[  6]&B[  2],A[  6]&B[  1],A[  6]&B[  0]};
  Adend06={A[  7]&B[ 15],A[  7]&B[ 14],A[  7]&B[ 13],A[  7]&B[ 12],A[  7]&B[ 11],A[  7]&B[ 10],A[  7]&B[  9],A[  7]&B[  8],A[  7]&B[  7],A[  7]&B[  6],A[  7]&B[  5],A[  7]&B[  4],A[  7]&B[  3],A[  7]&B[  2],A[  7]&B[  1],A[  7]&B[  0]};
  Adend07={A[  8]&B[ 15],A[  8]&B[ 14],A[  8]&B[ 13],A[  8]&B[ 12],A[  8]&B[ 11],A[  8]&B[ 10],A[  8]&B[  9],A[  8]&B[  8],A[  8]&B[  7],A[  8]&B[  6],A[  8]&B[  5],A[  8]&B[  4],A[  8]&B[  3],A[  8]&B[  2],A[  8]&B[  1],A[  8]&B[  0]};
  Adend08={A[  9]&B[ 15],A[  9]&B[ 14],A[  9]&B[ 13],A[  9]&B[ 12],A[  9]&B[ 11],A[  9]&B[ 10],A[  9]&B[  9],A[  9]&B[  8],A[  9]&B[  7],A[  9]&B[  6],A[  9]&B[  5],A[  9]&B[  4],A[  9]&B[  3],A[  9]&B[  2],A[  9]&B[  1],A[  9]&B[  0]};
  Adend09={A[ 10]&B[ 15],A[ 10]&B[ 14],A[ 10]&B[ 13],A[ 10]&B[ 12],A[ 10]&B[ 11],A[ 10]&B[ 10],A[ 10]&B[  9],A[ 10]&B[  8],A[ 10]&B[  7],A[ 10]&B[  6],A[ 10]&B[  5],A[ 10]&B[  4],A[ 10]&B[  3],A[ 10]&B[  2],A[ 10]&B[  1],A[ 10]&B[  0]};
  Adend10={A[ 11]&B[ 15],A[ 11]&B[ 14],A[ 11]&B[ 13],A[ 11]&B[ 12],A[ 11]&B[ 11],A[ 11]&B[ 10],A[ 11]&B[  9],A[ 11]&B[  8],A[ 11]&B[  7],A[ 11]&B[  6],A[ 11]&B[  5],A[ 11]&B[  4],A[ 11]&B[  3],A[ 11]&B[  2],A[ 11]&B[  1],A[ 11]&B[  0]};
  Adend11={A[ 12]&B[ 15],A[ 12]&B[ 14],A[ 12]&B[ 13],A[ 12]&B[ 12],A[ 12]&B[ 11],A[ 12]&B[ 10],A[ 12]&B[  9],A[ 12]&B[  8],A[ 12]&B[  7],A[ 12]&B[  6],A[ 12]&B[  5],A[ 12]&B[  4],A[ 12]&B[  3],A[ 12]&B[  2],A[ 12]&B[  1],A[ 12]&B[  0]};
  Adend12={A[ 13]&B[ 15],A[ 13]&B[ 14],A[ 13]&B[ 13],A[ 13]&B[ 12],A[ 13]&B[ 11],A[ 13]&B[ 10],A[ 13]&B[  9],A[ 13]&B[  8],A[ 13]&B[  7],A[ 13]&B[  6],A[ 13]&B[  5],A[ 13]&B[  4],A[ 13]&B[  3],A[ 13]&B[  2],A[ 13]&B[  1],A[ 13]&B[  0]};
  Adend13={A[ 14]&B[ 15],A[ 14]&B[ 14],A[ 14]&B[ 13],A[ 14]&B[ 12],A[ 14]&B[ 11],A[ 14]&B[ 10],A[ 14]&B[  9],A[ 14]&B[  8],A[ 14]&B[  7],A[ 14]&B[  6],A[ 14]&B[  5],A[ 14]&B[  4],A[ 14]&B[  3],A[ 14]&B[  2],A[ 14]&B[  1],A[ 14]&B[  0]};
  Adend14={A[ 15]&B[ 15],A[ 15]&B[ 14],A[ 15]&B[ 13],A[ 15]&B[ 12],A[ 15]&B[ 11],A[ 15]&B[ 10],A[ 15]&B[  9],A[ 15]&B[  8],A[ 15]&B[  7],A[ 15]&B[  6],A[ 15]&B[  5],A[ 15]&B[  4],A[ 15]&B[  3],A[ 15]&B[  2],A[ 15]&B[  1],A[ 15]&B[  0]};
  

Augend00={        1'b0,A[0]&B[15],A[0]&B[14],A[0]&B[13],A[0]&B[12],A[0]&B[11],A[0]&B[10],A[0]&B[ 9],A[0]&B[ 8],A[0]&B[ 7],A[0]&B[ 6],A[0]&B[ 5],A[0]&B[ 4],A[0]&B[ 3],A[0]&B[ 2],A[0]&B[ 1]};
Augend01={Carry00[ 15],Sum00[ 15],Sum00[ 14],Sum00[ 13],Sum00[ 12],Sum00[ 11],Sum00[ 10],Sum00[  9],Sum00[  8],Sum00[  7],Sum00[  6],Sum00[  5],Sum00[  4],Sum00[  3],Sum00[  2],Sum00[  1]};


Augend02={Carry01[ 15],Sum01[ 15],Sum01[ 14],Sum01[ 13],Sum01[ 12],Sum01[ 11],Sum01[ 10],Sum01[  9],Sum01[  8],Sum01[  7],Sum01[  6],Sum01[  5],Sum01[  4],Sum01[  3],Sum01[  2],Sum01[  1]};

 
Augend03={Carry02[ 15],Sum02[ 15],Sum02[ 14],Sum02[ 13],Sum02[ 12],Sum02[ 11],Sum02[ 10],Sum02[  9],Sum02[  8],Sum02[  7],Sum02[  6],Sum02[  5],Sum02[  4],Sum02[  3],Sum02[  2],Sum02[  1]};
Augend04={Carry03[ 15],Sum03[ 15],Sum03[ 14],Sum03[ 13],Sum03[ 12],Sum03[ 11],Sum03[ 10],Sum03[  9],Sum03[  8],Sum03[  7],Sum03[  6],Sum03[  5],Sum03[  4],Sum03[  3],Sum03[  2],Sum03[  1]};
Augend05={Carry04[ 15],Sum04[ 15],Sum04[ 14],Sum04[ 13],Sum04[ 12],Sum04[ 11],Sum04[ 10],Sum04[  9],Sum04[  8],Sum04[  7],Sum04[  6],Sum04[  5],Sum04[  4],Sum04[  3],Sum04[  2],Sum04[  1]};
Augend06={Carry05[ 15],Sum05[ 15],Sum05[ 14],Sum05[ 13],Sum05[ 12],Sum05[ 11],Sum05[ 10],Sum05[  9],Sum05[  8],Sum05[  7],Sum05[  6],Sum05[  5],Sum05[  4],Sum05[  3],Sum05[  2],Sum05[  1]};
Augend07={Carry06[ 15],Sum06[ 15],Sum06[ 14],Sum06[ 13],Sum06[ 12],Sum06[ 11],Sum06[ 10],Sum06[  9],Sum06[  8],Sum06[  7],Sum06[  6],Sum06[  5],Sum06[  4],Sum06[  3],Sum06[  2],Sum06[  1]};
Augend08={Carry07[ 15],Sum07[ 15],Sum07[ 14],Sum07[ 13],Sum07[ 12],Sum07[ 11],Sum07[ 10],Sum07[  9],Sum07[  8],Sum07[  7],Sum07[  6],Sum07[  5],Sum07[  4],Sum07[  3],Sum07[  2],Sum07[  1]};
Augend09={Carry08[ 15],Sum08[ 15],Sum08[ 14],Sum08[ 13],Sum08[ 12],Sum08[ 11],Sum08[ 10],Sum08[  9],Sum08[  8],Sum08[  7],Sum08[  6],Sum08[  5],Sum08[  4],Sum08[  3],Sum08[  2],Sum08[  1]};
Augend10={Carry09[ 15],Sum09[ 15],Sum09[ 14],Sum09[ 13],Sum09[ 12],Sum09[ 11],Sum09[ 10],Sum09[  9],Sum09[  8],Sum09[  7],Sum09[  6],Sum09[  5],Sum09[  4],Sum09[  3],Sum09[  2],Sum09[  1]};
Augend11={Carry10[ 15],Sum10[ 15],Sum10[ 14],Sum10[ 13],Sum10[ 12],Sum10[ 11],Sum10[ 10],Sum10[  9],Sum10[  8],Sum10[  7],Sum10[  6],Sum10[  5],Sum10[  4],Sum10[  3],Sum10[  2],Sum10[  1]};
Augend12={Carry11[ 15],Sum11[ 15],Sum11[ 14],Sum11[ 13],Sum11[ 12],Sum11[ 11],Sum11[ 10],Sum11[  9],Sum11[  8],Sum11[  7],Sum11[  6],Sum11[  5],Sum11[  4],Sum11[  3],Sum11[  2],Sum11[  1]};
Augend13={Carry12[ 15],Sum12[ 15],Sum12[ 14],Sum12[ 13],Sum12[ 12],Sum12[ 11],Sum12[ 10],Sum12[  9],Sum12[  8],Sum12[  7],Sum12[  6],Sum12[  5],Sum12[  4],Sum12[  3],Sum12[  2],Sum12[  1]};
Augend14={Carry13[ 15],Sum13[ 15],Sum13[ 14],Sum13[ 13],Sum13[ 12],Sum13[ 11],Sum13[ 10],Sum13[  9],Sum13[  8],Sum13[  7],Sum13[  6],Sum13[  5],Sum13[  4],Sum13[  3],Sum13[  2],Sum13[  1]};
Augend15={Carry14[ 15],Sum14[ 15],Sum14[ 14],Sum14[ 13],Sum14[ 12],Sum14[ 11],Sum14[ 10],Sum14[  9],Sum14[  8],Sum14[  7],Sum14[  6],Sum14[  5],Sum14[  4],Sum14[  3],Sum14[  2],Sum14[  1]};
 

  C=32'b0; 
  C[ 0] = A[0]&B[0];//From Gates
  C[ 1] = Sum00[0];
  C[ 2] = Sum01[0];
  C[ 3] = Sum02[0];
  C[ 4] = Sum03[0];
  C[ 5] = Sum04[0];
  C[ 6] = Sum05[0];
  C[ 7] = Sum06[0];
  C[ 8] = Sum07[0];
  C[ 9] = Sum08[0];
  C[10] = Sum09[0];
  C[11] = Sum10[0];
  C[12] = Sum11[0];
  C[13] = Sum12[0];
  C[14] = Sum13[0];
  C[15] = Sum14[0];
  C[16] = Sum14[0]; 

  C[17] = Sum14[1]; 
  C[18] = Sum14[2]; 
  C[19] = Sum14[3]; 
  C[20] = Sum14[4]; 
  C[21] = Sum14[5]; 
  C[22] = Sum14[6]; 
  C[23] = Sum14[7]; 
  C[24] = Sum14[8]; 
  C[25] = Sum14[9];
  C[26] = Sum14[10]; 
  C[27] = Sum14[11]; 
  C[28] = Sum14[12]; 
  C[29] = Sum14[13];
  C[30] = Sum14[14];
  C[31] = Sum14[15];
  C[32] = Carry14[15];




end


endmodule
