module register_file(
  input clk,
  input rst,
  input [3:0] src_reg1,
  input [3:0] src_reg2,
  input [3:0] dst_reg,
  input write_reg,
  input [15:0] dst_data,
  inout [15:0] src_data1,
  inout [15:0] src_data2
);

wire [15:0]rd1_reg_select;
wire [15:0]rd2_reg_select;
wire [15:0]wr1_reg_select;
wire [15:0]wr2_reg_select;

read_decoder_4_16 rd_dec_1(.reg_id(src_reg1), .wordline(rd1_reg_select));
read_decoder_4_16 rd_dec_2(.reg_id(src_reg2), .wordline(rd2_reg_select));
write_decoder_4_16 wr_dec(.reg_id(dst_reg), .wordline(wr1_reg_select));

register reg_file16[15:0] (.clk(clk),
													 .rst(rst),
													 .d(dst_data),
													 .write_reg(wr2_reg_select),
										 			 .rden1(rd1_reg_select),
													 .rden2(rd2_reg_select),
													 .bitline1(src_data1),
													 .bitline2(src_data2));

assign src_data1 = (src_reg1 == 4'h0) ? 16'h0000 : 16'hzzzz;
assign src_data2 = (src_reg2 == 4'h0) ? 16'h0000 : 16'hzzzz;
assign wr2_reg_select = write_reg ? wr1_reg_select : 16'h0000;


endmodule