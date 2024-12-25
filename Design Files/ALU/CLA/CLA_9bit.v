

module CLA_9bit(
	input [8:0]a,
	input [8:0]b,
	input mode,
	output [9:0]sum,
	output cout,
	output ovfl
);

wire [8:0]b_internal;
wire [1:0]cout_internal;
wire cin;
CLA_4bit adder0(.a(a[3:0]), .b(b_internal[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout_internal[0]));
CLA_4bit adder1(.a(a[7:4]), .b(b_internal[7:4]), .cin(cout_internal[0]), .sum(sum[7:4]), .cout(cout_internal[1]));
CLA_4bit adder2(.a({ {3{1'b0}} , a[8]}), .b({ {3{1'b0}} , b_internal[8]}), .cin(cout_internal[1]), .sum(sum[9:8]), .cout(cout));

assign b_internal = mode ? ~b : b;
assign cin = mode ? 1 : 0;
assign ovfl = (a[8] == b_internal[8]) ? (a[8] == sum[8]) ? 0 : 1 : 0;
endmodule 