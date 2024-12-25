module ALU_Shifter(
	input[15:0] a, // Value that is being shifted
	input [3:0] b, // By what value is it being shifter
	input [1:0] mode, // 00 - SLL, 01 - SRA, 10 - ROR; These values are based on project documents
	output [15:0] result,
	output zero,
	output sign,
	output ovfl
);

// Two bits of base3_b represents 1 bit of a base3 number. Ex. (2)base3 = (10)base2; (21)base3 = (10 01)base2
wire [5:0] base3_b; // Holds the base3 number but in binary format
wire [15:0] sll_result;
wire [15:0] sra_result;
wire [15:0] ror_result;

// Mapping base2 numbers to base3 numbers
base3_conv iCONV(.base2_in(b), .base3_out(base3_b));

// SLL Operation
shifter_sll iSLL(.a(a), .base3_b(base3_b), .out(sll_result));
// SRA Operation
shifter_sra iSRA(.a(a), .base3_b(base3_b), .out(sra_result));
// ROR Operation
shifter_ror iROR(.a(a), .base3_b(base3_b), .out(ror_result));

assign result = (mode == 2'b00) ? sll_result : (mode == 2'b01) ? sra_result : (mode == 2'b10) ? ror_result : 16'hxxxx; 

assign zero = !(|result);
assign sign = 1'bz;
assign ovfl = 1'bz;

endmodule

//wire [15:0] shift_by1;
//wire [15:0] shift_by2;
//wire [15:0] shift_by4;
//
//assign shift_by1 = 	b[0] ?
//										mode[1] ? {a[0], a[15:1]} : 
//										mode[0] ? {a[15], a[15:1]} : {a[14:0], 1'b0} :
//										a[15:0];
//assign shift_by2 = 	b[1] ?
//										mode[1] ? {shift_by1[1:0], shift_by1[15:2]} : 
//										mode[0] ? {{2{shift_by1[15]}}, shift_by1[15:2]} : {shift_by1[13:0], {2{1'b0}}} :
//										shift_by1[15:0];
//assign shift_by4 = 	b[2] ?
//										mode[1] ? {shift_by2[3:0], shift_by2[15:4]} :  
//										mode[0] ? {{4{shift_by2[15]}}, shift_by2[15:4]} : {shift_by2[11:0], {4{1'b0}}} :
//										shift_by2[15:0];
//assign result	   =	b[3] ?
//										mode[1] ? {shift_by1[7:0], shift_by1[15:8]} : 
//										mode[0] ? {{8{shift_by4[15]}}, shift_by4[15:8]} : {shift_by4[7:0], {8{1'b0}}} :
//										shift_by4[15:0];
//
//assign zero = !(|result);
//assign sign = 1'bz;
//assign ovfl = 1'bz;


