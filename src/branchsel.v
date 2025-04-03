
module branchsel(
    input [2:0] sel,
    input zero,
    input msb,
    input [31:0] A,
    input [31:0] B,
    output reg out 
    );
    
//module to decide on the brnaching condition
//depending on the type of branching instruction
wire unsigned_compare;    
assign unsigned_compare =(A>B)? 1 : 0; 
always@(*) 
begin
case(sel)

3'b000 : out = zero; //beq
3'b001 : out = ~zero; //bne
3'b100 : out = msb; //blt ; msb works for signed comparison
3'b101 : out = ~msb; //bge ; msb works for signed comparison
3'b110 : out = unsigned_compare; //bltu
3'b111 : out = ~unsigned_compare;//bgeu
default: out = 0;

endcase
end
endmodule
