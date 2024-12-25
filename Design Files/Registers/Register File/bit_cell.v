module bit_cell(
  input clk,
  input rst,
  input d,
  input wren,
  input rden1,
  input rden2,
  inout bitline1,
  inout bitline2
);
	wire q_out;
	dff b_cell(.clk(clk), .rst(rst), .d(d), .wen(wren), .q(q_out));
	assign bitline1 = rden1 ? q_out : 1'bz;
	assign bitline2 = rden2 ? q_out : 1'bz;

endmodule
