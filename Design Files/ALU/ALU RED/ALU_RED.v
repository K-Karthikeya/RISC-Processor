
module ALU_RED(
	input [15:0] a,       // First operand
	input [15:0] b,       // Second operand
	output [15:0] result, // Result of the reduction
	output ovfl,      // Overflow flag (V)
	output zero,      // Zero flag (Z)
	output sign       // Sign flag (N)
);

	wire [8:0] sum_ac;
	wire [8:0] sum_bd;
	wire [9:0] sum_ac_bd;
	wire ovfl_ac;
	wire ovfl_bd;
	wire ovfl_ac_bd;

CLA_8bit add_ac(
	.a(a[7:0]),
	.b(b[7:0]),
	.mode(1'b0),
	.sum(sum_ac[7:0]),
	.cout(sum_ac[8]),
	.ovfl(ovfl_ac)
);

CLA_8bit add_bd(
	.a(a[15:8]),
	.b(b[15:8]),
	.mode(1'b0),
	.sum(sum_bd[7:0]),
	.cout(sum_bd[8]),
	.ovfl(ovfl_bd)
);

CLA_9bit add_ac_bd(
	.a(sum_ac),
	.b(sum_bd),
	.mode(1'b0),
	.sum(sum_ac_bd),
	.ovfl(ovfl_ac_bd)
);

assign result = {{6{sum_ac_bd[9]}}, sum_ac_bd};

assign ovfl = 1'bz;
assign sign = 1'bz;
assign zero = 1'bz;

endmodule