module branch_hazard_detection (
    input ID_Branch,
    input [2:0] ID_branch_cnd,
    input [3:0] EX_opcode,
    input [3:0] MEM_opcode,
    input [3:0] WB_opcode,
    output reg stall,
    output FLAG_bypass_ovfl,
    output FLAG_bypass_zero,
    output FLAG_bypass_sign
);

reg zero_flag_stall_cntrl;
reg ovfl_flag_stall_cntrl;
reg sign_flag_stall_cntrl;

wire EX_sets_zero_flag;
wire MEM_sets_zero_flag;
wire WB_sets_zero_flag;

wire EX_sets_ovfl_flag;
wire MEM_sets_ovfl_flag;
wire WB_sets_ovfl_flag;

wire EX_sets_sign_flag;
wire MEM_sets_sign_flag;
wire WB_sets_sign_flag;

localparam [3:0] ADD = 4'b0000,
                SUB = 4'b0001,
                XOR = 4'b0010,
                RED = 4'b0011,
                SLL = 4'b0100,
                SRA = 4'b0101,
                ROR = 4'b0110,
                PADDSB = 4'b0111,
                LW = 4'b1000,
                SW = 4'b1001,
                LLB = 4'b1010,
                LHB = 4'b1011,
                B = 4'b1100,
                BR = 4'b1101,
                PCS = 4'b1110,
                HLT = 4'b1111;

localparam [2:0] BNE = 3'h0,
                BE = 3'h1,
                BGT = 3'h2,
                BLT = 3'h3,
                BGE = 3'h4,
                BLE = 3'h5,
                BO = 3'h6,
                UCD = 3'h7;

always@(*) begin
    case (ID_branch_cnd)
        BNE, BE: stall = zero_flag_stall_cntrl;
        BGT, BGE, BLE: stall = zero_flag_stall_cntrl | sign_flag_stall_cntrl;
        BLT: stall = sign_flag_stall_cntrl;
        BO: stall = ovfl_flag_stall_cntrl;
        UCD: stall = 1'b0;
    endcase
end

assign zero_flag_stall_cntrl = ID_Branch ? 
                               (EX_sets_zero_flag | MEM_sets_zero_flag) ? 1'b1 :
                               1'b0 : 1'b0;
assign ovfl_flag_stall_cntrl = ID_Branch ? 
                               (EX_sets_ovfl_flag | MEM_sets_ovfl_flag) ? 1'b1 :
                               1'b0 : 1'b0;
assign sign_flag_stall_cntrl = ID_Branch ? 
                               (EX_sets_sign_flag | MEM_sets_sign_flag) ? 1'b1 :
                               1'b0 : 1'b0;

assign EX_sets_ovfl_flag = (EX_opcode == ADD) | (EX_opcode == SUB);
assign EX_sets_sign_flag = (EX_opcode == ADD) | (EX_opcode == SUB);
assign EX_sets_zero_flag = (~EX_opcode[3] & ~EX_opcode[1]) | (~EX_opcode[3] & ~EX_opcode[0]); // Logically equivalent to EX_opcode == ADD | SUB | XOR | SLA | SRA | ROR

assign MEM_sets_ovfl_flag = (MEM_opcode == ADD) | (MEM_opcode == SUB);
assign MEM_sets_sign_flag = (MEM_opcode == ADD) | (MEM_opcode == SUB);
assign MEM_sets_zero_flag = (~MEM_opcode[3] & ~MEM_opcode[1]) | (~MEM_opcode[3] & ~MEM_opcode[0]); // Logically equivalent to MEM_opcode == ADD | SUB | XOR | SLA | SRA | ROR

assign WB_sets_ovfl_flag = (WB_opcode == ADD) | (WB_opcode == SUB);
assign WB_sets_sign_flag = (WB_opcode == ADD) | (WB_opcode == SUB);
assign WB_sets_zero_flag = (~WB_opcode[3] & ~WB_opcode[1]) | (~WB_opcode[3] & ~WB_opcode[0]); // Logically equivalent to EX_opcode == ADD | SUB | XOR | SLA | SRA | ROR
    
assign FLAG_bypass_ovfl = (ID_Branch & !stall & (ID_branch_cnd == BO)) & WB_sets_ovfl_flag;
assign FLAG_bypass_sign = (ID_Branch & !stall & (ID_branch_cnd[2] ^ ID_branch_cnd[1]) ) & WB_sets_sign_flag;
assign FLAG_bypass_zero = (ID_Branch & !stall & (~ID_branch_cnd[1] | (~ID_branch_cnd[2] & ~ID_branch_cnd[0])) ) & WB_sets_zero_flag;

endmodule
