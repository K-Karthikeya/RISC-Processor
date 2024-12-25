
module cpu(
	input clk,
	input rst,
	output hlt,
	output [15:0]pc
);

//////////////////////////////////////////////////////////////////////////////////////////////
// IF stage wires ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire IF_ID_data_stall;
wire IF_ID_branch_stall;
wire IF_ID_stall;
wire IF_ID_flush;
wire [15:0] IF_instr; // Current instruction fetched form I-Memory
wire [15:0] IF_PC_nxt; // Holds PC + 2. (Default next PC)

//////////////////////////////////////////////////////////////////////////////////////////////
//ID stage wires /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire ID_EX_en;
wire ID_EX_flush;

wire [15:0] ID_instr; // Holds current instruction in execution
wire [15:0] ID_PC_nxt; // Holds PC+2 value
wire [3:0] ID_opcode; // Opcode from decoder. Needed for enabling flag register
wire [3:0] ID_rs; // rs from Instruction Decoder
wire [3:0] ID_rt; // rt from Instruction Decoder
wire [3:0] ID_rd; // rd from Instruction Decoder
wire [3:0] ID_imm; // imm from Instruction Decoder
wire [8:0] ID_blabel; // branch label from Instruction Decoder
wire [3:0] ID_rs_reg; // rs reg ID for data hazards
wire [3:0] ID_rt_reg; // rt reg ID for data hazards
wire [3:0] ID_rd_reg; // rd reg ID for data hazards
wire [15:0] ID_rs_reg_data; // rs reg Data for Execute stage
wire [15:0] ID_rt_reg_data; // rt reg Data for Execute stage
wire [15:0] ID_imm_signext; // Sign-extended immediate value
wire [7:0] ID_load_byte; // Byte to be loaded for LLB and LHB instruction
wire [2:0] ID_branch_cnd; // Condition for branch
wire [15:0] ID_blabel_signext;
wire ID_Branch;
wire ID_RegSel_rs;
wire ID_RegSel_rt;
wire ID_MemRead; // Control signal for LW instr
wire ID_PC_save;
wire ID_Hlt;
wire ID_MemtoReg; // Write back from memory to register for LW instr
wire [2:0] ID_ALUOp; // ALU operation to be performed
wire ID_MemWrite; // Control signal for SW instr
wire ID_ALUSrc; // Control signal to select between rt_data and imm_signext
wire ID_DMEM_en; // Control signal to enable Data Mem for LW and SW instr
wire ID_LB_mode; // Control signal to select between LLB and LHB
wire ID_LB_result_sel; // Control signal to select LB_result in WB stage
wire ID_RegWrite; // Control signal to enable writing to the register file

//////////////////////////////////////////////////////////////////////////////////////////////
//EX stage wires /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire EX_MEM_en; // Enable signal to IF_ID_Register
wire EX_MEM_flush; // Incase Predict-not-taken policy fails; we flush the pipeline register

wire [3:0] EX_opcode; // Opcode required for writing back to flag registers in WB stage
wire [3:0] EX_rs_reg; // rs reg ID for data hazards
wire [3:0] EX_rt_reg; // rt reg ID for data hazards
wire [3:0] EX_rd_reg; // rd reg ID for data hazards
wire [15:0] EX_rs_reg_data; // rs reg data
wire [15:0] EX_rt_reg_data; // rt reg data to be stored incase of SW operation
wire [15:0] EX_imm_signext; // Holds the sign-extended immediate value for Shift instrs
wire [7:0] EX_load_byte; // Value to be loaded for LLB and LHB instrs
// wire [2:0] EX_branch_cnd;
// wire [15:0] EX_blabel_signext;
wire [15:0] EX_ALU_result; // Output of ALU block
wire [15:0] EX_LB_result; // Output of LB block
wire [15:0] EX_Fresult;
wire [15:0] EX_PC_nxt;
wire [15:0] EX_operand1; // This operand is for both ALU and LB
wire [15:0] EX_operand2; // This operand is selected based on the source - Immediate or register

