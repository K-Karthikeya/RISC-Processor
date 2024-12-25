module flag_registers(
    input clk,
    input rst,
    input ovfl_i,
    input zero_i,
    input sign_i,
    input FLAG_bypass_ovfl,
    input FLAG_bypass_zero,
    input FLAG_bypass_sign,
    input flag_en,
    output ovfl,
    output zero,
    output sign
);

wire ovfl_o, zero_o, sign_o;
// wire WB_ovfl_i, WB_zero_i, WB_sign_i; // Only updated at the end of WB stage
// Overflow Flag
dff OVFL(.q(ovfl_o), .d(ovfl_i), .clk(clk), .rst(rst), .wen( flag_en ) ); 
// Zero Flag
dff ZERO(.q(zero_o), .d(zero_i), .clk(clk), .rst(rst), .wen( flag_en ) );
// Negative Flag
dff SIGN(.q(sign_o), .d(sign_i), .clk(clk), .rst(rst), .wen( flag_en ) );

assign ovfl = FLAG_bypass_ovfl ? ovfl_i : ovfl_o;
assign zero = FLAG_bypass_zero ? zero_i : zero_o;
assign sign = FLAG_bypass_sign ? sign_i : sign_o;

endmodule
