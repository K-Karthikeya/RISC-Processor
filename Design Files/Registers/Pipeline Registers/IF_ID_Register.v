module IF_ID_Register(
    input clk,
    input rst,
    input IF_ID_en, // Enable signal to IF_ID_Register
    input IF_ID_flush, // Incase Predict-not-taken policy fails, we flush the pipeline register
    input [15:0] IF_instr, // Current instruction in execution
    input [15:0] IF_PC_nxt, // PC + 2. When PCS, this value can be directly stored, else can be used as next PC
    output [15:0] ID_instr, // Output Instr of this pipeline register
    output [15:0] ID_PC_nxt // Output of next PC
);

pldff #(16) iIF_ID_instr  (.clk(clk), .rst(rst | (IF_ID_flush & IF_ID_en)), .d(IF_instr), .q(ID_instr), .wen(IF_ID_en));
pldff #(16) iIF_ID_PC_nxt  (.clk(clk), .rst(rst | (IF_ID_flush & IF_ID_en)), .d(IF_PC_nxt), .q(ID_PC_nxt), .wen(IF_ID_en));

endmodule