wire EX_ovfl; // Ovfl flag from ALU
wire EX_zero; // Zero flag from ALU
wire EX_sign; // Sign Flag from ALU
// wire EX_Branch;
wire EX_MemRead; // Control signal to read from data mem for LW instr
wire EX_PC_save;
wire EX_Hlt;
wire [1:0] EX_rs_data_sel; // Selects the forwarded unit for the ALU inputs
wire [1:0] EX_rt_data_sel; // Selects the forwarded unit for the ALU inputs
wire [2:0] EX_ALUOp; // Operation to be performed by the CPU
wire EX_ALUSrc; // Selects between Imm and rt register data
wire EX_LB_mode; // Selects between LLB and LHB instruction
wire EX_MemWrite; // Control signal for SW instr to write into data memory
wire EX_DMEM_en; // Control signal to enable data memory block for SW and LW instr
wire EX_MemtoReg; // Control signal for LW instr to store data into register
wire EX_LB_result_sel; // Selects between ALU and LB result in WB stage
wire EX_RegWrite; // Control signal to enable writing to the register file
wire [15:0] EX_rt_reg_data_temp;

//////////////////////////////////////////////////////////////////////////////////////////////
//MEM stage wires ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire MEM_WB_en; // Enable signal to IF_ID_Register
wire MEM_WB_flush; // Incase Predict-not-taken policy fails; we flush the pipeline register

wire [3:0] MEM_opcode; // Opcode required for writing back to flag registers in WB stage
wire [3:0] MEM_rs_reg; // rs reg ID to handle data hazards
wire [3:0] MEM_rt_reg; // rt reg ID to handle data hazards
wire [3:0] MEM_rd_reg; // rd reg ID to handle data hazards
wire [15:0] MEM_rt_reg_data;
wire [15:0] MEM_mem_data_in;
// wire [2:0] MEM_branch_cnd;
// wire [15:0] MEM_blabel_signext;
wire [15:0] MEM_ALU_result; // ALU result
wire [15:0] MEM_LB_result; //  LB result
wire [15:0] MEM_Fresult;
wire [15:0] MEM_data_mem_out; // Output of data memory incase of LW and SW instr
wire [15:0] MEM_PC_nxt;
wire MEM_ovfl; // Ovfl flag from ALU
wire MEM_sign; // Sign flag from ALU
wire MEM_zero; // Zero flag from ALU
// wire MEM_Branch;
wire MEM_data_in_sel; // Selects forwarded data for Data memory block when MEM-MEM forwarding
wire MEM_MemRead;
wire MEM_PC_save;
wire MEM_Hlt;
wire MEM_MemWrite;
wire MEM_DMEM_en;
wire MEM_MemtoReg; // Control signal to write data_mem_out to register file for LW instr
wire MEM_LB_result_sel; // selects between ALU result and LB result
wire MEM_RegWrite; // Control signal to enable writing to the register file 

//////////////////////////////////////////////////////////////////////////////////////////////
//WB stage wires /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

wire [3:0] WB_opcode;
wire [3:0] WB_rs_reg;
wire [3:0] WB_rt_reg;
wire [3:0] WB_rd_reg;
// wire [2:0] WB_branch_cnd;
// wire [15:0] WB_blabel_signext;
wire [15:0] WB_ALU_result;
wire [15:0] WB_LB_result;
wire [15:0] WB_Fresult;
wire [15:0] WB_data_mem_out;
wire [15:0] WB_PC_nxt;
// wire [15:0] WB_Fresult;
wire [15:0] WB_result;
wire WB_ovfl;
wire WB_zero;
wire WB_sign;
// wire WB_Branch;
wire WB_PC_save;
wire WB_Hlt;
wire WB_MemtoReg;
wire WB_MemRead;
wire WB_LB_result_sel;
wire WB_RegWrite;

//////////////////////////////////////////////////////////////////////////////////////////////
//Global Wires ///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire RF_bypass_en1;
wire RF_bypass_en2;
wire FLAG_bypass_zero;
wire FLAG_bypass_ovfl;
wire FLAG_bypass_sign;
wire branch_taken;
wire forwarding;
wire instr_miss_stall;
wire data_miss_stall;

