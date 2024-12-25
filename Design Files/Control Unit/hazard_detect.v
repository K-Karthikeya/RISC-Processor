module hazard_detect (
    input [3:0] id_ex_rd,
    input [3:0] new_ex_mem_rd,
    input id_ex_MemRead,
    input [3:0] if_id_rs,       // LLB, LHB rd reg is sent in this rs reg
    input [3:0] if_id_rt,
    input mem_wb_RegWrite,
    input [3:0] mem_wb_rd,
    input [3:0] curr_opcode,
    input if_id_branch,
    input if_id_MemWrite,
    output reg stall,               // signal to stall the pipeline
    output bypass_rs,               // signal to enable rf bypassing
    output bypass_rt
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

    reg hazard;
    reg en_bypass_rs;
    reg en_bypass_rt;


always @(*) begin
    // hazard = 1'b0;
    case (curr_opcode)
         SLL, SRA, ROR, LW, LLB, LHB :   begin 
                                        // hazard = (if_id_rs == ex_mem_rd);
                                        stall = (id_ex_MemRead & |id_ex_rd)   ?   (id_ex_rd == if_id_rs)   :   1'h0;
                                        en_bypass_rs = (if_id_rs == mem_wb_rd);
                                        en_bypass_rt = 1'h0;
                                    end

        ADD, SUB, XOR, RED, PADDSB, SW: begin 
                                        // hazard = (if_id_rs == ex_mem_rd)|(if_id_rt == ex_mem_rd);
                                        stall = (id_ex_MemRead & |id_ex_rd)   ?   ((id_ex_rd == if_id_rs) | ((id_ex_rd == if_id_rt) & ~if_id_MemWrite))   :   1'h0;
                                        en_bypass_rs = (if_id_rs == mem_wb_rd);
                                        en_bypass_rt = (if_id_rt == mem_wb_rd);

                                    end
        BR:                         begin
                                        stall = if_id_branch   ?   ((if_id_rs == new_ex_mem_rd) | (if_id_rs == id_ex_rd))   :   1'h0;
                                        en_bypass_rs = (if_id_rs == mem_wb_rd);
                                        en_bypass_rt = 1'h0;
                                    end
        // For B, PCS, HLT instructions
        default:                    begin
                                        stall = 1'h0;      // don't need to read from any registers   
                                        en_bypass_rs = 1'h0;
                                        en_bypass_rt = 1'h0;
                                    end
    endcase
end

// assign stall = (ex_mem_MemRead |  if_id_branch) ?   hazard   :   1'h0;
// assign hazard = (id_ex_MemRead & |id_ex_rd)   ?   (id_ex_rd == if_id_rs)   :   
//                                                   ((id_ex_rd == if_id_rt) & ~if_id_MemWrite) : 1'h0;
// assign stall = hazard;
assign bypass_rs = mem_wb_RegWrite   ?   en_bypass_rs   :   1'h0;
assign bypass_rt = mem_wb_RegWrite   ?   en_bypass_rt   :   1'h0;

endmodule
