module paddsb_16bit_tb;
	reg [15:0] a;
	reg [15:0] b;
	wire [15:0] result;
	wire ovfl;
	wire zero;
	wire sign; 

paddsb_16bit iDUT(.a(a), .b(b), .result(result), .ovfl(ovfl), .zero(zero), .sign(sign));

initial begin
a = 16'h1234;
b = 16'h1234;

#10;

a = 16'h89AB;
b = 16'h123F;

#10;

a = 16'h9701;
b = 16'h970F;
#10 $stop;
end

endmodule