//////////////////////////////////////////////////////////////////////////////////////////////
//Flag Registers /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire ovfl, zero, sign;
// wire WB_ovfl_i, WB_zero_i, WB_sign_i; // Only updated at the end of WB stage
// // Overflow Flag
// dff OVFL(.q(ovfl), .d(WB_ovfl), .clk(clk), .rst(rst), .wen( (!WB_opcode[3]) & (!(&WB_opcode[1:0])) ) ); 
// // Zero Flag
// dff ZERO(.q(zero), .d(WB_zero), .clk(clk), .rst(rst), .wen( (!WB_opcode[3]) & (!(&WB_opcode[1:0])) ) );
// // Negative Flag
// dff SIGN(.q(sign), .d(WB_sign), .clk(clk), .rst(rst), .wen( (!WB_opcode[3]) & (!(&WB_opcode[1:0])) ) );

flag_registers iFLG_REG(.clk(clk), .rst(rst), .ovfl_i(WB_ovfl), .zero_i(WB_zero), .sign_i(WB_sign),
						.flag_en((!WB_opcode[3]) & (!(&WB_opcode[1:0]))), .FLAG_bypass_ovfl(FLAG_bypass_ovfl),
						.FLAG_bypass_zero(FLAG_bypass_zero), .FLAG_bypass_sign(FLAG_bypass_sign), 
						.ovfl(ovfl), .zero(zero), .sign(sign));

//////////////////////////////////////////////////////////////////////////////////////////////
//Branch Hazard Unit /////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

branch_hazard_detection iBRNCH_HZD_DETECT(.ID_Branch(ID_Branch),
    .ID_branch_cnd(ID_branch_cnd),
    .EX_opcode(EX_opcode),
    .MEM_opcode(MEM_opcode),
    .WB_opcode(WB_opcode),
    .stall(IF_ID_branch_stall),
    .FLAG_bypass_ovfl(FLAG_bypass_ovfl),
    .FLAG_bypass_zero(FLAG_bypass_zero),
    .FLAG_bypass_sign(FLAG_bypass_sign));

//////////////////////////////////////////////////////////////////////////////////////////////
//Program Counter ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
wire [15:0] PC;
wire [15:0] next_PC; // To temporarily hold the next_pc value
dff PC_reg[15:0] (.q(PC), .d(next_PC), .clk(clk), .rst(rst), .wen(!ID_Hlt & !EX_Hlt & !MEM_Hlt & !WB_Hlt & !IF_ID_stall & !data_miss_stall & !instr_miss_stall));
assign pc = PC; // Displaying the PC register to Output port PC

 // Updating the PC to PC + 2
CLA_16bit default_pc(.a(PC), .b(16'h0002), .mode(1'b0), .sum(IF_PC_nxt));


//////////////////////////////////////////////////////////////////////////////////////////////
//Hazard Detection Unit //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

hazard_detect iDATA_HZD_DETECT(.id_ex_rd(EX_rd_reg),
	// .ex_mem_rd(MEM_rd_reg),
    .id_ex_MemRead(EX_MemRead),
	.new_ex_mem_rd(MEM_rd_reg),
    .if_id_rs(ID_rs_reg),
    .if_id_rt(ID_rt_reg),
    .mem_wb_RegWrite(WB_RegWrite),
    .mem_wb_rd(WB_rd_reg),
    .curr_opcode(ID_opcode),
	.if_id_branch(ID_Branch),
	.if_id_MemWrite(ID_MemWrite),
    .stall(IF_ID_data_stall),
    .bypass_rs(RF_bypass_en1),
    .bypass_rt(RF_bypass_en2));

//////////////////////////////////////////////////////////////////////////////////////////////
//Data Forwarding Unit ///////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

