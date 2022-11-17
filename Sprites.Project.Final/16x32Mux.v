
//=================================================================
//
// 8-bit, 16 channel Multiplexer
//
//=================================================================

module StructMux(channels, select, b);
// orignal input [31:0][15:0] channels;
input [15:0][31:0] channels;

input      [15:0] select;
output      [31:0] b;


	assign b =
	
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
