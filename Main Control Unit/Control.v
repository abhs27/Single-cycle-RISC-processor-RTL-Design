module Control (
    input [6:0] opcode,
    output  reg branch,
    output  reg memRead,
    output  reg memtoReg,
    output  reg [1:0] ALUOp,
    output  reg memWrite,
    output  reg ALUSrc,
    output  reg regWrite
    );

    // TODO: implement your Control here
    // Hint: follow the Architecture to set output signal
always@(*)
begin

branch = 0;
memRead = 0;
memtoReg = 0;
ALUOp = 0;
memWrite = 0;
ALUSrc = 0;
regWrite = 0;

	case(opcode[5:4]) //using xbbxxxx bits to differentiate between the instructions given
	2'b00 : begin //lw
		ALUOp = 2'b00; //ALUOp for lw,sw
		memRead = 1;
		memtoReg = 1;
		regWrite = 1;	
		ALUSrc = 1; //using immediate
		end

	2'b10 : begin //sw or beq
		if(opcode[6]) //beq
		begin
			branch = 1;
			ALUOp = 2'b01;
		end
		else // sw
		begin
			ALUOp = 2'b00;
			memWrite = 1;
			ALUSrc = 1; //using immediate
		end
		end

	2'b01 : begin //I-type 
		ALUSrc = 1;
		ALUOp = 2'b10; //for arithmetic instructions
		regWrite = 1;
		end

	2'b01 : begin //R-type 
		ALUSrc = 0;
		ALUOp = 2'b10; //for arithmetic instructions
		regWrite = 1;
		end
	endcase

	
end

endmodule