forward_unit iFRWRD_UNIT(.ex_mem_rd(MEM_rd_reg),
    .mem_wb_rd(WB_rd_reg),
    .id_ex_rs(EX_rs_reg),
    .id_ex_rt(EX_rt_reg),
	.ex_mem_rt(MEM_rt_reg),
    .mem_wb_MemRead(WB_MemRead),
    .ex_mem_RegWrite(MEM_RegWrite),
    .mem_wb_RegWrite(WB_RegWrite),
    .ex_mem_MemWrite(MEM_MemWrite),
    .forwardA(EX_rs_data_sel),
    .forwardB(EX_rt_data_sel),
    .mem_to_mem(MEM_data_in_sel));

// assign forwarding = |({EX_rs_data_sel,EX_rt_data_sel,MEM_data_in_sel});
//////////////////////////////////////////////////////////////////////////////////////////////
//Instruction Memory Block ///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
// output [DWIDTH-1:0] data_out, - Present Instruction
// input [DWIDTH-1:0] data_in, - Not used for instruction memory
// input [AWIDTH-1:0] addr,  // byte address, all accesses must be 2-byte aligned; [0] is ignored. - PC Value is the input
// input enable, - Enable = 1 to access memory
// input wr, - write enable, not used for instruction memory
// input clk, - clock signal
// input rst - reset signal
// memory1c_instr iINSTMEM(.data_out(IF_instr), .data_in(16'hzzzz), .addr(PC), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));

//////////////////////////////////////////////////////////////////////////////////////////////
//Unified Memory /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

unified_memory iUNIFIEDMEM(.clk(clk), .rst(rst), .instr_addr(PC), .instr(IF_instr), .instr_miss_stall(instr_miss_stall),
						   .data_in(MEM_mem_data_in), .address_in(MEM_Fresult), .data_cache_enable(MEM_DMEM_en),
						   .data_cache_wen(MEM_MemWrite), .data_out(MEM_data_mem_out), .data_miss_stall(data_miss_stall));

//////////////////////////////////////////////////////////////////////////////////////////////
//IF/ID Pipeline Register ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

assign IF_ID_stall = (IF_ID_branch_stall | IF_ID_data_stall); // & !forwarding; 

