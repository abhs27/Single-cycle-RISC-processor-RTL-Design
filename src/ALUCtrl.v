module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU ALUCtl here
   // Hint: using ALUOp, funct7, funct3 to select exact operation
// for given sample instruction set the below ALUCtl values are mapped as such:
//   ALUCntl :
//   0000 = AND
//   0001 = OR
//   0010 = add
//   0110 = subtract

always@(*)
begin
case(ALUOp)
2'b00 : ALUCtl = 4'b0010; // load-store (ALU needs to add the imm.)
2'b01 : ALUCtl = 4'b0110; //branch (ALU computes the branch condition by subtracting)

2'b10 : // R-type
begin
    case(funct3)
    3'b000 : begin
    if(funct7)
        ALUCtl = 4'b0110; //SUB
    else
        ALUCtl = 4'b0010;//ADD
    end
    3'b010 : ALUCtl = 4'b0100;//SLTI operation
    3'b011 : ALUCtl = 4'b0011; //slti
    3'b100 : ALUCtl = 4'b1101; //xor
    3'b110 : ALUCtl = 4'b0001; //OR
    3'b111 : ALUCtl = 4'b1110; //and
    3'b001 : ALUCtl = 4'b0111; //sll
    3'b101 :begin
            if(funct7) 
                ALUCtl = 4'b1001; //sra
            else 
                ALUCtl = 4'b1000; //srl
            end
     default : ALUCtl = 4'b1111; //invalid ALUCtl
     endcase
    
    
end

   
2'b11 : //I-type
begin
    case(funct3)
    3'b000 : ALUCtl = 4'b0010; //ADDI
    3'b010 : ALUCtl = 4'b0100;//SLTI operation
    3'b011 : ALUCtl = 4'b0011; //sltiu
    3'b100 : ALUCtl = 4'b1101; //xori
    3'b110 : ALUCtl = 4'b0001; //ORI
    3'b111 : ALUCtl = 4'b1110; //andi
    3'b001 : ALUCtl = 4'b0111; //slli
    3'b101 :begin
            if(funct7) 
                ALUCtl = 4'b1001; //srai
            else 
                ALUCtl = 4'b1000; //srli
            end
    default : ALUCtl = 4'b1111; //invalid ALUCtl
    endcase
end
//no default case since all two bits of ALUOp used up
//thus no latch will be created even if default case is not included
endcase

end
endmodule

