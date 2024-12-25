module forward_unit (
    input [3:0] ex_mem_rd,    // ex_mem_rd can be rd for ALU instruction and rt for lw instruction 
    input [3:0] mem_wb_rd,
    input [3:0] id_ex_rs,        // LLB, LHB rd reg is sent in this rs reg
    input [3:0] id_ex_rt,
    input [3:0] ex_mem_rt,
    input mem_wb_MemRead,
    input ex_mem_RegWrite,
    input mem_wb_RegWrite,
    input ex_mem_MemWrite,
    output [1:0] forwardA,
    output [1:0] forwardB,
    output mem_to_mem
);

wire mem_to_ex_A;
wire mem_to_ex_B;
wire ex_to_ex_A;
wire ex_to_ex_B;

// conditions to enable ex-to-ex forwarding 
assign ex_to_ex_A = (ex_mem_RegWrite & |ex_mem_rd)   ?   (ex_mem_rd == id_ex_rs)  :    1'h0;
assign ex_to_ex_B = (ex_mem_RegWrite & |ex_mem_rd)   ?   (ex_mem_rd == id_ex_rt)  :    1'h0;

// conditions to enable mem-to-ex forwarding 
assign mem_to_ex_A = (mem_wb_RegWrite & |mem_wb_rd)   ?    (mem_wb_rd == id_ex_rs)   :   1'h0;
assign mem_to_ex_B = (mem_wb_RegWrite & |mem_wb_rd)   ?    (mem_wb_rd == id_ex_rt)   :   1'h0;       // Considering mem-to-mem forwarding

// prioratise ex-to-ex forwarding over mem-to-ex
assign forwardA = ex_to_ex_A   ?   2'b10   :   (mem_to_ex_A   ?   2'b01   :   2'b00);       
assign forwardB = ex_to_ex_B   ?   2'b10   :   (mem_to_ex_B   ?   2'b01   :   2'b00);  

// mem-to-mem forwarding 
assign mem_to_mem = (mem_wb_MemRead & |mem_wb_rd & ex_mem_MemWrite)   ?   (mem_wb_rd == ex_mem_rt)   :   1'h0;

endmodule