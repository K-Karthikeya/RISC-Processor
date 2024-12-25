module opcode_decoder(
	input [15:0] instr,
	output [3:0] opcode,
	output [3:0] rd,
	output [3:0] rs,
	output [3:0] rt,
	output [3:0] imm,
	output [7:0] load_byte,
	output [3:0] cnd,
	output [9:0] label
);

localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam XOR = 4'b0010;
localparam RED = 4'b0011;
localparam SLL = 4'b0100;
localparam SRA = 4'b0101;
localparam ROR = 4'b0110;
localparam PADDSB = 4'b0111;
localparam LW = 4'b1000;
localparam SW = 4'b1001;
localparam LLB = 4'b1010;
localparam LHB = 4'b1011;
localparam B = 4'b1100;
localparam BR = 4'b1101;
localparam PCS = 4'b1110;
localparam HLT = 4'b1111;

assign opcode = instr[15:12];
assign rd = instr[11:8];
assign rs = instr[7:4];
assign rt = instr[3:0];
assign load_byte = instr[7:0];
assign imm = instr[3:0];
assign cnd = instr[11:9];
assign label = instr[8:0];


endmodule
