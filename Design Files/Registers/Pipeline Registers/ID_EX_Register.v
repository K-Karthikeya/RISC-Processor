module ID_EX_Register(
    input clk,
    input rst,
    input ID_EX_en, // Enable signal to IF_ID_Register
    input ID_EX_flush, // Incase Predict-not-taken policy fails, we flush the pipeline register

    input [3:0] ID_opcode, // Opcode from decoder. Needed for enabling flag register
    input [3:0] ID_rs_reg, // rs reg ID for data hazards
    input [3:0] ID_rt_reg, // rt reg ID for data hazards
    input [3:0] ID_rd_reg, // rd reg ID for data hazards
    input [15:0] ID_rs_reg_data, // rs reg Data for Execute stage
    input [15:0] ID_rt_reg_data, // rt reg Data for Execute stage
    input [15:0] ID_imm_signext, // Sign-extended immediate value
    input [7:0] ID_load_byte, // Byte to be loaded for LLB and LHB instruction
    input [15:0] ID_PC_nxt, // holds the PC+2 for PCS instruction
    // input [2:0] ID_branch_cnd,
    // input [15:0] ID_blabel_signext,
    // input ID_Branch,
    input ID_MemRead, // Control signal for LW instr
    input ID_PC_save, // Control signal that indicates when the current instruction is a PCS instruction
    input ID_Hlt, // Control signal that indicates Hlt instruction
    input ID_MemtoReg, // Write back from memory to register for LW instr
    input [2:0] ID_ALUOp, // ALU operation to be performed
    input ID_MemWrite, // Control signal for SW instr
    input ID_ALUSrc, // Control signal to select between rt_data and imm_signext
    input ID_DMEM_en, // Control signal to enable Data Mem for LW and SW instr
    input ID_LB_mode, // Control signal to select between LLB and LHB
    input ID_LB_result_sel, // Control signal to select LB_result in WB stage
    input ID_RegWrite, // Control signal to enable writing to the register file

    output [3:0] EX_opcode,
    output [3:0] EX_rs_reg,
    output [3:0] EX_rt_reg,
    output [3:0] EX_rd_reg,
    output [15:0] EX_rs_reg_data,
    output [15:0] EX_rt_reg_data,
    output [15:0] EX_imm_signext,
    output [7:0] EX_load_byte,
    output [15:0] EX_PC_nxt,
    // output [2:0] EX_branch_cnd,
    // output [15:0] EX_blabel_signext,
    // output EX_Branch,
    output EX_MemRead,
    output EX_PC_save,
    output EX_Hlt,
    output EX_MemtoReg,
    output [2:0] EX_ALUOp,
    output EX_MemWrite,
    output EX_ALUSrc,
    output EX_DMEM_en,
    output EX_LB_mode,
    output EX_LB_result_sel,
    output EX_RegWrite
);

pldff #(4)  iID_EX_opcode (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_opcode), .q(EX_opcode), .wen(ID_EX_en));
pldff #(4)  iID_EX_rs_reg (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_rs_reg), .q(EX_rs_reg), .wen(ID_EX_en));
pldff #(4)  iID_EX_rt_reg (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_rt_reg), .q(EX_rt_reg), .wen(ID_EX_en));
pldff #(4)  iID_EX_rd_reg (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_rd_reg), .q(EX_rd_reg), .wen(ID_EX_en));
pldff #(16) iID_EX_rs_reg_data  (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_rs_reg_data), .q(EX_rs_reg_data), .wen(ID_EX_en));
pldff #(16) iID_EX_rt_reg_data  (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_rt_reg_data), .q(EX_rt_reg_data), .wen(ID_EX_en));
pldff #(16) iID_EX_imm_signext  (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_imm_signext), .q(EX_imm_signext), .wen(ID_EX_en));
pldff #(8)  iID_EX_load_byte (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_load_byte), .q(EX_load_byte), .wen(ID_EX_en));
pldff #(16)  iID_EX_PC_nxt (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_PC_nxt), .q(EX_PC_nxt), .wen(ID_EX_en));
// pldff #(3)  iID_EX_branch_cnd (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_branch_cnd), .q(EX_branch_cnd), .wen(ID_EX_en));
// pldff #(16) iID_EX_blabel_signext  (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_blabel_signext), .q(EX_blabel_signext), .wen(ID_EX_en));
// dff iID_EX_Branch (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_Branch), .q(EX_Branch), .wen(ID_EX_en));
dff iID_EX_MemRead (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_MemRead), .q(EX_MemRead), .wen(ID_EX_en));
dff iID_EX_MemtoReg (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_MemtoReg), .q(EX_MemtoReg), .wen(ID_EX_en));
dff iID_EX_PC_save (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_PC_save), .q(EX_PC_save), .wen(ID_EX_en));
dff iID_EX_Hlt (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_Hlt), .q(EX_Hlt), .wen(ID_EX_en));
pldff #(3) iID_EX_ALUOp (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_ALUOp), .q(EX_ALUOp), .wen(ID_EX_en));
dff iID_EX_MemWrite (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_MemWrite), .q(EX_MemWrite), .wen(ID_EX_en));
dff iID_EX_ALUSrc (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_ALUSrc), .q(EX_ALUSrc), .wen(ID_EX_en));
dff iID_EX_DMEM_en (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_DMEM_en), .q(EX_DMEM_en), .wen(ID_EX_en));
dff iID_EX_LB_mode (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_LB_mode), .q(EX_LB_mode), .wen(ID_EX_en));
dff iID_EX_LB_result_sel (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_LB_result_sel), .q(EX_LB_result_sel), .wen(ID_EX_en));
dff iID_EX_RegWrite (.clk(clk), .rst(rst | ID_EX_flush), .d(ID_RegWrite), .q(EX_RegWrite), .wen(ID_EX_en));
endmodule