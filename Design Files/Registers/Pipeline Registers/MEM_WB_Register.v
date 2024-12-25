module MEM_WB_Register(
    input clk,
    input rst,
    input MEM_WB_en, // Enable signal to IF_ID_Register
    input MEM_WB_flush, // Incase Predict-not-taken policy fails, we flush the pipeline register

    input [3:0] MEM_opcode, // Opcode required for writing back to flag registers in WB stage
    input [3:0] MEM_rs_reg, // rs reg ID to handle data hazards
    input [3:0] MEM_rt_reg, // rt reg ID to handle data hazards
    input [3:0] MEM_rd_reg, // rd reg ID to handle data hazards
    // input [2:0] MEM_branch_cnd,
    // input [15:0] MEM_blabel_signext,
    input [15:0] MEM_ALU_result, // ALU result
    input [15:0] MEM_LB_result, //  LB result
    input [15:0] MEM_Fresult,
    input [15:0] MEM_data_mem_out, // Output of data memory incase of LW and SW instr
    input [15:0] MEM_PC_nxt,
    input MEM_ovfl, // Ovfl flag from ALU
    input MEM_sign, // Sign flag from ALU
    input MEM_zero, // Zero flag from ALU
    // input MEM_Branch,
    input MEM_PC_save,
    input MEM_Hlt,
    input MEM_MemtoReg, // Control signal to write data_mem_out to register file for LW instr
    input MEM_MemRead,
    input MEM_LB_result_sel, // selects between ALU result and LB result
    input MEM_RegWrite, // Control signal to enable writing to the register file 

    output [3:0] WB_opcode,
    output [3:0] WB_rs_reg,
    output [3:0] WB_rt_reg,
    output [3:0] WB_rd_reg,
    // output [2:0] WB_branch_cnd,
    // output [15:0] WB_blabel_signext,
    output [15:0] WB_ALU_result,
    output [15:0] WB_LB_result,
    output [15:0] WB_Fresult,
    output [15:0] WB_data_mem_out,
    output [15:0] WB_PC_nxt,
    output WB_ovfl,
    output WB_zero,
    output WB_sign,
    // output WB_Branch,
    output WB_PC_save,
    output WB_Hlt,
    output WB_MemtoReg,
    output WB_MemRead,
    output WB_LB_result_sel,
    output WB_RegWrite
);

pldff #(4)  iMEM_WB_opcode (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_opcode), .q(WB_opcode), .wen(MEM_WB_en));
pldff #(4)  iMEM_WB_rs_reg (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_rs_reg), .q(WB_rs_reg), .wen(MEM_WB_en));
pldff #(4)  iMEM_WB_rt_reg (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_rt_reg), .q(WB_rt_reg), .wen(MEM_WB_en));
pldff #(4)  iMEM_WB_rd_reg (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_rd_reg), .q(WB_rd_reg), .wen(MEM_WB_en));
// pldff #(3)  iMEM_WB_branch_cnd (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_branch_cnd), .q(WB_branch_cnd), .wen(MEM_WB_en));
// pldff #(16) iMEM_WB_blabel_signext  (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_blabel_signext), .q(WB_blabel_signext), .wen(MEM_WB_en));
pldff #(16)  iMEM_WB_ALU_result (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_ALU_result), .q(WB_ALU_result), .wen(MEM_WB_en));
pldff #(16)  iMEM_WB_LB_result (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_LB_result), .q(WB_LB_result), .wen(MEM_WB_en));
pldff #(16)  iMEM_WB_Fresult (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_Fresult), .q(WB_Fresult), .wen(MEM_WB_en));
pldff #(16)  iMEM_WB_data_mem_out (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_data_mem_out), .q(WB_data_mem_out), .wen(MEM_WB_en));
pldff #(16)  iMEM_WB_PC_nxt (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_PC_nxt), .q(WB_PC_nxt), .wen(MEM_WB_en));
dff iMEM_WB_ovfl (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_ovfl), .q(WB_ovfl), .wen(MEM_WB_en));
dff iMEM_WB_sign (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_sign), .q(WB_sign), .wen(MEM_WB_en));
dff iMEM_WB_zero (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_zero), .q(WB_zero), .wen(MEM_WB_en));
dff iMEM_WB_MemRead (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_MemRead), .q(WB_MemRead), .wen(MEM_WB_en));
// dff iMEM_WB_Branch (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_Branch), .q(WB_Branch), .wen(MEM_WB_en));
dff iMEM_WB_PC_save (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_PC_save), .q(WB_PC_save), .wen(MEM_WB_en));
dff iMEM_WB_Hlt (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_Hlt), .q(WB_Hlt), .wen(MEM_WB_en));
dff iMEM_WB_MemtoReg (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_MemtoReg), .q(WB_MemtoReg), .wen(MEM_WB_en));
dff iMEM_WB_LB_result_sel (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_LB_result_sel), .q(WB_LB_result_sel), .wen(MEM_WB_en));
dff iMEM_WB_RegWrite (.clk(clk), .rst(rst | MEM_WB_flush), .d(MEM_RegWrite), .q(WB_RegWrite), .wen(MEM_WB_en));
endmodule