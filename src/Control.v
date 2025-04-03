module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg [1:0] regsrc,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc, //control signal for ALUsrc mux for rs2
    output reg regWrite,
    output reg jump,
    output reg ALUsrc1 //control signal for ALUsrc mux for rs1
);

always@(*)
begin

//default state for the control signals
branch = 0;
memRead = 0;
regsrc = 0;
ALUOp = 0;
memWrite = 0;
ALUSrc = 0;
regWrite = 0;
jump =0;
ALUsrc1=0;
    // TODO: implement your Control here
    // Hint: follow the Architecture to set output signal
    
    //ALUOp[1:0] ---> 00 = load/store, 01 = branch, 10 = R-type, 11 = I-type
case(opcode)
    7'b0000011 : begin //load instructions lb,lh,lw,lbu,lbhu
        branch = 0;
        memRead = 1;
        regsrc = 1;
        ALUOp = 2'b00;
        memWrite = 0;
        ALUSrc = 1;
        regWrite = 1;
        end
    7'b0100011 : begin //store instructions sb,sh,sw
        branch = 0;
        memRead = 0;
        regsrc = 0;
        ALUOp = 2'b00;
        memWrite = 1;
        ALUSrc = 1;
        regWrite = 0;
        end
    7'b0010011 : begin //all I-type 
        branch = 0;
        memRead = 0;
        regsrc = 0;
        ALUOp = 2'b11;
        memWrite = 0;
        ALUSrc = 1;
        regWrite = 1;
        end
    
    7'b0110011 : begin //all R-type 
        branch = 0;
        memRead = 0;
        regsrc = 0;
        ALUOp = 2'b10;
        memWrite = 0;
        ALUSrc = 0;
        regWrite = 1;
        end
    7'b1100011 : begin // all branch instructions
        branch = 1;
        memRead = 0;
        regsrc = 0;
        ALUOp = 2'b01;
        memWrite = 0;
        ALUSrc = 0;
        regWrite = 0;
        end  
     7'b1101111 : begin // JAL
        branch = 1;
        memRead  =0;
        regsrc = 2'b10;
        ALUOp = 2'b01; //doesnt matter since ALU is not going to be used
        memWrite = 0;
        ALUSrc = 0; //doesnt matter since regsrc will take PC+4
        regWrite = 1; //to write PC+4 into register
        jump=1;
        end
     7'b0110111 : begin //auipc
     branch =0;
     memRead=0;
     regsrc = 0; //result will go through ALU
     ALUOp = 2'b11; //to add the immediate
     ALUSrc = 1; //for immediate
     regWrite = 1;
     ALUsrc1 = 1; //take PC as rs1
     end
     7'b1100111 : begin //jalr
        branch = 1;
        memRead = 0;
        regsrc = 2'b10;
        ALUOp = 2'b11; //I-type ALUop to add the immediate to rs1
        memWrite = 0;
        ALUSrc = 1;
        regWrite = 1;
        jump =1;
     end
     7'b0110111 : begin //lui
        branch=0;
        memRead=0;
        regsrc=2'b11;
        ALUOp = 2'b01; //doesnt matter regsrc will take upperimm
        memWrite=0;
        ALUSrc = 1; //doesnt matter regsrc will take upperimm
        regWrite=1;
        end
     default: begin // default case so no latches are created
        branch = 0;
        memRead = 0;
        regsrc = 0;
        ALUOp = 0;
        memWrite = 0;
        ALUSrc = 0;
        regWrite = 0;
        end    
endcase

end                                
endmodule




