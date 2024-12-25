
module pc_control(input branch,
									input [2:0] cnd, 
									input [15:0] imm,
									input [2:0] f, // f[2] = N; f[1] = O; f[0] = Z
									input BR_label_sel,
									input [15:0] nxt_addr,
									input [15:0] pc_in,
									output [15:0] pc_out);

localparam [2:0] BNE = 3'h0,
								 BE = 3'h1,
								 BGT = 3'h2,
								 BLT = 3'h3,
								 BGE = 3'h4,
								 BLE = 3'h5,
								 BO = 3'h6,
								 UCD = 3'h7;

wire [15:0] default_nxt_pc;
wire [15:0] branch_nxt_pc;
wire [15:0] signext_immediate;
reg branch_cntrl;

always@(*) begin
	case(cnd) 
		BNE: 	branch_cntrl = (!f[0]) ? 1 : 0;
		BE:		branch_cntrl = (f[0]) ? 1 : 0;
		BGT:	branch_cntrl = (!f[0] && !f[2]) ? 1 : 0;
		BLT:	branch_cntrl = (f[2]) ? 1 : 0;
		BGE:	branch_cntrl = (f[0] || (!f[0] && !f[2])) ? 1 : 0;
		BLE:	branch_cntrl = (f[0] || f[2]) ? 1 : 0;
		BO:		branch_cntrl = (f[1]) ? 1 : 0;
		UCD:	branch_cntrl = 1;
	endcase
end

CLA_16bit default_pc(.a(pc_in), .b(16'h0002), .mode(1'b0), .sum(default_nxt_pc));
CLA_16bit branch_pc(.a(default_nxt_pc), .b(imm << 1), .mode(1'b0), .sum(branch_nxt_pc));

assign pc_out = (branch & branch_cntrl) ? BR_label_sel ? nxt_addr : branch_nxt_pc : default_nxt_pc;
endmodule