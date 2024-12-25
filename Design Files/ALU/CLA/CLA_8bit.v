
module CLA_8bit(
	input [7:0]a,
	input [7:0]b,
	input mode,
	output [7:0]sum,
	output cout,
	output ovfl
);

wire [7:0]b_internal;
wire cout_internal;
wire cin;
CLA_4bit adder0(.a(a[3:0]), .b(b_internal[3:0]), .cin(cin), .sum(sum[3:0]), .cout(cout_internal));
CLA_4bit adder1(.a(a[7:4]), .b(b_internal[7:4]), .cin(cout_internal), .sum(sum[7:4]), .cout(cout));

assign b_internal = mode ? ~b : b;
assign cin = mode ? 1 : 0;
assign ovfl = (a[7] == b_internal[7]) ? (a[7] == sum[7]) ? 0 : 1 : 0;
endmodule 