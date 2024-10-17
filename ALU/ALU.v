module ALU (
    input [3:0] ALUCntrl,
    input [31:0] A,B,
    output reg [31:0] ALUOut,
    output zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not 

    // TODO: implement your ALU here
    // Hint: you can use operator to implement
always@(*)
begin
	case(ALUCntrl)
		4'b0010: ALUOut = A+B; //add
		4'b0110: ALUOut = A-B; //subtract
		4'b0000: ALUOut = A&B; //AND
		4'b0001: ALUOut = A|B; //OR
		4'b0011: ALUOut = A^B; //XOR
		4'b0100: ALUOut = ($signed(A)<$signed(B))? 1:0; //set less than
		4'b0101: ALUOut = (A<B)? 1:0; //set less than unsigned
		4'b1010: ALUOut = A<<B; //shift left logical
		4'b1000: ALUOut = A>>B; //shift right logical
		4'b1001: ALUOut = A>>>B; //shift logical left


	endcase
end
    
endmodule
