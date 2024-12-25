
module ALU_Shifter_tb;
	reg signed [15:0] a; // Value that is being shifted
	reg [3:0] b; // By what value is it being shifter
	reg [1:0] mode; // 00 - SLL, 01 - SRA, 10 - ROR; These values are based on project documents
	wire signed [15:0] result;
	wire zero;
	wire sign;
	wire ovfl;

	reg [15:0] result_tb;
ALU_Shifter iDUT(.a(a), .b(b), .mode(mode), .result(result), .zero(zero), .sign(sign), .ovfl(ovfl));

initial begin
	a = 16'h1234;
	b = 4'h3;
	mode = 2'h0;

	#10;
	if(result === (a << b)) $display("success");
	else $display("Failed");

	a = -16'h1234;
	b = 4'h3;
	mode = 2'h1;

	#10;
	if(result === $signed(a >>> b)) $display("success");
	else $display("Failed");

	a = 16'hF000;
	b = 4'h4;
	mode = 2'h2;
	
	#10;
	result_tb = ({a,a} >> b);
	if(result === result_tb) $display("success");
	else $display("Failed");

	#10 $stop;
end
endmodule