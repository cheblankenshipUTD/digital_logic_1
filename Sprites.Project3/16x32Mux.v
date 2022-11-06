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
input [31:0][15:0] channels;
input      [15:0] select;
output      [31:0] b;


	assign b =
		// ({32{select[31]}} & channels[31]) |
		// ({32{select[30]}} & channels[30]) |
		// ({32{select[29]}} & channels[29]) |
		// ({32{select[28]}} & channels[28]) |
		// ({32{select[27]}} & channels[27]) |
		// ({32{select[26]}} & channels[26]) |
		// ({32{select[25]}} & channels[25]) |
		// ({32{select[24]}} & channels[24]) |
		// ({32{select[23]}} & channels[23]) |
		// ({32{select[22]}} & channels[22]) |
		// ({32{select[21]}} & channels[21]) |
		// ({32{select[20]}} & channels[20]) |
		// ({32{select[19]}} & channels[19]) |
		// ({32{select[18]}} & channels[18]) |
		// ({32{select[17]}} & channels[17]) |
		// ({32{select[16]}} & channels[16]) |
		({32{select[15]}} & channels[15]) | 
        ({32{select[14]}} & channels[14]) |
		({32{select[13]}} & channels[13]) |
		({32{select[12]}} & channels[12]) |
		({32{select[11]}} & channels[11]) |
		({32{select[10]}} & channels[10]) |
		({32{select[ 9]}} & channels[ 9]) | 
		({32{select[ 8]}} & channels[ 8]) |
		({32{select[ 7]}} & channels[ 7]) |
		({32{select[ 6]}} & channels[ 6]) |
		({32{select[ 5]}} & channels[ 5]) |  
		({32{select[ 4]}} & channels[ 4]) |  
		({32{select[ 3]}} & channels[ 3]) |  
		({32{select[ 2]}} & channels[ 2]) |  
        ({32{select[ 1]}} & channels[ 1]) |  
        ({32{select[ 0]}} & channels[ 0]) ;

endmodule
