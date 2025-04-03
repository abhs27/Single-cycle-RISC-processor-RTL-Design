module loadsizemux(
    input [31:0] in,
    input [2:0] sel,
    output reg [31:0] out
    );
//wntire word is loaded from DM and then masked
//in this module to a byte/half word/ word depending on the 
//size called for by the load instruction (lb,lh,lw)   
always@(*) begin
case(sel)
3'b000 : out = $signed(in[7:0]);//lb 
3'b001 : out = $signed(in[15:0]);//lh
3'b010 : out = in;//lw
3'b100 : out = in[7:0];//lbu
3'b101 : out = in[15:0];//lhu

endcase
end
endmodule
