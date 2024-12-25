
module LLB_LHB(
	input mode, // 1 - LHB, 0 - LLB
	input [15:0] a,
	input [7:0] load_byte,
	output [15:0] result
);

wire [15:0] clr_result;

assign clr_result = mode ? (a & 16'h00FF) : (a & 16'hFF00) ;
assign result = mode ? (clr_result | {load_byte, 8'h00}) : (clr_result | {8'h00, load_byte});
	
endmodule