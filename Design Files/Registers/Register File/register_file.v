module register_file(
  input clk,
  input rst,
  input [3:0] rs_reg,
  input [3:0] rt_reg,
  input [3:0] dst_reg,
  input write_reg,
  input RF_bypass_en1,
  input RF_bypass_en2,
  input [15:0] dst_data,
  input write_en,
  inout [15:0] rs_data,
  inout [15:0] rt_data
);

wire [15:0] src_data1;
wire [15:0] src_data2;

wire [15:0]rd1_reg_select;
wire [15:0]rd2_reg_select;
wire [15:0]wr1_reg_select;
wire [15:0]wr2_reg_select;

read_decoder_4_16 rd_dec_1(.reg_id(rs_reg), .wordline(rd1_reg_select));
read_decoder_4_16 rd_dec_2(.reg_id(rt_reg), .wordline(rd2_reg_select));
write_decoder_4_16 wr_dec(.reg_id(dst_reg), .wordline(wr1_reg_select));

register reg_file16[15:0] (.clk(clk),
													 .rst(rst),
													 .d(dst_data),
													 .write_reg(wr2_reg_select & {16{write_en}}),
										 			 .rden1(rd1_reg_select),
													 .rden2(rd2_reg_select),
													 .bitline1(src_data1),
													 .bitline2(src_data2));

assign src_data1 = (rs_reg == 4'h0) ? 16'h0000 : 16'hzzzz;
assign src_data2 = (rt_reg == 4'h0) ? 16'h0000 : 16'hzzzz;
assign wr2_reg_select = write_reg ? wr1_reg_select : 16'h0000;

assign rs_data = RF_bypass_en1 ? dst_data : src_data1;
assign rt_data = RF_bypass_en2 ? dst_data : src_data2;

endmodule