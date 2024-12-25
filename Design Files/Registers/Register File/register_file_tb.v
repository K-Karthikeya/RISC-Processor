module register_file_tb;
  reg clk;
  reg rst;
  reg [3:0] src_reg1;
  reg [3:0] src_reg2;
  reg [3:0] dst_reg;
  reg write_reg;
  reg [15:0] dst_data;
  wire [15:0] src_data1;
  wire [15:0] src_data2;

integer i;
register_file iDUT(.clk(clk),
									 .rst(rst),
									 .src_reg1(src_reg1),
									 .src_reg2(src_reg2),
									 .dst_reg(dst_reg),
									 .write_reg(write_reg),
									 .dst_data(dst_data),
									 .src_data1(src_data1),
									 .src_data2(src_data2));

initial begin 
	clk = 0;
	rst = 1;
	repeat(2) @(posedge clk);
	@(negedge clk) rst = 0;	
end

initial begin
	wait(!rst);

	for(i = 0; i < 16; i = i+1) begin
		write_reg = 1'b1;
		src_reg1 = 4'h0;
		src_reg2 = 4'h0;
		dst_reg = i;
		dst_data = i*4 + 5;
		@(negedge clk);
	end

	for(i = 0; i < 16; i = i+1) begin
		write_reg = 1'b0;
		src_reg1 = i;
		src_reg2 = i;
		dst_reg = 4'h0;
		dst_data = 16'h0000;
		@(negedge clk);
	end

	/*wait(!rst);
	write_reg = 1'b1;
	src_reg1 = 4'h6;
	src_reg2 = 4'h8;
	dst_reg = 4'h7;
	dst_data = 16'h7459;

	@(negedge clk);
	write_reg = 1'b0;
	src_reg1 = 4'h7;
	src_reg2 = 4'h7;
	dst_reg = 4'h6;
	dst_data = 16'h0959;
	
	@(negedge clk);
	write_reg = 1'b0;
	src_reg1 = 4'h6;
	src_reg2 = 4'h6;
	dst_reg = 4'h6;
	dst_data = 16'h0959; */

	repeat(5) @(posedge clk);
	$stop;
end


always #5 clk = ~clk;
endmodule 