IF_ID_Register iIF_ID_REG(.clk(clk), .rst(rst), .IF_ID_en(!IF_ID_stall & !data_miss_stall), .IF_ID_flush(branch_taken),
						  .IF_instr(instr_miss_stall ? 16'hE000 : IF_instr), .IF_PC_nxt(IF_PC_nxt), .ID_instr(ID_instr), .ID_PC_nxt(ID_PC_nxt));

//////////////////////////////////////////////////////////////////////////////////////////////
//Opcode Decoder /////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//	input [15:0] instr, - incoming instruction from instruction memory
//	output [3:0] opcode, - opcode of current instruction
//	output [3:0] rd, - rd reg ID
//	output [3:0] rs, - rs reg ID
//	output [3:0] rt, - rt reg ID
//	output [3:0] imm, - immediate value for shift operations
//	output [7:0] load_byte, - Value to be loaded for LLB and LHB instructions
//	output [3:0] cnd, - condition for BR and B instructions
//	output [9:0] label - instruction label incase of branch instruction

opcode_decoder iOPDEC(.instr(ID_instr), .opcode(ID_opcode), .rd(ID_rd), .rs(ID_rs), .rt(ID_rt), .imm(ID_imm),
					  .load_byte(ID_load_byte), .cnd(ID_branch_cnd), .label(ID_blabel));

//////////////////////////////////////////////////////////////////////////////////////////////
//PC Control /////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
// ******************** NED TO WORK ON BRANCHES ********************************************///
///////////////////////////////////////////////////////////////////////////////////////////////

//input branch; - control signal provided by the control unit; if the instruction is a branch instruction
//input [2:0] cnd, - condition for branching, provided by the opcode decoder
//input [8:0] i, - immediate value, where to branch
//input [2:0] f, // f[2] = N; f[1] = O; f[0] = Z - Flag register
//input [15:0] pc_in, - current PC value
//output [15:0] pc_out - next PC value
//input [15:0] nxt_addr, - incase it is a BR instruction, then address is stored in rs_reg

// Sign-extending the label incase of B instruction
assign ID_blabel_signext = {{7{ID_blabel[8]}}, ID_blabel[8:0]};

pc_control iPC_CNTRL(.branch(ID_Branch), .cnd(ID_branch_cnd), .imm(ID_blabel_signext), .f({sign, ovfl, zero}), .stall(IF_ID_branch_stall), 
					 .bLabel_sel(ID_bLabel_sel), .nxt_addr(ID_rs_reg_data), .pc_in(IF_PC_nxt), .pc_out(next_PC), .branch_taken(branch_taken));

//////////////////////////////////////////////////////////////////////////////////////////////
//Control Signals Block //////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

//input [3:0] opcode; - Opcode given as input to control unit
//output RegSel_rt; - Selects between rd or rt. Selects Rd register for SW instruction because the contents of rd has to be stored in memory
//output Branch; - High if branch instruction (B or BR)
//output MemRead; - High if LW instruction (Currently not being used)
//output MemtoReg; - Selects between the output of ALU and Data_Mem
//output [2:0] ALUOp; - selects which ALUOp to perform
//output MemWrite; - High if SW instruction
//output ALUSrc; - selects between register value or immediate value for 2nd ALU operand
//output PC_save; - Incase of PCS instr, if high, the value of PC is loaded into Rd
//output Hlt; - Halt instruction
//output IMEM_en; - Enables I_MEM. When disabled any incoming instruction will be no-op
//output DMEM_en; - Enables D_MEM.
//output LB_mode; - high when we have to load higher byte, else lower byte
//output LB_result_sel; - selects the output of LB block incase of LLB or LHB instr
//output bLabel_sel; - Selects whether to branch to a label or register value. 1 - BR, 0 - B
//output RegWrite; - enables writing to register
//output RegSel_rs; - Selects between rs and rd register. Selects rd for LLB and LHB instructions because we have to load the value into rd and store it back
ControlSignal iCU(.opcode(ID_opcode), .RegSel_rt(ID_RegSel_rt), .RegSel_rs(ID_RegSel_rs), .Branch(ID_Branch), .MemtoReg(ID_MemtoReg),
				  .ALUOp(ID_ALUOp), .MemWrite(ID_MemWrite), .ALUSrc(ID_ALUSrc), .PC_save(ID_PC_save), .Hlt(ID_Hlt), .DMEM_en(ID_DMEM_en),
				  .LB_mode(ID_LB_mode), .LB_result_sel(ID_LB_result_sel), .bLabel_sel(ID_bLabel_sel), .RegWrite(ID_RegWrite), .MemRead(ID_MemRead));

//////////////////////////////////////////////////////////////////////////////////////////////
//Register File //////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//  input clk, - clock signal
//  input rst, - reset signal
//  input [3:0] rs_reg, - source register1 ID
//  input [3:0] rt_reg, - source register2 ID
//  input [3:0] dst_reg, - destination register ID
//  input write_reg, - control signal provided by the control unit, indicates whether to write to register or not
//  input [15:0] dst_data, - data being written to the register
//  inout [15:0] src_data1, - data from source register 1
//  inout [15:0] src_data2 - data from source register 2

// Sign extending the immediate value for SLL, SRA, ROR instruction, for easier calculations later on
assign ID_imm_signext = ({{12{ID_imm[3]}}, ID_imm});
// Selecting rt_reg, incase of LLB or LHB instruction, we load the register to which we are going to load back to again
assign ID_rs_reg = ID_RegSel_rs ? ID_rd : ID_rs;
// Selecting rs_reg, incase of SW instruction, we are loading the register value from register file
assign ID_rt_reg = ID_RegSel_rt ? ID_rd : ID_rt;
// Destination register is always rd
assign ID_rd_reg = ID_rd;

register_file iREGFILE(.clk(clk), .rst(rst), .rs_reg(ID_rs_reg), .rt_reg(ID_rt_reg), .dst_reg(WB_rd_reg), .write_reg(WB_RegWrite), .write_en(!data_miss_stall),
					   .dst_data(WB_result), .rs_data(ID_rs_reg_data), .rt_data(ID_rt_reg_data), .RF_bypass_en1(RF_bypass_en1), .RF_bypass_en2(RF_bypass_en2));

//////////////////////////////////////////////////////////////////////////////////////////////
//ID/EX Pipeline Register ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

ID_EX_Register iID_EX_REG(.clk(clk), .rst(rst), .ID_EX_en(ID_EX_en), .ID_EX_flush(ID_EX_flush), .ID_opcode(ID_opcode), .ID_rs_reg(ID_rs_reg),
						  .ID_rt_reg(ID_rt_reg), .ID_rd_reg(ID_rd_reg), .ID_rs_reg_data(ID_rs_reg_data), .ID_rt_reg_data(ID_rt_reg_data), 
						  .ID_imm_signext(ID_imm_signext), .ID_load_byte(ID_load_byte), .ID_PC_nxt(ID_PC_nxt), .ID_PC_save(ID_PC_save),
						  .ID_Hlt(ID_Hlt), .ID_MemtoReg(ID_MemtoReg), .ID_ALUOp(ID_ALUOp), .ID_MemWrite(ID_MemWrite), .ID_ALUSrc(ID_ALUSrc),
						  .ID_DMEM_en(ID_DMEM_en), .ID_LB_mode(ID_LB_mode), .ID_LB_result_sel(ID_LB_result_sel), .ID_RegWrite(ID_RegWrite), .ID_MemRead(ID_MemRead),
						  
						  .EX_opcode(EX_opcode), .EX_rs_reg(EX_rs_reg), .EX_rt_reg(EX_rt_reg), .EX_rd_reg(EX_rd_reg), .EX_rs_reg_data(EX_rs_reg_data), 
						  .EX_rt_reg_data(EX_rt_reg_data), .EX_imm_signext(EX_imm_signext), .EX_load_byte(EX_load_byte), .EX_PC_nxt(EX_PC_nxt), 
						  .EX_PC_save(EX_PC_save), .EX_Hlt(EX_Hlt), .EX_MemtoReg(EX_MemtoReg), .EX_ALUOp(EX_ALUOp), .EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead),
						  .EX_ALUSrc(EX_ALUSrc), .EX_DMEM_en(EX_DMEM_en), .EX_LB_mode(EX_LB_mode), .EX_LB_result_sel(EX_LB_result_sel), .EX_RegWrite(EX_RegWrite));

//////////////////////////////////////////////////////////////////////////////////////////////
//ALU Block //////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

//	input [15:0]a, - 1st input to ALU
//	input [15:0]b, - 2nd input to ALU
//	input [2:0] ALUOp, - Operation to be performed, from control unit
//	output [15:0]result, - Result from ALU unit
//	output ovfl, - Overflow flag
//	output zero, - Zero flag
//	output sign - Negative Flag

// Operand1 to ALU is always EX_rs_reg_data
assign EX_operand1 = (EX_rs_data_sel == 2'b00) ? (EX_DMEM_en ? (EX_rs_reg_data & 16'hFFFE) : EX_rs_reg_data) :
					 (EX_rs_data_sel == 2'b01) ? (EX_DMEM_en ? (WB_result & 16'hFFFE) : WB_result) :
					 (EX_rs_data_sel == 2'b10) ? (EX_DMEM_en ? (MEM_Fresult & 16'hFFFE) : MEM_Fresult) : 
					 16'hxxxx;

