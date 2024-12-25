
module ALU_PADDSB(
	input [15:0] a, 
	input [15:0] b,
	output [15:0] result,
	output ovfl,
	output zero,
	output sign
); 


paddsb ADD1(.result(result[3:0]), .a(a[3:0]), .b(b[3:0])); 
paddsb ADD2(.result(result[7:4]), .a(a[7:4]), .b(b[7:4])); 
paddsb ADD3(.result(result[11:8]), .a(a[11:8]), .b(b[11:8]));
paddsb ADD4(.result(result[15:12]), .a(a[15:12]), .b(b[15:12]));

assign ovfl = 1'bz;
assign zero = 1'bz;
assign sign = 1'bz;

endmodule
