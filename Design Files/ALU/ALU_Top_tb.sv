module ALU_Top_tb;
	reg signed [15:0]a;
	reg signed [15:0]b;
	reg [2:0] ALUOp;
	wire [15:0]result;
	wire ovfl;
	wire zero;
	wire sign;

localparam [2:0] ADD    = 3'b000;
localparam [2:0] SUB    = 3'b001;
localparam [2:0] XOR    = 3'b010;
localparam [2:0] RED    = 3'b011;
localparam [2:0] SLL    = 3'b100;
localparam [2:0] SRA    = 3'b101;
localparam [2:0] ROR    = 3'b110;
localparam [2:0] PADDSB = 3'b111;

ALU_Top iDUT(.a(a), .b(b), .result(result), .ALUOp(ALUOp), .ovfl(ovfl), .zero(zero), .sign(sign));

initial begin
	a = 16'h7FFF;
	b = 16'h1000;
	ALUOp = ADD;
#10;
	
	a = 16'h0010;
	b = 16'h0004;
	ALUOp = SLL;
#10;

	a = 16'hff00;
	b = 16'h0008;
	ALUOp = SRA;
	
#10;
	
	a = 16'h80A0;
	b = 16'h0004;
	ALUOp = ROR;

#10;

	a = 16'h8000;
	b = 16'h0001;
	ALUOp = SUB;
#10;

	a = 16'h7459;
	b = 16'h0000;
	ALUOp = XOR;

#10;

	a = 16'hF716;
	b = 16'h977D;
	ALUOp = PADDSB;

#10;

	a = 16'h4567;
	b = 16'h9876;
	ALUOp = RED;

#10 $stop;
end

endmodule
