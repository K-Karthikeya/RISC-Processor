module ALU_Main(
	input [15:0] a,
	input [15:0] b,
	input [2:0] ALUOp,
	input [1:0] mode,
	output reg [15:0] result,
	output reg ovfl,
	output reg zero, 
	output reg sign
);

localparam [2:0] ADD    = 3'b000;
localparam [2:0] SUB    = 3'b001;
localparam [2:0] XOR    = 3'b010;
localparam [2:0] RED    = 3'b011;
localparam [2:0] SLL    = 3'b100;
localparam [2:0] SRA    = 3'b101;
localparam [2:0] ROR    = 3'b110;
localparam [2:0] PADDSB = 3'b111;

	wire [15:0]result_internal[5:0];
	wire ovfl_internal[5:0];
	wire zero_internal[5:0];
	wire sign_internal[5:0];

	ALU_ADD iADD(.a(a), .b(b), .result(result_internal[0]), .ovfl(ovfl_internal[0]), .zero(zero_internal[0]), .sign(sign_internal[0]));
	ALU_SUB iSUB(.a(a), .b(b), .result(result_internal[1]), .ovfl(ovfl_internal[1]), .zero(zero_internal[1]), .sign(sign_internal[1]));
	ALU_XOR iXOR(.a(a), .b(b), .result(result_internal[2]), .ovfl(ovfl_internal[2]), .zero(zero_internal[2]), .sign(sign_internal[2]));
	ALU_PADDSB iPADDSB(.a(a), .b(b), .result(result_internal[3]), .ovfl(ovfl_internal[3]), .zero(zero_internal[3]), .sign(sign_internal[3]));
	ALU_RED iRED(.a(a), .b(b), .result(result_internal[4]), .ovfl(ovfl_internal[4]), .zero(zero_internal[4]), .sign(sign_internal[4]));
	ALU_Shifter iSHIFTER(.a(a), .b(b[3:0]), .result(result_internal[5]), .mode(mode), .ovfl(ovfl_internal[5]), .zero(zero_internal[5]), .sign(sign_internal[5]));

	always@(*) begin
		case(ALUOp)
			ADD: begin
				result = result_internal[0];
				ovfl = ovfl_internal[0];
				zero = zero_internal[0];
				sign = sign_internal[0];
			end
			SUB: begin
				result = result_internal[1];
				ovfl = ovfl_internal[1];
				sign = sign_internal[1];
				zero = zero_internal[1];
			end
			XOR: begin
				result = result_internal[2];
				zero = zero_internal[2];
			end
			PADDSB: result = result_internal[3];
			RED: result = result_internal[4];
			SLL, SRA, ROR: begin
				result = result_internal[5];
				zero = zero_internal[5];
			end
		endcase
	end
endmodule
