
module CLA_8bit_tb;
	reg signed [7:0]a;
	reg signed [7:0]b;
	reg mode;
	wire signed [7:0]sum;
	wire cout;
	wire ovfl;

	integer i;
CLA_8bit iDUT(.a(a), .b(b), .mode(mode), .sum(sum), .cout(cout), .ovfl(ovfl));

initial begin
	for( i = 0; i < 100; i = i+1) begin
		a = $random();
		b = $random();
		mode = $random();
		#10;
		if(ovfl ? {cout, sum} : sum == (mode) ? (a-b) : (a+b)) $display("Success");
		else  $display("Failed");
	end
	$stop;
end
endmodule 