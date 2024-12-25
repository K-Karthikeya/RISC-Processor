
module ALU_Control(
	input [2:0] ALUOp,
	output reg [1:0] mode
);

localparam [2:0] ADD    = 3'b000;
localparam [2:0] SUB    = 3'b001;
localparam [2:0] XOR    = 3'b010;
localparam [2:0] RED    = 3'b011;
localparam [2:0] SLL    = 3'b100;
localparam [2:0] SRA    = 3'b101;
localparam [2:0] ROR    = 3'b110;
localparam [2:0] PADDSB = 3'b111;

always@(*) begin
	case(ALUOp)
		SLL: mode = 2'b00;
		SRA: mode = 2'b01;
		ROR: mode = 2'b10;
		default: mode = 2'bzz;
	endcase
end
	
endmodule