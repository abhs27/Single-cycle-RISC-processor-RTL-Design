module ALU (
    input [3:0] ALUCtl,
    input [31:0] A,B,
    output reg [31:0] ALUOut,
    output zero,
    output msb //use this to determine greater than
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not 

    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    
//----------------------------------------------------
//NOTE:
//BGT is a psuedo instruction in the RISCV ISA, ie, it is not an instruction
//by itself, but is comprised of slt and beq instructions.
//this implementation of the ALU includes functionality for BGE which is 
//an instruction in the ISA, thus the need for 'output msb'

    always@(*)
    begin
    case(ALUCtl)
            4'b0010: ALUOut = A+B;//$signed(A)+$signed(B); //add
            4'b0110: ALUOut = A-B;//$signed(A)-$signed(B); //subtract
            4'b0001: ALUOut = A|B; //OR
            4'b0011: ALUOut = (A<B)? 1:0; //slti
            4'b0100: ALUOut = ($signed(A)<$signed(B))? 1:0; //set less than
            4'b1101: ALUOut = A^B; //xor
            4'b1110: ALUOut = A & B; //AND
            4'b0111: ALUOut = A<<B; //sll
            4'b1000: ALUOut = A>>B; //srl
            4'b1001: ALUOut = A>>>B; //sra
                        
            default: ALUOut = 32'hXXXXXXXX; //invalid case
            	endcase
        end
            assign zero = ~(|ALUOut);
            assign msb = ALUOut[31]; //used to control branching for BGE
endmodule

