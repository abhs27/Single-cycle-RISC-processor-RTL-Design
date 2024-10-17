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
		2b'00 : ALUCntrl = 4b'0010; //load or store word
		2b'01 : ALUCntrl = 4b'0110; //branch
		2b'10 :
		begin
		case(funct3): //checking which R-type instruction
		3b'000 :
			if(funct7)
				ALUCntrl = 4b'0110; //subtract
			else
				ALUCntrl = 4b'0010; //add
		3b'001 : ALUCntrl = 4b'1010; //Shift left logical
		3b'010 : ALUCntrl = 4b'0100; //set less than signed
		3b'011 : ALUCntrl = 4b'0101; //set less than unsigned
		3b'100 : ALUCntrl = 4b'0011; //XOR
		3b'101 : 
			if(funct7) 
				ALUCntrl = 4b'1001; //shift right arithmetic
			else
				ALUCntrl = 4b'1000; //shift right logical
		3b'110 : ALUCntrl = 4b'0001; //OR
		3b'111 : ALUCntrl = 4b'0000; //AND
		end

		 ALUCntrl = 4b'default : ALUCntrl = 4b'1111; //not supposed to happen
end




endmodule
