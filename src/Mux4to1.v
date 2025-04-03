module Mux4to1 #(
    parameter size = 32
) 
(
    input [1:0] sel,
    input signed [size-1:0] s0, //alu
    input signed [size-1:0] s1, //DM
    input signed [size-1:0] s2, //pc+4
    input signed [size-1:0] s3, //lui
    output reg signed [size-1:0] out
);

//to include functionality for JAL memtoReg MUX now takes three input
//instead of two (a input line for PC+4 is added to store the PC value while JAL)

always@(*)
begin
case(sel)
    2'b00 : out = s0;
    2'b01 : out = s1;
    2'b10 : out = s2;
    2'b11 : out = s3;
endcase
end
endmodule
