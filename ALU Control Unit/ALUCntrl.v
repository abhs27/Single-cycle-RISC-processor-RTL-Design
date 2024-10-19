module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCntrl
);

    // TODO: implement your ALU ALUCtl here
   // Hint: using ALUOp, funct7, funct3 to select exact operation
always@(*)
begin
	case(ALUOp):begin //checking whether ld/str or B-type or R-type
		2'b00 : ALUCntrl = 4'b0010; //load or store word
		2'b01 : ALUCntrl = 4'b0110; //branch
		2'b10 :
		begin
		case(funct3): //checking which R-type instruction
		3'b000 :
			if(funct7)
				ALUCntrl = 4'b0110; //subtract
			else
				ALUCntrl = 4'b0010; //add
		3'b001 : ALUCntrl = 4'b1010; //Shift left logical
		3'b010 : ALUCntrl = 4'b0100; //set less than signed
		3'b011 : ALUCntrl = 4'b0101; //set less than unsigned
		3'b100 : ALUCntrl = 4'b0011; //XOR
		3'b101 : 
			if(funct7) 
				ALUCntrl = 4'b1001; //shift right arithmetic
			else
				ALUCntrl = 4'b1000; //shift right logical
		3'b110 : ALUCntrl = 4'b0001; //OR
		3'b111 : ALUCntrl = 4'b0000; //AND
		end

		default : ALUCntrl = 4'b1111; //not supposed to happen
end




endmodule
