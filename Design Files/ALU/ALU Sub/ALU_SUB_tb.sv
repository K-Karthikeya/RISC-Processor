
module ALU_SUB_tb;
	reg signed [15:0] a;    // First operand
	reg signed [15:0] b;    // Second operand
	wire signed [15:0] result; // Result of the addition
	wire ovfl;   // Overflow flag	
	wire zero;   // Zero flag
	wire sign;   // Sign flag
	reg signed [16:0] result_tb = 16'd0;

	int i;
ALU_SUB iDUT(.a(a), .b(b), .result(result), .ovfl(ovfl), .zero(zero), .sign(sign));

initial begin
	for(i = 0; i < 10000; i++) begin
		a = $random();
		b = $random();
		#10;
		result_tb = a-b;
		result_tb = (result_tb > 32767) ? 32767 : (result_tb < -32768) ? -32768 : result_tb;
		if(result !== result_tb) begin
			$display("%d %d %d", i, result, result_tb);
			break;
		end
	end
	if(i != 10000) $display("Failed");
	else $display("Success");
	#10 $stop;
end
endmodule


