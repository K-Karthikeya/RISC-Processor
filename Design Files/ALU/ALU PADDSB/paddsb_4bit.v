module paddsb (
    input [3:0] a, b,
    output [3:0] result
);

wire Overflow; 
wire Positive_Saturation;
wire Negative_Saturation;
wire [3:0] sum;
wire c;

CLA_4bit Add4bit(.a(a), .b(b), .sum(sum), .cin(1'b0), .cout(c));

assign Positive_Saturation  = (~a[3]) & (~b[3]) & (sum[3]); 
assign Negative_Saturation = (a[3] & b[3] & (~sum[3]));     

assign Overflow = Positive_Saturation | Negative_Saturation;  


assign result = Positive_Saturation ? 4'b0111 :    // Saturate to +7
                Negative_Saturation ? 4'b1000 :    // Saturate to -8
                sum;                // No saturation, use the computed sum

endmodule
