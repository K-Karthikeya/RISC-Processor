
module CLA_16bit(
	input [15:0]a,
	input [15:0]b,
	input mode,
	output [15:0]sum,
	output cout,
	output ovfl
);

wire [15:0]b_internal;
wire [2:0] cout_internal;
wire cin;
CLA_4bit adder0(.a(a[3:0]), .b(b_internal[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout_internal[0]));
CLA_4bit adder1(.a(a[7:4]), .b(b_internal[7:4]), .cin(cout_internal[0]), .sum(sum[7:4]), .cout(cout_internal[1]));
CLA_4bit adder2(.a(a[11:8]), .b(b_internal[11:8]), .cin(cout_internal[1]), .sum(sum[11:8]), .cout(cout_internal[2]));
CLA_4bit adder3(.a(a[15:12]), .b(b_internal[15:12]), .cin(cout_internal[2]), .sum(sum[15:12]), .cout(cout));

assign b_internal = mode ? ~b : b;
assign cin = mode ? 1 : 0;
assign ovfl = (a[15] == b_internal[15]) ? (a[15] == sum[15]) ? 0 : 1 : 0;
endmodule 