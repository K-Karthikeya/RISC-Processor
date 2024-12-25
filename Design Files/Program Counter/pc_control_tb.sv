
typedef enum reg[2:0] {BNE, BE, BGT, BLT, BGE, BLE, BO, UCD} conditions;

module pc_control_tb;
conditions c;
reg branch; 
reg signed [8:0] imm;
reg [2:0] f; // f[2] = N; f[1] = O; f[0] = Z
reg [15:0] pc_in;
wire [15:0] pc_out;

integer j;

pc_control iDUT(.branch(branch),
								.c(c),
								.imm(imm),
								.f(f),
								.pc_in(pc_in),
								.pc_out(pc_out));

initial begin
	for( j = 0; j < 100; j = j+1) begin
	branch = $urandom();
	c = conditions'($urandom());
	f = $random();
	pc_in = $urandom_range(0, ($pow(2,16) - 15));
	imm = ($pow(-1, $urandom_range(0, 23)))*($urandom_range(0, 7));
	#10;
end
	$stop;
end
	
endmodule