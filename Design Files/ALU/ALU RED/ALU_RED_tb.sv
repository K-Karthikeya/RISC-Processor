module ALU_RED_tb;
	reg [7:0] a;
	reg [7:0] b;
	reg [7:0] c;
	reg [7:0] d;
	wire [15:0] result; // Result of the reduction
	wire ovfl;      // Overflow flag (V)
	wire zero;      // Zero flag (Z)
	wire sign;       // Sign flag (N)


ALU_RED iDUT(.a({a,b}), .b({c,d}), .result(result), .ovfl(ovfl), .sign(sign), .zero(zero));

initial begin
	for(int i = 0; i < 100; i++) begin
		a = $random();
		b = $random();
		c = $random();
		d = $random();

		#10;
		if(result == (a+b+c+d)) $display("Success %d, %d", result, (a+b+c+d));
		else $display("Failed %d, %d", result, (a+b+c+d));
	end
end

endmodule
