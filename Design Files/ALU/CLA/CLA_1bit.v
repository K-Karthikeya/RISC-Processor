
module CLA_1bit(
	input a,
	input b,
	input cin,
	output p,
	output g,
	output sum
);

assign sum = a ^ b ^ cin;
assign p = a ^ b;
assign g = a & b;

endmodule