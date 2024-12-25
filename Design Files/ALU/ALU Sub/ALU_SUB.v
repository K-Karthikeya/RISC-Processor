module ALU_SUB(
	input [15:0] a,       // First operand
  input [15:0] b,       // Second operand
  output [15:0] result, // Result of the subtraction
  output ovfl,      // Overflow flag (V)
  output zero,      // Zero flag (Z)
  output sign       // Sign flag (N)
);

	wire [15:0] diff;     // Difference of a and b
	wire cout;            // Carry-out from CLA
	wire ovfl_internal;   // Overflow flag from CLA

	// CLA 16-bit adder instantiation for subtraction (mode 1 for subtraction)
	CLA_16bit cla_sub (
		.a(a),
		.b(b), 
		.mode(1),         // Mode 1 for subtraction (a - b)
		.sum(diff), 
		.cout(cout), 
		.ovfl(ovfl_internal)
	);
	
    // Flag and result logic based on the PDF's flag table

	// Set the result based on the CLA output
    assign result = ovfl_internal ? cout ? 16'h8000 : 16'h7FFF : diff;

	// Set overflow flag (V): Set if there is a signed overflow
	// Overflow happens if the signs of a and b are different, but the sign of the result differs from a
	assign ovfl = ovfl_internal;

	// Set zero flag (Z): Set if the result is zero
	assign zero = !(|result);
	
	// Set sign flag (N): Set if the result is negative (MSB is 1)
	assign sign = result[15];


endmodule