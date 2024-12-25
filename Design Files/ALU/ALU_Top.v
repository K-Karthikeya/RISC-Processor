module ALU_Top(
	input [15:0]a,
	input [15:0]b,
	input [2:0] ALUOp,
	output [15:0]result,
	output ovfl,
	output zero,
	output sign
);

wire [1:0] mode;

ALU_Control iControl(.ALUOp(ALUOp), .mode(mode));
ALU_Main iMain(.a(a), .b(b), .result(result), .ALUOp(ALUOp), .mode(mode), .ovfl(ovfl), .sign(sign), .zero(zero));

endmodule
