module ALU (
    input [3:0] ALUCtl,
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
	begin
		4b'0010: ALUOut = A+B; //add
		4b'0110: ALUOut = A-B; //subtract
		4b'0000: ALUOut = A&B; //AND
		4b'0001: ALUOut = A|B; //OR
		4b'0011: ALUOut = A^B; //XOR
		4b'0100: ALUOut = ($signed(A)<$signed(B))? 1:0; //set less than
		4b'0101: ALUOut = (A<B)? 1:0; //set less than unsigned
		4b'1010: ALUOut = A<<B; //shift left logical
		4b'1000: ALUOut = A>>B; //shift right logical
		4b'1001: ALUOut = A>>>B; //shift right arithmetic


	end
end

assign zero = ~(|ALUOut);
    
endmodule
