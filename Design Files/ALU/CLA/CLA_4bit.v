 module CLA_4bit(
	input [3:0]a,
	input [3:0]b,
	input cin,
	output [3:0]sum,
	output cout
);
	wire [3:0]p;
	wire [3:0]g;
	wire [2:0]c;

	CLA_1bit Add0(.a(a[0]), .b(b[0]), .cin(cin), .p(p[0]), .g(g[0]), .sum(sum[0]));
	CLA_1bit Add1(.a(a[1]), .b(b[1]), .cin(c[0]), .p(p[1]), .g(g[1]), .sum(sum[1]));
	CLA_1bit Add2(.a(a[2]), .b(b[2]), .cin(c[1]), .p(p[2]), .g(g[2]), .sum(sum[2]));
	CLA_1bit Add3(.a(a[3]), .b(b[3]), .cin(c[2]), .p(p[3]), .g(g[3]), .sum(sum[3]));

	assign c[0] = g[0] | (p[0] & cin);
	assign c[1] = g[1] | (p[1] & c[0]);
	assign c[2] = g[2] | (p[2] & c[1]);
	assign cout = g[3] | (p[3] & c[2]);

endmodule 