// Operand2 can either be a register value or Immediate value based on instruction (SLL, SRA, ROR, LW, SW)
assign EX_operand2 = (EX_rt_data_sel == 2'b00) ? (EX_ALUSrc ? EX_DMEM_en ? (EX_imm_signext << 1) : EX_imm_signext : EX_rt_reg_data) :
					 (EX_rt_data_sel == 2'b01) ? (EX_ALUSrc ? EX_DMEM_en ? (EX_imm_signext << 1) : EX_imm_signext : WB_result) : 
					 (EX_rt_data_sel == 2'b10) ? (EX_ALUSrc ? EX_DMEM_en ? (EX_imm_signext << 1) : EX_imm_signext : MEM_Fresult) :
					 16'hxxxx;

ALU_Top iALU(.a(EX_operand1), .b(EX_operand2), .ALUOp(EX_ALUOp), .result(EX_ALU_result), .ovfl(EX_ovfl), .zero(EX_zero), .sign(EX_sign));

//////////////////////////////////////////////////////////////////////////////////////////////
//LLB and LHB Block //////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

//	input mode, // 1 - LHB, 0 - LLB, from control unit to select between loading LB or HB
//	input [15:0] a, - current contents of dst_reg
//	input [7:0] load_byte, - value to be loaded
//	output [15:0] result - register value after laoding
 
LLB_LHB iLB(.mode(EX_LB_mode), .a(EX_operand1), .load_byte(EX_load_byte), .result(EX_LB_result));

assign EX_Fresult = EX_LB_result_sel ? EX_LB_result : EX_ALU_result;

//////////////////////////////////////////////////////////////////////////////////////////////
//EX/MEM Pipeline Register ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

assign EX_rt_reg_data_temp = (EX_rt_data_sel == 2'b00) ? (EX_rt_reg_data) :
							(EX_rt_data_sel == 2'b01) ? (WB_result) : 
							(EX_rt_data_sel == 2'b10) ? ( MEM_Fresult) :
							16'hxxxx;

EX_MEM_Register iEX_MEM_REG(.clk(clk), .rst(rst), .EX_MEM_en(EX_MEM_en), .EX_MEM_flush(ID_EX_flush), .EX_opcode(EX_opcode), .EX_rs_reg(EX_rs_reg),
						  .EX_rt_reg(EX_rt_reg), .EX_rd_reg(EX_rd_reg), .EX_rt_reg_data(EX_rt_reg_data_temp), .EX_ALU_result(EX_ALU_result),
						  .EX_LB_result(EX_LB_result), .EX_Fresult(EX_Fresult), .EX_PC_nxt(EX_PC_nxt), .EX_ovfl(EX_ovfl), .EX_zero(EX_zero), .EX_sign(EX_sign), 
						  .EX_PC_save(EX_PC_save), .EX_Hlt(EX_Hlt), .EX_MemtoReg(EX_MemtoReg), .EX_MemWrite(EX_MemWrite), .EX_DMEM_en(EX_DMEM_en),
						  .EX_LB_result_sel(EX_LB_result_sel), .EX_RegWrite(EX_RegWrite), .EX_MemRead(EX_MemRead),
						  
						  .MEM_opcode(MEM_opcode), .MEM_rs_reg(MEM_rs_reg), .MEM_rt_reg(MEM_rt_reg), .MEM_rd_reg(MEM_rd_reg), .MEM_rt_reg_data(MEM_rt_reg_data),
						  .MEM_ALU_result(MEM_ALU_result), .MEM_LB_result(MEM_LB_result), .MEM_Fresult(MEM_Fresult), .MEM_PC_nxt(MEM_PC_nxt), .MEM_ovfl(MEM_ovfl),  
						  .MEM_zero(MEM_zero), .MEM_sign(MEM_sign), .MEM_PC_save(MEM_PC_save), .MEM_Hlt(MEM_Hlt), .MEM_MemtoReg(MEM_MemtoReg), .MEM_MemWrite(MEM_MemWrite), 
						  .MEM_DMEM_en(MEM_DMEM_en), .MEM_LB_result_sel(MEM_LB_result_sel), .MEM_RegWrite(MEM_RegWrite), .MEM_MemRead(MEM_MemRead));

assign MEM_mem_data_in = MEM_data_in_sel ? WB_result : MEM_rt_reg_data;

//////////////////////////////////////////////////////////////////////////////////////////////
//Data Memory Block //////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

//  output [DWIDTH-1:0] data_out, - Data read from memory for LW instruction
//  input [DWIDTH-1:0] data_in, - Data to be stored in the memory for SW instruction
//  input [AWIDTH-1:0] addr,  // byte address, all accesses must be 2-byte aligned; [0] is ignored. - Address, calculated by ALU
//  input enable, - enables the Data memory block, from control unit
//  input wr, - enables writing to data memory, from control unit
//  input clk, - clock signal
//  input rst - reset signal

// memory1c_data iDATAMEM(.data_out(MEM_data_mem_out), .data_in(MEM_mem_data_in), .addr(MEM_Fresult),
					//    .enable(MEM_DMEM_en), .wr(MEM_MemWrite), .clk(clk), .rst(rst));


//////////////////////////////////////////////////////////////////////////////////////////////
//EX/MEM Pipeline Register ////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

MEM_WB_Register iMEM_WB_REG(.clk(clk), .rst(rst), .MEM_WB_en(MEM_WB_en), .MEM_WB_flush(MEM_WB_flush), .MEM_opcode(MEM_opcode), .MEM_rs_reg(MEM_rs_reg), .MEM_rt_reg(MEM_rt_reg), 
							.MEM_rd_reg(MEM_rd_reg), .MEM_ALU_result(MEM_ALU_result), .MEM_LB_result(MEM_LB_result), .MEM_Fresult(MEM_Fresult), .MEM_data_mem_out(MEM_data_mem_out), 
							.MEM_PC_nxt(MEM_PC_nxt), .MEM_ovfl(MEM_ovfl), .MEM_zero(MEM_zero), .MEM_sign(MEM_sign), .MEM_PC_save(MEM_PC_save), .MEM_Hlt(MEM_Hlt), .MEM_MemtoReg(MEM_MemtoReg), 
							.MEM_LB_result_sel(MEM_LB_result_sel), .MEM_RegWrite(MEM_RegWrite), .MEM_MemRead(MEM_MemRead),
							
							.WB_opcode(WB_opcode), .WB_rs_reg(WB_rs_reg), .WB_rt_reg(WB_rt_reg), .WB_rd_reg(WB_rd_reg), .WB_ALU_result(WB_ALU_result), .WB_LB_result(WB_LB_result),
						    .WB_Fresult(WB_Fresult), .WB_data_mem_out(WB_data_mem_out), .WB_PC_nxt(WB_PC_nxt), .WB_ovfl(WB_ovfl), .WB_zero(WB_zero), .WB_MemRead(WB_MemRead),
						    .WB_sign(WB_sign), .WB_PC_save(WB_PC_save), .WB_Hlt(WB_Hlt), .WB_MemtoReg(WB_MemtoReg), .WB_LB_result_sel(WB_LB_result_sel), .WB_RegWrite(WB_RegWrite));

//////////////////////////////////////////////////////////////////////////////////////////////
//Register Write Back ////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

// Our final output can be either the LB_result or ALU_result or Data_mem output. We select based on the instruction
// assign EX_result = WB_MemtoReg ? WB_data_mem_out : WB_LB_result_sel ? WB_LB_result : WB_ALU_result;
// For SW instruction, the data to be loaded to memory is always present on the rt_data port of register file
// assign data_mem_in = rt_data;
// Making the hlt output signal high when an HLT instruction comes along
assign hlt = WB_Hlt;

// Incase of a PC_save instruction, we are loading the current value of PC + 2 into specified rd register
assign WB_result = WB_PC_save ? WB_PC_nxt : 
				   WB_MemtoReg ? WB_data_mem_out :
				   WB_Fresult;

// assign IF_ID_data_stall = 1'b1;
assign ID_EX_en = !data_miss_stall;
assign EX_MEM_en = !data_miss_stall;
assign MEM_WB_en = !data_miss_stall;

assign IF_ID_flush = 1'b0;
assign ID_EX_flush = 1'b0;
assign EX_MEM_flush = 1'b0;
assign MEM_WB_flush = 1'b0;

// assign FLAG_bypass_ovfl = 1'b0;
// assign FLAG_bypass_zero = 1'b0;
// assign FLAG_bypass_sign = 1'b0;

// assign RF_bypass_en1 = 1'b0;
// assign RF_bypass_en2 = 1'b0;


endmodule